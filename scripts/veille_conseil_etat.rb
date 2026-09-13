#!/usr/bin/env ruby
# frozen_string_literal: true

# Veille automatique des décisions du Conseil d'État en droit de l'urbanisme.
#
# Exécuté chaque semaine par .github/workflows/veille-conseil-etat.yml : interroge Légifrance
# (API PISTE) pour les 5 dernières décisions contenant le mot "urbanisme" (le filtre de recherche
# `PUBLICATION_RECUEIL: PUBLIE` ne sélectionne déjà que les classifications A — publiée au recueil
# Lebon — et B — mentionnée aux tables —, jamais C/inédit : pas de second contrôle nécessaire côté
# script), écarte celles déjà commentées sur le blog (dédoublonnage par numéro de décision, cf.
# champ `ce_numero` du front matter), rédige un article en français pour CHAQUE décision nouvelle
# via l'API Claude (Anthropic), puis ouvre une Pull Request de relecture par décision — jamais de
# publication directe (cf. CLAUDE.md, point de vigilance déontologique).
#
# Reproduit l'intention du flux n8n "fil public" fourni en référence, avec deux corrections :
#   - le filtre de date codé en dur (une plage fixe, qui se serait périmée à chaque exécution)
#     est remplacé par un simple tri DATE_DESC + pageSize 5 (les 5 décisions les plus récentes,
#     sans plage à remettre à jour manuellement) ;
#   - le nœud IA de sélection de "la" décision la plus importante n'était en réalité relié à
#     rien dans le flux d'origine : ici, un article est rédigé pour CHAQUE décision parmi les 5
#     qui n'a pas déjà été commentée (cf. échange avec le porteur du projet).
#
# Secrets GitHub requis (Settings > Secrets and variables > Actions) :
#   PISTE_CLIENT_ID, PISTE_CLIENT_SECRET  — compte API PISTE (https://piste.gouv.fr)
#   ANTHROPIC_API_KEY                     — clé API Anthropic (console.anthropic.com)
# (GITHUB_TOKEN est fourni automatiquement par Actions, avec les permissions posées dans le
# workflow : contents: write, pull-requests: write.)

require "net/http"
require "uri"
require "json"
require "yaml"
require "set"
require "time"
require "date"
require "anthropic"

REPO_ROOT = File.expand_path("..", __dir__)
POSTS_DIR = File.join(REPO_ROOT, "blog", "_posts")
DOMAINES_YML = File.join(REPO_ROOT, "_data", "domaines.yml")

PISTE_TOKEN_URL = "https://oauth.piste.gouv.fr/api/oauth/token"
LEGIFRANCE_SEARCH_URL = "https://api.piste.gouv.fr/dila/legifrance/lf-engine-app/search"
LEGIFRANCE_CONSULT_URL = "https://api.piste.gouv.fr/dila/legifrance/lf-engine-app/consult/juri"

CLAUDE_MODEL = "claude-opus-5"
CATEGORIE = "Droit de l'urbanisme"

MOIS_FR = %w[janvier février mars avril mai juin juillet août septembre octobre novembre
             décembre].freeze

def env!(name)
  ENV.fetch(name) { abort "Variable d'environnement manquante : #{name}" }
end

def post_json(uri, body, headers = {})
  req = Net::HTTP::Post.new(uri)
  req["Content-Type"] = "application/json"
  req["Accept"] = "application/json"
  headers.each { |k, v| req[k] = v }
  req.body = JSON.generate(body)
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
  raise "Échec requête #{uri} (#{res.code}) : #{res.body}" unless res.is_a?(Net::HTTPSuccess)

  res
end

# --- 1. Authentification PISTE -------------------------------------------------

def piste_access_token
  res = Net::HTTP.post_form(
    URI(PISTE_TOKEN_URL),
    "grant_type" => "client_credentials",
    "client_id" => env!("PISTE_CLIENT_ID"),
    "client_secret" => env!("PISTE_CLIENT_SECRET"),
    "scope" => "openid"
  )
  raise "Échec authentification PISTE (#{res.code}) : #{res.body}" unless res.is_a?(Net::HTTPSuccess)

  JSON.parse(res.body).fetch("access_token")
end

# --- 2. Recherche des 5 dernières décisions "urbanisme" -------------------------

def search_last_decisions(access_token)
  body = {
    recherche: {
      filtres: [
        { facette: "PUBLICATION_RECUEIL", valeurs: ["PUBLIE"] }
      ],
      sort: "DATE_DESC",
      fromAdvancedRecherche: false,
      champs: [
        {
          criteres: [
            { proximite: 2, valeur: "urbanisme", operateur: "ET", typeRecherche: "UN_DES_MOTS" }
          ],
          operateur: "ET",
          typeChamp: "ALL"
        }
      ],
      pageSize: 5,
      operateur: "ET",
      typePagination: "DEFAUT",
      pageNumber: 1
    },
    fond: "CETAT"
  }
  res = post_json(URI(LEGIFRANCE_SEARCH_URL), body, "Authorization" => "Bearer #{access_token}")
  JSON.parse(res.body).fetch("results", [])
end

# --- 3. Texte intégral + métadonnées d'une décision -----------------------------

def fetch_decision(access_token, text_id)
  res = post_json(URI(LEGIFRANCE_CONSULT_URL), { textId: text_id },
                   "Authorization" => "Bearer #{access_token}")
  JSON.parse(res.body).fetch("text")
end

# --- 4. Dédoublonnage : décisions déjà commentées sur le blog -------------------
#
# Comparaison sur le numéro de décision (`ce_numero`, écrit dans le front matter de chaque
# article généré) plutôt que sur un identifiant technique Légifrance opaque (CETATEXT...) : un
# numéro de décision du Conseil d'État est déjà unique en lui-même, et rester lisible évite
# d'ajouter un registre séparé à maintenir — la source unique reste les articles publiés.

def already_published_numeros
  Dir.glob(File.join(POSTS_DIR, "*.md")).filter_map do |path|
    # encoding: forcé en UTF-8 — sans cela, File.read hérite de l'encoding externe par défaut
    # du process (US-ASCII sur certains runtimes/CI), qui fait échouer le split ci-dessous dès
    # qu'un article contient un caractère accentué (systématique en français).
    content = File.read(path, encoding: "UTF-8")
    next unless content.start_with?("---")

    _, front_matter, = content.split(/^---\s*$/, 3)
    next unless front_matter

    begin
      # permitted_classes: certains anciens articles ont un champ `date:` en front matter, que
      # YAML type implicitement en Date — refusé par safe_load par défaut (Psych::DisallowedClass).
      YAML.safe_load(front_matter, permitted_classes: [Date, Time])&.dig("ce_numero")&.to_s
    rescue Psych::SyntaxError, Psych::DisallowedClass
      nil # un front matter malformé/atypique sur un article existant ne doit pas bloquer la veille
    end
  end.to_set
end

# --- 5. Rédaction de l'article via Claude ----------------------------------------

def domaines_pour_maillage
  # Liste "slug (titre)" des pages de domaines, pour que l'article puisse lier naturellement
  # vers les pages du site pertinentes (permis de construire, environnement-icpe...) sans que
  # le modèle ait à en inventer les URLs.
  YAML.safe_load_file(DOMAINES_YML).fetch("domaines", []).map do |d|
    "- /domaines-intervention/#{d['slug']}/ (#{d['title']})"
  end.join("\n")
rescue Errno::ENOENT, Psych::SyntaxError
  ""
end

def date_en_lettres(date_iso)
  annee, mois, jour = date_iso.split("-").map(&:to_i)
  "#{jour} #{MOIS_FR.fetch(mois - 1)} #{annee}"
end

ARTICLE_TOOL = {
  name: "publier_article",
  description: "Soumet l'article de blog rédigé, prêt à être intégré au site.",
  input_schema: {
    type: "object",
    properties: {
      title: {
        type: "string",
        description: "Titre éditorial complet de l'article (affiché en h1 et dans les listes), " \
                      "descriptif de la question de droit tranchée — sur le modèle des articles " \
                      "existants du blog, sans préfixe \"Conseil d'État, [date]...\" (la référence " \
                      "de la décision figure dans le lien du corps de l'article, pas dans le titre)."
      },
      seo_title: {
        type: "string",
        description: "Titre court pour la balise <title>, 45 à 65 caractères, sans le suffixe de " \
                      "marque du site (ajouté automatiquement)."
      },
      description: {
        type: "string",
        description: "Méta description SEO : synthèse de 40 à 60 mots de la décision et de sa portée."
      },
      tags: {
        type: "array",
        items: { type: "string" },
        minItems: 2,
        maxItems: 3,
        description: "2 à 3 mots-clés courts désignant les notions juridiques/procédurales " \
                      "centrales de la décision, complémentaires du titre (pas une reformulation) " \
                      "— jamais un terme générique déjà couvert par la catégorie (ex. \"urbanisme\"). " \
                      "Casse naturelle : un sigle garde sa forme d'usage (\"PLUi\", \"ICPE\"), une " \
                      "expression courante s'écrit en minuscules (\"vice de procédure\")."
      },
      body: {
        type: "string",
        description: "Corps de l'article en Markdown (sans front matter, sans bloc de référence " \
                      "— ajouté séparément), 800 à 1200 mots : un paragraphe de synthèse (40-60 " \
                      "mots, proche de `description`, sans titre au-dessus), puis \"## Les faits\", " \
                      "puis \"## La portée de la décision\"."
      }
    },
    required: %w[title seo_title description tags body],
    additionalProperties: false
  }
}.freeze

def draft_article(client, decision)
  system_prompt = <<~SYS
    Tu es un juriste spécialisé en droit public français. Tu rédiges pour le blog du cabinet
    d'un avocat en droit de l'urbanisme (Barreau de Besançon) un commentaire d'une décision du
    Conseil d'État publiée au recueil Lebon ou mentionnée aux tables, destiné à des lecteurs
    avertis (collectivités, professionnels de l'urbanisme, confrères). Ce n'est pas un dossier
    suivi par le cabinet : n'emploie aucune formule laissant entendre que le cabinet ou l'un de
    ses clients serait partie à l'affaire ou l'aurait plaidée — commente la décision comme un
    tiers extérieur au litige.

    Structure imposée du corps (une fois le titre et la description déjà produits séparément) :
    1. Un paragraphe de synthèse (40-60 mots, proche du champ `description`), sans titre au-dessus
       — c'est la première chose lue, avant tout développement.
    2. `## Les faits` : contexte factuel et procédural utile à la compréhension (juridictions
       antérieures le cas échéant), en langage clair.
    3. `## La portée de la décision` : le raisonnement retenu par le Conseil d'État, une citation
       en bloc Markdown (`>`), en *italique*, encadrée de guillemets français « » et fidèle au
       texte fourni, puis la conclusion/le dispositif concret.

    Règles transversales :
    - Rédige entièrement en français, avec une terminologie juridique précise ; mets en gras ou
      en italique les termes juridiques clés à leur première occurrence.
    - `title` : énonce l'apport juridique le plus significatif (règle de droit dégagée, seuil
      chiffré, notion précisée) — jamais une reprise de l'issue procédurale
      ("Annulation de...", "Confirmation de..."), et sans préfixe "Conseil d'État, [date]..." (la
      référence complète de la décision est ajoutée séparément en tête d'article).
    - Ne cite AUCUNE autre décision, texte de loi ou source que ceux mentionnés dans le texte de
      la décision fourni ci-dessous — n'invente aucune référence, aucune date, aucun numéro.
      N'insère AUCUN lien hypertexte vers un article de code ou une autre décision citée dans le
      texte : mentionne-les en texte simple (référence complète, ex. "l'article L.111-3 du code
      rural et de la pêche maritime"), sans lien — tu n'as aucun moyen de vérifier ici l'URL
      Légifrance exacte, et un lien fabriqué serait pire qu'aucun lien.
    - Si le texte de la décision mentionne le nom d'une personne physique partie à l'instance,
      ne le répète pas inutilement dans l'article (désigne-la par sa qualité : "l'exploitant",
      "la requérante"...) même si le texte source ne l'anonymise pas lui-même.
    - Quand c'est pertinent et naturel dans le texte (jamais forcé), insère 1 à 2 liens internes
      en Markdown vers les pages de domaines d'intervention du cabinet listées ci-dessous (n'en
      invente pas d'autres) :
      #{domaines_pour_maillage}

    Réponds uniquement en appelant l'outil `publier_article`.
  SYS

  user_prompt = <<~USR
    Décision à commenter (métadonnées et texte intégral extraits de Légifrance/PISTE) :

    Juridiction : #{decision['juridiction']}
    Formation : #{decision['formation']}
    Date : #{decision['date_iso']}
    Numéro : #{decision['num']}
    Titre Légifrance : #{decision['titre']}
    Publication au recueil : #{decision['publicationRecueil']}
    Résumé principal (le cas échéant) : #{Array(decision['resumePrincipal']).join(' / ')}

    Texte intégral :
    #{decision['texte']}
  USR

  message = client.messages.create(
    model: CLAUDE_MODEL,
    max_tokens: 8000,
    system_: system_prompt,
    thinking: { type: "adaptive" },
    tools: [ARTICLE_TOOL],
    tool_choice: { type: "tool", name: "publier_article" },
    messages: [{ role: "user", content: user_prompt }]
  )

  tool_use = message.content.find { |block| block.type == :tool_use }
  raise "Réponse Claude sans appel d'outil (stop_reason=#{message.stop_reason})" unless tool_use

  tool_use.input
end

# --- 6. Fichier + branche + Pull Request ----------------------------------------

def slugify(str)
  str.unicode_normalize(:nfkd)
     .encode("ASCII", invalid: :replace, undef: :replace, replace: "")
     .downcase
     .gsub(/[^a-z0-9]+/, "-")
     .gsub(/\A-+|-+\z/, "")
end

def yaml_escape(str)
  # Bloc de remplacement (plutôt qu'une chaîne) : une chaîne de remplacement passée à gsub
  # interprète elle-même les antislashs (comme sed), ce qui avalerait silencieusement
  # l'antislash qu'on cherche justement à doubler ici. Un bloc renvoie sa valeur telle quelle.
  str.to_s.gsub(/[\\"]/) { |char| "\\#{char}" }
end

def reference_block(decision)
  # Bloc de référence construit ici, déterministe (pas par Claude) : c'est un format très normé
  # (gras/italique/liens exacts) où une erreur de mise en forme par le modèle serait plus
  # difficile à repérer qu'à éviter en amont.
  <<~REF
    **Conseil d'État, #{date_en_lettres(decision['date_iso'])}, n° #{decision['num']}**

    *Consulter [la décision sur Légifrance](#{decision['lien_legifrance']}) et [sur Ariane Web](#{decision['lien_arianeweb']}).*
  REF
end

def write_and_open_pr(article, decision)
  date = Time.now.strftime("%Y-%m-%d")
  slug = slugify(article["title"])[0, 80].gsub(/-+\z/, "")
  relative_path = File.join("blog", "_posts", "#{date}-#{slug}.md")

  tags_yaml = Array(article["tags"]).map { |t| "\"#{yaml_escape(t)}\"" }.join(", ")

  front_matter = <<~FM
    ---
    layout: post
    title: "#{yaml_escape(article['title'])}"
    seo_title: "#{yaml_escape(article['seo_title'])}"
    description: "#{yaml_escape(article['description'])}"
    categories: ["#{CATEGORIE}"]
    tags: [#{tags_yaml}]
    ce_numero: "#{decision['num']}"
    ---

  FM

  body = "#{reference_block(decision)}\n#{article['body'].strip}\n"
  File.write(File.join(REPO_ROOT, relative_path), front_matter + body)

  repo = env!("GITHUB_REPOSITORY")
  token = env!("GITHUB_TOKEN")
  base_branch = ENV.fetch("GITHUB_BASE_BRANCH", "master")
  branch = "veille-ce/#{decision['num']}"

  if open_pr_exists?(repo, token, branch)
    puts "Une PR ouverte existe déjà pour la branche #{branch}, rien à refaire."
    return
  end

  Dir.chdir(REPO_ROOT) do
    system("git", "fetch", "origin", base_branch, exception: true)
    system("git", "checkout", "-B", branch, "origin/#{base_branch}", exception: true)
    system("git", "add", relative_path, exception: true)
    system("git", "-c", "user.name=veille-conseil-etat[bot]",
           "-c", "user.email=veille-conseil-etat[bot]@users.noreply.github.com",
           "commit", "-m", "blog: article automatique CE n°#{decision['num']} (veille urbanisme)",
           exception: true)
    system("git", "push", "--force",
           "https://x-access-token:#{token}@github.com/#{repo}.git", "#{branch}:#{branch}",
           exception: true)
  end

  create_pull_request(repo, token, branch, base_branch, article, decision)
end

def open_pr_exists?(repo, token, branch)
  owner = repo.split("/", 2).first
  uri = URI("https://api.github.com/repos/#{repo}/pulls?state=open&head=#{owner}:#{branch}")
  req = Net::HTTP::Get.new(uri)
  req["Authorization"] = "Bearer #{token}"
  req["Accept"] = "application/vnd.github+json"
  req["User-Agent"] = "veille-conseil-etat-script"
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
  raise "Échec vérification PR existante (#{res.code}) : #{res.body}" unless res.is_a?(Net::HTTPSuccess)

  !JSON.parse(res.body).empty?
end

def create_pull_request(repo, token, head, base, article, decision)
  pr_body = <<~BODY
    Article généré automatiquement par la veille jurisprudentielle (Conseil d'État, droit de
    l'urbanisme) à partir de la décision suivante :

    - **Juridiction** : #{decision['juridiction']}
    - **Date** : #{decision['date_iso']}
    - **Numéro** : #{decision['num']}
    - **Classification** : #{decision['publicationRecueil']} (A = publié au recueil Lebon, B = mentionné aux tables)
    - **Tags proposés** : #{Array(article['tags']).join(', ')}

    ⚠️ **À relire avant fusion** : contenu rédigé par IA (Claude), non vérifié par un juriste —
    vérifier l'exactitude juridique, la fidélité des citations au texte de la décision, et
    l'absence de mention inutile d'une personne physique partie à l'instance, avant de fusionner
    cette PR (cf. point de vigilance déontologique, CLAUDE.md).
  BODY

  uri = URI("https://api.github.com/repos/#{repo}/pulls")
  req = Net::HTTP::Post.new(uri)
  req["Authorization"] = "Bearer #{token}"
  req["Accept"] = "application/vnd.github+json"
  req["User-Agent"] = "veille-conseil-etat-script"
  req.body = JSON.generate(
    title: "Blog : #{article['title']}", body: pr_body, head: head, base: base, draft: true
  )
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
  raise "Échec création PR (#{res.code}) : #{res.body}" unless res.is_a?(Net::HTTPSuccess)

  puts "PR ouverte : #{JSON.parse(res.body)['html_url']}"
end

# --- Point d'entrée ---------------------------------------------------------------

def main
  access_token = piste_access_token
  hits = search_last_decisions(access_token)
  deja_publiees = already_published_numeros
  claude = Anthropic::Client.new # lit ANTHROPIC_API_KEY dans l'environnement

  nouvelles = 0
  hits.each do |hit|
    text_id = hit.dig("titles", 0, "id")
    next unless text_id

    decision = fetch_decision(access_token, text_id)
    numero = decision["num"].to_s
    next if numero.empty? || deja_publiees.include?(numero)

    date_iso = Time.at(decision["dateTexte"].to_i / 1000).utc.strftime("%Y-%m-%d")
    decision = decision.merge(
      "date_iso" => date_iso,
      "resumePrincipal" => hit["resumePrincipal"],
      "autreResume" => hit["autreResume"],
      "lien_legifrance" => "https://www.legifrance.gouv.fr/ceta/id/#{text_id}",
      "lien_arianeweb" => "https://www.conseil-etat.fr/fr/arianeweb/CE/decision/#{date_iso}/#{numero}"
    )

    puts "Nouvelle décision détectée : #{decision['juridiction']} n°#{numero} du #{date_iso}"
    article = draft_article(claude, decision)
    write_and_open_pr(article, decision)
    nouvelles += 1
  end

  puts(nouvelles.zero? ? "Aucune nouvelle décision à commenter cette semaine." : "#{nouvelles} PR(s) traitée(s).")
end

main if $PROGRAM_NAME == __FILE__
