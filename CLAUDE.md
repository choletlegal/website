# CLAUDE.md — Site cabinet Me Antonin Cholet

Documentation de contexte pour les sessions Claude Code sur ce projet. À mettre à jour à chaque décision structurante prise en cours de développement.

## Contexte du projet

- Refonte complète du site vitrine d'un avocat en droit public / droit de l'urbanisme, Barreau de Besançon.
- Objectifs : crédibilité professionnelle, acquisition de clientèle, bon référencement moteurs de recherche **et** IA génératives (GEO).
- Le site actuel (cholet-avocat.fr) est conservé comme référence de structure, mais entièrement reconstruit.
- Publication : le porteur du projet gère lui-même le `git push` / déploiement final. Claude Code travaille sur le repo local.

## Stack technique

- **Générateur** : Jekyll (dernière version stable).
- **CSS** : CSS natif (variables CSS, Flexbox/Grid). **Pas de Bootstrap** — retiré intentionnellement pour la performance (Core Web Vitals). Pas de framework CSS lourd sauf décision contraire explicite. **Fait** : CDN Bootstrap (CSS+JS) et tout le CSS de compatibilité associé entièrement retirés (voir Journal).
- **JS** : vanilla JS minimal (menu burger mobile uniquement a priori). Pas de jQuery.
- **Hébergement cible** : à confirmer (GitHub Pages / Netlify pressenti).
- **Icônes** : SVG inline ou petit set auto-hébergé — pas de CDN Font Awesome (poids + requête externe superflue, contraire à l'objectif de performance). **Fait** : CDN Font Awesome retiré, plus aucune page ne l'utilise.

## Structure du repo

```
.
├── _config.yml
├── Gemfile
├── CLAUDE.md
├── robots.txt
│
├── _data/
│   ├── domaines.yml          # liste des domaines d'intervention (slug, titre, résumé) — source unique
│   ├── cabinet.yml           # infos du cabinet (nom, barreau, adresse, tél, réseaux)
│   └── nav.yml               # liens de navigation principale — source unique (desktop + mobile)
│
├── _includes/
│   ├── head-seo.html         # meta, Open Graph, Schema.org
│   ├── page-header.html      # en-tête de page (eyebrow + h1 + chapô) — réutilisé par 8 pages/layouts
│   ├── post-row.html         # ligne de liste d'article (date/titre/extrait/lien) — réutilisé par blog.html, blog-preview.html, post.html
│   ├── header/navbar.html
│   ├── header/hero.html      # bandeau inversé, page d'accueil uniquement
│   ├── sections/domaines.html, decisions-preview.html, process.html, blog-preview.html, cta.html
│   ├── domaines-list.html    # liste éditoriale des domaines — partagée accueil + page pivot
│   ├── icons/                # logo (currentColor) + icônes réseaux sociaux, SVG inline
│   └── footer/footer.html
│
├── _layouts/
│   ├── default.html          # header + footer
│   ├── domaine.html          # page d'un domaine d'intervention — fait
│   ├── post.html             # article de blog — fait (Piste B)
│   └── decision.html         # fiche décision — fait
│
├── assets/css/tokens.css     # couleurs, typographie, espacements — source unique des tokens (Piste B)
│
├── blog/_posts/               # articles de blog — 16 articles réels (2017-2019), site.posts (Jekyll lit aussi un _posts niché hors racine)
├── _decisions/                # fiches décisions obtenues — 2 fiches réelles (domaine plu-documents-urbanisme)
│
├── domaines-intervention/
│   ├── index.md               # page pivot
│   ├── permis-de-construire.md
│   ├── declaration-prealable.md
│   ├── contentieux-urbanisme.md
│   ├── plu-documents-urbanisme.md
│   └── fonction-publique.md
│
├── assets/
│   ├── css/main.css          # reset de base sur les tokens Piste B (body/headings/liens/code) + composants Piste B — Bootstrap entièrement retiré
│   ├── js/main.js             # menu burger + bascule couleur du header au scroll
│   └── images/
│
└── votre-avocat.md, contact.md, mentions-legales.md, politique-confidentialite.md, blog.html   # toutes migrées Piste B — honoraires/ reste à créer
```

Cette structure reflète l'arborescence en silo décrite plus bas — un dossier `domaines-intervention/` avec une page par domaine, pas de pages éparpillées à la racine.

## Méthodologie de travail — workflow obligatoire

1. **Planification avant implémentation** : pour toute tâche non triviale, produire d'abord un plan (fichiers touchés, approche, points d'attention) et le soumettre à validation avant d'écrire du code.
2. **Validation des PR avant merge** : aucune fusion sur la branche principale sans relecture explicite du porteur du projet. Une PR = une fonctionnalité ou correction cohérente, avec une description claire de ce qui a changé et pourquoi.
3. **Commits atomiques, petits diffs** : chaque commit correspond à un changement logique unique et reste le plus petit possible. Préférer plusieurs petits commits/PR faciles à relire à un gros commit qui mélange plusieurs sujets (ex. ne pas mélanger retrait de Bootstrap et ajout d'une nouvelle page dans le même commit). Format de message recommandé : `type(scope): description` (ex. `feat(domaines): add page contentieux-urbanisme`, `fix(seo): correct og:locale`, `docs: update CLAUDE.md`).
4. **Tests obligatoires avant de considérer une tâche terminée** : build Jekyll qui passe sans erreur/warning, vérification visuelle responsive (mobile/tablette/desktop), validation HTML de base. Une tâche n'est "faite" que si elle a été testée.

## Composants et réutilisation

- Toute structure visuelle qui se répète (carte de service, carte d'article/décision, bouton, bloc CTA, en-tête de section) doit être un **include Jekyll** paramétrable (`_includes/`), jamais dupliquée en HTML brut d'une page à l'autre.
- Chaque include a une seule responsabilité et reste court (repère : < 50 lignes) — au-delà, le découper en sous-includes plutôt que de le laisser grossir.
- Avant de créer un nouveau bloc, vérifier si un include existant peut être réutilisé ou légèrement généralisé (paramètres) plutôt que copié.
- Les variables de style (couleurs, espacements, typographie) centralisées dans un seul fichier de tokens CSS — jamais de valeur codée en dur dans un template si un token existe déjà pour ça.
- **Ne jamais combiner `.wrap` avec une classe qui pose son propre `max-width` sur le même élément** (`class="wrap xxx"`) : la classe la plus tardive dans `main.css` écrase le `max-width` de `.wrap`, et son `margin: 0 auto` centre alors ce bloc rétréci au lieu de le laisser aligné à gauche. Bug rencontré deux fois (`.page-domaine-content`, puis `.hero-content`) — toujours imbriquer sur deux `<div>` distincts : `<div class="wrap"><div class="xxx">…</div></div>`.
- **Un paramètre passé à `{% include fichier.html param=valeur %}` se lit à l'intérieur du fichier inclus via `include.param`, jamais en variable nue `{{ param }}`.** Jekyll partage le scope Liquid entre un layout et ses includes, ce qui peut faire fonctionner une variable nue par coïncidence (si une variable locale de même nom existe déjà chez l'appelant) — piège rencontré sur `schema-service.html`, qui a cassé silencieusement (champs à `null`, aucune erreur de build) une fois généralisé en `schema-article.html`. Toujours écrire `include.xxx`, comme le fait `page-header.html`.

## Responsive et accessibilité

- **Mobile-first obligatoire** : toute page conçue et testée d'abord pour un écran de téléphone, puis adaptée aux formats plus larges — cohérent avec le fait qu'une bonne part des prospects consulteront le site depuis leur mobile.
- Test de lecture optimale sur mobile requis avant validation d'une page (taille de police, longueur de ligne, zones cliquables suffisamment grandes).
- Accessibilité de base : contrastes suffisants (surtout avec la couleur d'accent chaleureuse sur fond clair — vérifier avec [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/), ratio ≥ 4.5:1), `alt` sur toutes les images, `aria-label` sur les icônes/liens sans texte visible, `lang="fr"` sur `<html>`, navigation au clavier fonctionnelle, structure de titres logique (pas de saut de niveau).
- **Outils de validation à utiliser avant de considérer une page terminée** : [Lighthouse](https://developer.chrome.com/docs/lighthouse/overview/) (SEO, accessibilité, performance), [W3C Validator](https://validator.w3.org/) (HTML), test visuel sur au moins un mobile, une tablette et un desktop.

## Arborescence des pages

```
/                                                  Accueil
/votre-avocat/                                     Présentation de Me Cholet
/domaines-intervention/                            Page pivot (silo SEO)
/domaines-intervention/permis-de-construire/
/domaines-intervention/declaration-prealable/
/domaines-intervention/contentieux-urbanisme/
/domaines-intervention/plu-documents-urbanisme/
/domaines-intervention/fonction-publique/
/honoraires/                                       Page à créer (absente du site actuel)
/blog/                                              Actualités juridiques générales
/decisions/                                         Archive de toutes les décisions obtenues (hors nav principale)
/contact/
/mentions-legales/
/politique-confidentialite/
```

**Granularité des domaines** : tranché — 5 domaines, pas d'éclatement du "Contentieux de l'Urbanisme". Un 5ᵉ domaine, "Droit de la Fonction Publique", a été ajouté (discipline, avancement, rémunération, accident de service) en plus des 4 domaines urbanisme existants. Chaque page a un contenu substantiel propre, pas de page vide.

## Collections Jekyll

### `_posts` — Blog actualités
Veille juridique générale, commentaires de jurisprudence non liés à un dossier personnel.

### `_decisions` — Décisions obtenues (collection personnalisée)
Objectif : preuve de compétence (E-E-A-T), injectée sur la page du domaine concerné (fait), sur l'accueil (3 plus récentes, fait) et en archive dédiée `/decisions/` (fait — liée depuis l'accueil et le domaine via un lien "Voir toutes les décisions", pas encore ajoutée à la nav principale).

```yaml
# _config.yml
collections:
  decisions:
    output: true
    permalink: /domaines-intervention/:path/
```

**Permalink dynamique via `:path`, pas de champ `permalink:` par fiche** : Jekyll ne sait pas résoudre un placeholder de permalink (`:domaine`) à partir d'un champ de front matter arbitraire — seul un jeu de clés fixe est supporté nativement (`:path`, `:title`, `:slug`, `:categories`, dates...), sans plugin custom (risqué si l'hébergement final est GitHub Pages). `:path` fait partie de ce jeu fixe et retient l'arborescence de dossiers relative à la racine de la collection : en rangeant chaque fiche dans `_decisions/<domaine>/<slug>.md` (nom de fichier **sans préfixe de date**), `:path` vaut `<domaine>/<slug>` et reproduit l'URL voulue automatiquement — le dossier + le nom de fichier suffisent, plus besoin d'écrire de `permalink:` fiche par fiche (à la différence des anciens articles de blog, qui gardent chacun le leur).

Front matter type d'une fiche décision (`_decisions/permis-de-construire/annulation-refus-permis.md`) :
```yaml
---
domaine: permis-de-construire     # doit correspondre au slug du dossier domaine concerné (= nom du sous-dossier _decisions)
juridiction: "TA Besançon"
date: 2026-05-12
title: "Annulation d'un refus de permis de construire"   # titre affiché (h1, listes) ET requis par jekyll-seo-tag (page.title) — un seul champ, pas de doublon
description: "..."                # meta description SEO, distincte du resume affiché sur la page
resume: "..."                     # réponse synthétique 40-60 mots (cf. checklist SEO/GEO)
lien_texte_integral: ""           # Légifrance / CE / CAA
tags: ["PLUi", "vice de procédure"]   # optionnel, libre — prépare un futur filtre par tag (pas encore d'UI dédiée)
---
```

**Filtre par domaine sur `/decisions/`** : une barre de boutons (`.filter-bar`, vanilla JS dans `main.js`) apparaît automatiquement dès que les fiches publiées couvrent plus d'un domaine (générée depuis `site.decisions | map: "domaine" | uniq`, titres résolus via `_data/domaines.yml`) — rien à maintenir manuellement à l'ajout d'une fiche. Dégradation sans JS : la barre reste masquée (`hidden`), toutes les décisions restent visibles.

**Point de vigilance déontologique — à valider avec l'Ordre avant publication** : anonymisation des parties, accord du client si nécessaire, respect du secret professionnel même sur des décisions publiques. Ne pas publier de fiche sans ce contrôle.

## Bonnes pratiques

### Convention de nommage
- Fichiers et dossiers : minuscules, mots séparés par des tirets (`permis-de-construire.md`, `contentieux-urbanisme/`), jamais d'espace ni d'accent dans un nom de fichier.
- Slugs d'URL identiques aux noms de fichiers/dossiers pour éviter toute divergence entre arborescence physique et URL publiée.
- Images : `nom-descriptif-sujet.webp` (voir ci-dessous), pas de noms génériques (`image1.jpg`, `IMG_2024.png`).

### Images
- Format **WebP** par défaut (déjà utilisé sur le site actuel) ; SVG pour les icônes/logos.
- Poids cible : viser < 150 Ko par image de contenu, < 30 Ko pour les icônes/logos.
- Toujours fournir une largeur adaptée à l'usage réel (pas de redimensionnement CSS d'une image surdimensionnée) ; prévoir `loading="lazy"` sur les images hors zone visible immédiate.
- `alt` descriptif obligatoire sur chaque image (accessibilité + SEO image).

### SEO / GEO — checklist à appliquer à chaque page
- [ ] Un seul H1, hiérarchie de titres logique
- [ ] Meta description unique et pertinente
- [ ] `og:locale` = `fr_FR` (corrigé par rapport au site actuel qui avait `en_US`)
- [ ] URL propre, cohérente avec l'arborescence en silo
- [ ] Réponse synthétique (40–60 mots) en haut de page/section, développement ensuite (sert featured snippets + citations IA)
- [x] Données structurées Schema.org pertinentes : `Attorney` sur les pages cabinet (tranché — plus précis que le `LegalService` générique, cf. Journal), `Article` (avec auteur) sur blog ; reste à faire : `FAQPage` si section FAQ (`honoraires/`), `Article` sur les futures fiches `_decisions`
- [ ] Contenu sourcé : textes de loi, jurisprudence citée précisément (CE, CAA, TA)
- [ ] Sitemap XML (`jekyll-sitemap`) et `robots.txt` à jour
- [ ] Google Search Console + Bing Webmaster Tools : balises de vérification à renseigner (vides sur le site actuel)

### Performance
- Aucune dépendance JS/CSS lourde ajoutée sans justification explicite (cohérent avec le retrait de Bootstrap et Font Awesome).
- Budget de poids par page : viser < 500 Ko transférés au total (HTML+CSS+JS+images), en plus du budget par image déjà fixé ci-dessus.
- CSS et JS minifiés en production ; un seul fichier CSS global plutôt qu'un empilement de petits fichiers non concaténés.
- Vérifier Lighthouse/Core Web Vitals avant de considérer une page terminée, en particulier après ajout d'images ou de police web.
- Polices web chargées avec `font-display: swap` et sous-ensemble limité aux caractères nécessaires si possible.

## Workflows

### Créer une nouvelle page statique (ex. Honoraires)
1. Créer le fichier `.md` dans le bon dossier de l'arborescence (jamais à la racine si elle appartient à un silo).
2. Front matter avec `layout`, `title`, `description` (SEO).
3. Utiliser un layout existant (`page`, `domaine`, `post`, `decision`) — n'en créer un nouveau que si aucun n'est adaptable.
4. Tester en local (`bundle exec jekyll serve`), valider avec Lighthouse.
5. Commit atomique, PR, validation avant merge.

### Ajouter un article de blog
1. Créer `_posts/AAAA-MM-JJ-titre-slug.md`.
2. Front matter obligatoire : `layout: post`, `title`, `description`, `categories`, `image` (1200×630px pour l'`og:image`).
3. Rédiger en Markdown, une réponse synthétique en ouverture (voir checklist SEO/GEO).
4. Vérifier les liens vers les pages domaine concernées (maillage interne).

### Ajouter une fiche décision obtenue
1. Créer `_decisions/<domaine>/<slug>.md` (sous-dossier = slug du domaine, nom de fichier = slug de la fiche, **sans préfixe de date**) avec le front matter décrit plus haut (`domaine`, `juridiction`, `date`, `title`, `resume`, `lien_texte_integral`, `tags` optionnel) — pas de champ `permalink:` à ajouter, il est généré automatiquement par la collection.
2. **Vérifier l'anonymisation / absence de risque déontologique avant tout commit** (voir point de vigilance plus haut).
3. Vérifier que la page du domaine concerné affiche bien la nouvelle fiche (filtre par `domaine`), et que la barre de filtre apparaît sur `/decisions/` si la fiche introduit un nouveau domaine.

### Mettre à jour les données du cabinet ou la liste des domaines
- Modifier `_data/cabinet.yml` (coordonnées, réseaux) ou `_data/domaines.yml` (ajout/retrait d'un domaine) plutôt que de toucher les templates un par un.

## Commandes utiles

| Commande | Description |
|----------|-------------|
| `bundle install` | Installe les dépendances Ruby |
| `bundle exec jekyll serve` | Lance le serveur local (http://localhost:4000) |
| `bundle exec jekyll serve --livereload` | Serveur avec rechargement automatique |
| `bundle exec jekyll build` | Génère le site statique dans `_site/` |
| `bundle update` | Met à jour les dépendances |

## Périmètre du premier passage de développement

**Fait** : migration Piste B de tout le site — page d'accueil (layout `default.html`, tokens CSS, hero, domaines, décisions, processus, CTA, footer), silo complet `/domaines-intervention/` (page pivot + 5 pages domaines, layout `domaine.html`), puis `votre-avocat/`, `contact/`, `mentions-legales/`, `politique-confidentialite/`, `blog/` (liste + `_layouts/post.html`, 16 articles réels existants dans `blog/_posts/`). Bootstrap et Font Awesome entièrement retirés (CDN + CSS de compatibilité + layout `page.html` + page orpheline `services.md`, cf. Journal) : plus aucune trace dans le site généré.

**Reste à faire** : `honoraires/` (page absente du site actuel, à créer).

## Direction visuelle (finalisée — « Piste B »)

Palette et polices tranchées après plusieurs itérations sur une maquette visuelle (Artifact Claude, cf. note en fin de section) — la piste serif/marine/terracotta initialement envisagée a été abandonnée en cours de prototype au profit de la direction suivante :

- **Sobre, clair, typographie 100 % sans-serif** : **Inter** pour les titres et le corps de texte (plus de police serif). Titres en graisse forte (700–800), corps en 400–500, `letter-spacing` légèrement resserré sur les titres. Interlignage généreux (1.65–1.75) ; les paragraphes longs (chapô, intros de section) sont **justifiés avec césure automatique** (`text-align: justify; hyphens: auto`) pour un rendu proche du texte imprimé — l'écrit comme signal de qualité, sans artifice visuel.
- **Palette** : fond dominant blanc / gris très clair (`#FFFFFF` / `#F4F5F3`, pas de crème), texte en gris quasi-noir (`#202327` titres, `#4A4E54` corps), un **unique accent bordeaux** (`#8C2F39` sur fond clair, `#D97D85`/`#A94550` en variante sombre) réservé aux CTA, liens et petits accents — jamais en fond de bloc étendu. Contraste vérifié ≥ 4.5:1 partout où l'accent sert de texte (~8:1 en usage courant).
- **Minimalisme éditorial, pas de Material** : abandon des cartes à ombre et de l'élévation — séparation par **filets fins (1px)** plutôt que par ombre portée, sections alternant fond blanc / gris très clair, accent de couleur réduit au strict minimum, typographie mise au premier plan. Petites capitales (`font-variant-caps: small-caps`) sur les liens de navigation.
- **Exception assumée — le hero** : seul bloc en couleurs inversées du site (fond quasi-noir `#1C1E22`, texte clair `#DFDCD4`), esprit affiche suisse — pas un thème sombre généralisé, un geste ponctuel et délibéré. Contient une trame de pierre en fond (appareil de taille, deux `repeating-linear-gradient`) et un liseré en angle bas-gauche (bordure gauche + basse uniquement), repris de la maquette Claude Design *« Frise Citadelle Besançon »* (artboard 1A). Pas de dégradé de couleur (conforme à la règle « pas de dégradés »), pas d'image (photo de la citadelle retirée), typographie pure : tokens de matières (« Droit de l'urbanisme », « Droit public », « Droit de la fonction publique »), accroche en Inter 800, légende courte.
- **Menu adaptatif au scroll** : le header adopte les couleurs du hero au chargement (fondu avec lui, aucune bordure visible entre les deux), puis bascule en douceur (transition CSS ~0.2s) vers son apparence claire habituelle une fois la page scrollée (~40px), via une classe `.is-scrolled` posée par un petit script au scroll. Implémentation par tokens CSS scopés (`--nav-bg`, `--nav-fg`, `--nav-muted`, `--nav-line`, `--nav-divider`) redéfinis par cette classe, pas de duplication de règles.
- **Logo** : `assets/images/logo-feuille-chene.svg` (médaillon feuille de chêne), dessiné en un seul path `fill-rule="evenodd"` où la feuille est *creusée* dans le disque plutôt que peinte dessus. Piloté par `currentColor` → hérite directement du token de couleur du header, ce qui donne l'inversion de couleur au scroll **sans JS dédié**. Toujours utiliser ce SVG inline (jamais en `<img>` bitmap) partout où le logo doit suivre une couleur de fond variable.
- **Icônes réseaux sociaux** (footer) : SVG inline, monochromes (`currentColor`), sauf logo de marque tierce fourni tel quel par le porteur du projet (ex. `logo-W-social.svg`) qui peut être passé en monochrome sur demande explicite plutôt que gardé dans ses couleurs propres.
- **JavaScript minimal, inchangé dans son esprit** : menu burger mobile + le petit écouteur de scroll pour la bascule de couleur du header. Toujours vanilla JS, pas de dépendance ajoutée.

**✅ Point de vigilance CSS résolu** : `main.css` contenait une règle héritée du site Bootstrap qui forçait en `!important` la couleur de tout `p, span, li, td, th, blockquote, address, cite, code, pre, small, strong, em, b, i, u` (bug déjà rencontré : logo, nom/titre du menu, mot accentué du hero tous rendus gris illisibles avant correction ponctuelle). Cette règle — et tout le CSS de compatibilité Bootstrap — a été supprimée avec le retrait complet de Bootstrap (cf. Journal). Passage de nettoyage complémentaire effectué : tous les `!important` devenus inutiles ont été retirés des composants Piste B (`main.css` n'en contient plus qu'un seul, volontaire, sur l'override `prefers-reduced-motion`) ; **aucune raison d'en ajouter sur un nouveau composant**.

**Maquette de référence (à garder à jour tant que l'implémentation Jekyll n'a pas rattrapé la maquette)** : Artifact Claude publié par le porteur du projet — page d'accueil complète (nav, hero, domaines d'intervention, décisions obtenues, déroulé d'une intervention en 3 étapes, bandeau CTA, footer). Lien géré côté porteur du projet (`/artifacts` dans le CLI, ou historique de conversation Claude Code) — non dupliqué ici pour éviter un lien qui devienne obsolète si l'artifact est republié sous une autre URL.

## Décisions en attente (à trancher avant/pendant le développement)

- [x] ~~Granularité finale des pages domaines~~ → tranché : 5 domaines (4 urbanisme + Droit de la Fonction Publique), pas d'éclatement du contentieux
- [x] ~~Choix définitif des polices et des couleurs exactes~~ → tranché : Inter (titres + corps), fond clair + accent bordeaux unique, hero inversé en exception assumée (voir Direction visuelle ci-dessus)
- [x] ~~Migration Piste B de `votre-avocat/`, `contact/`, `mentions-legales/`, `politique-confidentialite/`, `blog/`~~ → fait (voir Journal ci-dessous)
- [x] ~~URL des articles de blog (date/catégorie dans l'URL ?)~~ → tranché : `permalink: /blog/:title/` pour les nouveaux articles (pas de date ni catégorie — plus propre, meilleur pour le CTR sur du contenu evergreen ; la date reste affichée sur la page et dans les données structurées, ce qui est ce qui compte pour le SEO). Les 16 articles existants gardent leur URL d'origine (permalink explicite figé par article).
- [ ] Hébergement final
- [x] ~~Fiches `_decisions` réelles~~ → fait (voir Journal) : collection configurée, 2 premières fiches réelles publiées, archive dédiée `/decisions/` créée
- [x] ~~`_layouts/decision.html` à créer~~ → fait (voir Journal)
- [x] ~~Données structurées Schema.org par page domaine (`Service`/`Attorney`)~~ → fait (voir Journal), ainsi qu'`Article` sur le blog
- [x] ~~Page orpheline `services.md`~~ → supprimée, ainsi que le layout `page.html` (plus aucun usage)
- [x] ~~Nettoyer le CSS Bootstrap mort dans `assets/css/main.css`~~ → fait, Bootstrap et Font Awesome entièrement retirés (CDN inclus)

## Journal des décisions prises

- Structure globale du site conservée par rapport à l'existant, contenu et technique entièrement repris.
- Architecture en silo retenue pour les domaines d'intervention (page pivot + sous-pages dédiées).
- Décisions obtenues traitées en collection Jekyll dédiée (`_decisions`), distincte du blog, avec permalien imbriqué sous le domaine concerné.
- Bootstrap retiré, migration vers CSS natif prévue composant par composant (grille, navbar, cards, boutons, espacements).
- Premier passage de développement limité au domaine "Permis de Construire" en prototype, avant duplication.
- Direction visuelle : sobre/moderne inspiration Material, emphase typographique (serif titres + sans-serif corps), une couleur froide dominante + un seul accent chaleureux, JS minimal.
- Méthodologie de travail actée : planification puis validation avant implémentation, PR relues avant merge, commits atomiques/petits diffs, composants réutilisables sans duplication, mobile-first avec tests obligatoires, bonnes pratiques de nommage/images/accessibilité/performance documentées.
- Fusion avec un ancien brouillon `AGENTS.md` : repris la structure de repo détaillée, les fichiers `_data` (domaines/cabinet), le format de commit, la limite de taille des includes, les outils de validation nommés, le budget de poids total par page et les workflows détaillés. Écarté du brouillon : Bootstrap, Font Awesome CDN, breakpoints Bootstrap, arborescence de pages à plat, déploiement GitHub Pages automatique (hébergement non confirmé). Icônes : SVG inline plutôt que CDN Font Awesome.
- Périmètre du premier passage recentré sur la page d'accueil (layout, tokens visuels, composants de base) plutôt que sur le domaine "Permis de Construire" — objectif : valider et affiner le rendu visuel avant duplication.
- Direction visuelle initiale (serif + marine/terracotta, inspiration Material) abandonnée en cours de prototype visuel, au profit de la Piste B : Inter intégral, fond clair + accent bordeaux unique, minimalisme éditorial à filets fins (plus de cartes à ombre), un seul bloc en couleurs inversées assumé sur le hero (esprit affiche suisse, trame de pierre + liseré en angle, repris d'une maquette Claude Design dédiée). Détail complet dans la section Direction visuelle ci-dessus.
- Menu adaptatif au scroll (couleurs du hero au chargement → couleurs claires habituelles au scroll) et logo en SVG piloté par `currentColor` pour suivre cette bascule sans JS dédié à la couleur.
- Pré-version de la page d'accueil validée visuellement sur maquette (nav, hero, domaines d'intervention, décisions obtenues, déroulé d'une intervention en 3 étapes, bandeau CTA, footer avec réseaux sociaux). Prochaine étape : implémentation Jekyll réelle (tokens CSS, includes, layout) reprenant cette maquette, en PR atomiques conformément à la méthodologie de travail.
- Page d'accueil implémentée en Jekyll réel (`assets/css/tokens.css`, `_data/domaines.yml` renommé depuis `services.yml`, `_data/author.yml` complété avec `wsocial`, `_includes/header/navbar.html`, `header/hero.html`, `sections/*`, `footer/footer.html`, `assets/js/main.js`) — nouvelles classes volontairement distinctes des classes Bootstrap (`.wrap` et non `.container`, `.action-btn` et non `.btn`) pour ne rien casser sur les pages pas encore migrées. Build Jekyll vérifié propre sur toutes les pages du site.
- Corrigé au passage : permalink de `votre-avocat.md` (`/equipe/antonin-cholet/` → `/votre-avocat/`, pour matcher l'arborescence cible et le nouveau menu) ; ligne corrompue et plateforme manquante (`x86_64-linux-gnu`) dans `Gemfile.lock`, qui bloquaient tout build local.
- Granularité des domaines tranchée : 5 domaines (ajout "Droit de la Fonction Publique"). Silo `/domaines-intervention/` construit en réel : `_layouts/domaine.html`, `_includes/domaines-list.html` (partagé accueil + page pivot), page pivot + 5 pages domaines avec contenu substantiel propre à chacune.
- **Bug transversal découvert et corrigé** : `_layouts/domaine.html` combinait `class="wrap page-domaine-content"` sur un même élément — le `max-width: 65ch` de `.page-domaine-content` écrasait celui de `.wrap` (1680px), et le `margin: 0 auto` de `.wrap` centrait alors ce bloc rétréci au lieu de le laisser aligné à gauche. Affectait les 5 pages domaines déjà "faites" (invisible sur mobile, flagrant en desktop). Corrigé en imbriquant les deux classes sur deux `<div>` distincts plutôt que de les combiner — à respecter pour tout nouveau composant qui réutilise `.page-domaine-content`.
- `votre-avocat/` migrée en Piste B : bio en deux colonnes (texte + carte portrait `.info-card`/`.avocat-card`, filet fin, pas d'ombre), réseaux sociaux (`.footer-socials` réutilisé) et spécialisations (`.feature-list` réutilisé). Portrait : `object-fit`/`aspect-ratio` retirés (l'image source est déjà quasi carrée, un recadrage forcé grignotait les côtés inutilement) ; colonne portrait doublée (`22rem` → `44rem`) sur retour utilisateur, seuil de passage en deux colonnes repoussé à `1320px` en conséquence pour ne pas écraser la colonne de texte.
- `contact/` migrée en Piste B : widget de RDV Avocat.fr conservé tel quel, carte **Informations** (adresse/téléphone/horaires en `<dl>` sémantique) et carte **Nous trouver** réutilisant `.info-card` (généralisé depuis `votre-avocat/`, plutôt que dupliqué). Carte Google Maps remplacée par un embed **OpenStreetMap** (pas de clé API, pas de dépendance Google) sur demande — coordonnées corrigées par géocodage Nominatim après un premier décalage de ~400 m repris à tort de l'ancien embed Google. Colonne infos/carte doublée comme pour `votre-avocat/` (mêmes `44rem`/`1320px`). *(Note : la mise en page à deux colonnes de ces deux pages a depuis été fusionnée dans un composant partagé `.split-layout`, cf. entrée de nettoyage CSS ci-dessous.)*
- `mentions-legales/` et `politique-confidentialite/` migrées en Piste B : texte juridique inchangé sur le fond, sections séparées par filet (remplace les `<hr>` Bootstrap) via une classe `.legal-content` posée en plus de `.page-domaine-content`.
- `blog/` migré en Piste B (`blog.html` liste + `_layouts/post.html` fiche article), réutilisant `.posts-list`/`.post-row` déjà posés pour l'aperçu sur l'accueil. Découverte en cours de route : `blog/_posts/` contient déjà **16 articles réels** (2017-2019, jurisprudence), pas vide comme supposé au départ — Jekyll les collecte bien malgré leur emplacement hors racine. Bug corrigé au passage : la date de publication s'affichait en anglais (`07 June 2019`, dépendant de la locale du serveur) → basculée en `%d/%m/%Y` comme partout ailleurs sur le site ; `{{ post.url }}` n'était pas échappé dans les liens d'articles (espace non encodé si la catégorie en contient un) → filtre `| uri_escape` ajouté (bug préexistant dans le Bootstrap d'origine).
- Décision SEO : permalien des articles de blog simplifié en `/blog/:title/` (sans date ni catégorie) pour les nouveaux articles — voir Décisions en attente pour le détail et le raisonnement.
- Page orpheline découverte : `services.md` (`/services/`, layout Bootstrap `page.html`) ne correspond à aucune page du plan et n'est liée depuis aucun menu — reliquat du site pré-refonte, superseded par `/domaines-intervention/`. Signalé en Décisions en attente, pas supprimé sans validation.
- **Bootstrap et Font Awesome entièrement retirés**, validé par le porteur du projet (`services.md` était la seule page à encore les utiliser) : suppression de `services.md` et du layout `page.html` (devenu sans usage) ; CDN Bootstrap CSS+JS et CDN Font Awesome retirés de `_includes/head-css.html`/`head-js.html` ; Google Fonts réduit à Inter seul (Rufina/Montserrat n'étaient plus utilisées) ; tout le CSS de compatibilité Bootstrap dans `main.css` (variables `--bs-*`, `.navbar`, `.card`, `.btn`, `.badge`, `.form-control`, `.text-muted`, `.bg-primary`, `.ratio`, `.timeline`, `.list-group-item`, override `.bg-dark`/footer, etc., ainsi que la règle globale forçant `#2e2e2e !important` sur le texte) remplacé par un reset minimal basé sur les tokens Piste B (`body`, `h1-h6`, `a`, `code`/`pre`). Vérifié : build propre, `/services/` renvoie 404, zéro référence Bootstrap/Font Awesome dans `_site`, rendu identique sur toutes les pages testées (accueil, votre-avocat, domaine, mentions-légales) desktop + mobile — bonus, les liens dans le texte courant (ex. mentions légales) héritent maintenant de l'accent bordeaux au lieu du gris terne d'origine.
- **Passage de simplification/dé-duplication du CSS** (demande explicite : « CSS au plus simple, état de l'art, maximiser la réutilisation des classes ») :
  - Tous les `!important` devenus inutiles après le retrait de Bootstrap ont été supprimés (41 → 1 dans `main.css` ; le seul restant, sur l'override `prefers-reduced-motion`, est volontaire).
  - Bug trouvé et corrigé : `.hero` redéfinissait localement `--hero-muted` avec une valeur RGB différente (`247,246,243`) de celle de `tokens.css` (`223,220,212`, cohérente avec `--hero-fg`) — redéclaration locale redondante supprimée, `tokens.css` redevient la seule source pour ces variables.
  - Token `--ink-strong` supprimé (valeur strictement identique à `--ink-heading`, un seul usage) — un token de moins à maintenir pour zéro perte d'expressivité.
  - `.avocat-layout` et `.contact-layout` (grille deux colonnes 1fr/44rem à 1320px, strictement identique sur les deux pages) fusionnées en un seul composant partagé **`.split-layout`**, réutilisé par `votre-avocat.md` et `contact.md` ; les particularités de chaque page (carte sticky pour l'avocat, empilement flex des deux cartes pour le contact) restent des modificateurs scoped (`.avocat-card`, `.contact-split`).
  - Petites redondances mortes supprimées : `box-sizing` en double sur `.wrap`, règles de marge à zéro qui n'avaient plus d'effet réel, exclusion `:not(.text-muted)` sur les liens du footer (classe Bootstrap disparue).
  - Regroupement du motif de paragraphe justifié (`text-align: justify; text-justify: inter-word; hyphens: auto;`) répété 4 fois en un seul bloc de sélecteurs groupés.
  - Vérifié : build propre, rendu strictement identique sur accueil/votre-avocat/contact/mentions-légales en desktop et mobile.
- **`/simplify` — revue à 4 agents parallèles (Reuse, Simplification, Efficiency, Altitude) sur tout le diff, correctifs appliqués :**
  - Bug réel trouvé par l'agent Altitude : `.wrap.hero-content` combinés sur le hero — exactement le même anti-pattern que `.page-domaine-content` (cf. règle ajoutée dans « Composants et réutilisation »). Décalait le texte du hero de ~300px par rapport au logo du header. Corrigé.
  - Duplication `post-row` (identique dans `blog.html`, `blog-preview.html`, et les « Articles similaires » de `post.html`) → extraite dans `_includes/post-row.html`.
  - Duplication `page-header` (identique dans 8 pages/layouts : `votre-avocat.md`, `contact.md`, `mentions-legales.md`, `politique-confidentialite.md`, `blog.html`, `domaine.html`, `domaines-intervention/index.md`, `post.html`) → extraite dans `_includes/page-header.html` (params `eyebrow_text`/`eyebrow_href`/`title`/`lede`/`after`).
  - Tokens hero codés en dur dans l'override `.is-scrolled` (au lieu de `var(--hero-*)`) → corrigé pour référencer `tokens.css`.
  - ~14 `font-family: var(--font-display)` redondants (déjà hérité de `body`) supprimés.
  - Token mort `--focus-ring` (jamais référencé) supprimé.
  - Bug auto-introduit en cours de correctif : un commentaire dans `page-header.html` contenait littéralement `{% capture %}`, interprété par erreur comme une vraie balise Liquid et cassant le build — reformulé en prose.
  - Skippé sciemment (signalé, non appliqué à ce stade) : liens de nav dupliqués desktop/mobile, `--accent`/`--accent-ink`/`--accent-fill` à la même valeur (séparation sémantique volontaire), requête Google Fonts trop large (pré-existante, hors scope du diff), timeline JS morte dans `main.js` (hors scope du diff) — **les 3 premiers ont depuis été traités, voir entrées suivantes ; le point `--accent-*` reste un choix assumé.**
  - Vérifié : build propre, un seul H1 par page, balises équilibrées, rendu strictement identique sur toutes les pages testées.
- **Nettoyage complémentaire demandé explicitement après le `/simplify`** (liens de nav dupliqués + JS mort) :
  - Liens de navigation extraits dans `_data/nav.yml`, bouclés une seule fois pour `.nav-links` (desktop) et `.mobile-panel` (mobile) au lieu d'être tapés en dur deux fois dans `navbar.html`. Bonus découvert : la règle CSS `.mobile-panel a[aria-current="page"]` existait déjà mais n'avait jamais d'effet faute de `aria-current` posé côté mobile — la déduplication l'active gratuitement (page courante surlignée en mobile aussi désormais).
  - `assets/js/main.js` : en creusant au-delà de la seule timeline signalée, tout le haut du fichier s'est avéré être du JS Bootstrap mort (init tooltips/popovers via l'objet `bootstrap` qui n'existe plus depuis le retrait du CDN, validation `.needs-validation`, smooth-scroll pour ancres `href="#"`, animation `.fade-in`) — vérifié qu'aucune page n'utilise `data-bs-toggle`, `.needs-validation`, `.fade-in` ou de lien `href="#"` avant suppression. Fichier réduit de 137 à 46 lignes, ne garde que le burger menu, la bascule de couleur du header au scroll, et le placeholder Google Analytics commenté (intentionnel).
  - Requête Google Fonts resserrée : `Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900` (romain+italique, graisses 100-900, tailles optiques 14-32 — tout l'espace de variation) → `Inter:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400` (les 5 graisses réellement utilisées en romain, italique en 400 uniquement, seul poids où il sert). Gain mesuré en interrogeant directement l'API Google Fonts (pas une estimation) : ~422 Ko → ~191 Ko pour les sous-ensembles `latin`+`latin-ext` qu'un visiteur francophone télécharge réellement (romain + italique) — environ **55 % de poids de police en moins**, rendu vérifié identique (graisses et italique du `.brand-title` intacts).
- **Schema.org complété** (point explicitement listé en attente) :
  - `_includes/head-seo.html` corrigé : `knowsAbout` (Person) généré depuis `_data/domaines.yml` au lieu d'une liste en dur oubliant 2 des 5 domaines ; `sameAs` reconstruit en tableau Liquid filtré (plus de lien cassé si un réseau est vide, `wsocial`/`avocat.fr` désormais inclus) ; `hasMap` (bloc cabinet) basculé de Google Maps vers OpenStreetMap (cohérent avec `contact/`) ; `xml_escape` remplacé par `jsonify` sur tous les champs texte des blocs JSON-LD — `xml_escape` produisait des entités XML (`l&apos;urbanisme`) illisibles telles quelles dans du JSON.
  - Nouveau `_includes/schema-service.html` (Service), inclus par `_layouts/domaine.html` → un bloc JSON-LD par page de `domaines-intervention/*`.
  - Nouveau `_includes/schema-article.html` (générique, réutilisable par les futures fiches `_decisions`), inclus par `_layouts/post.html` → un bloc JSON-LD par article de blog, avec repli sur l'excerpt Jekyll quand `page.description` est vide (cas des 16 anciens articles).
  - **Point d'attention Liquid découvert en cours de route** : un paramètre passé à un `{% include %}` Jekyll se lit à l'intérieur du fichier inclus via `include.nom_du_parametre`, jamais en variable nue — `schema-service.html` fonctionnait par accident sur `{{ domaine.title }}` (Jekyll partage le scope Liquid entre un layout et ses includes, et `domaine` existait déjà comme variable locale du layout appelant) ; ça a cassé silencieusement (tous les champs à `null`) sur `schema-article.html` où les noms de paramètres ne correspondaient à aucune variable locale de même nom. Les deux includes utilisent maintenant `include.xxx`, comme le fait déjà `page-header.html`. À respecter pour tout nouvel include paramétré : ne jamais compter sur le partage de scope, toujours lire via `include.*`.
  - Vérifié : build propre, 133 blocs JSON-LD sur tout le site validés (`json.loads`), 0 invalide, 0 champ vide inattendu.
- **`areaServed` corrigé** (validé par le porteur du projet) : `Besançon` (`City`) unique remplacé par `Grand Est` + `Bourgogne-Franche-Comté` (deux `State`), sur le bloc cabinet et sur `Service` par domaine — reflète le ressort réel de la Cour administrative d'appel de Nancy, avec la Bourgogne ajoutée sur demande explicite (proximité de Dijon) plutôt que la France entière (trop large pour un signal SEO/GEO local) ou Besançon seule (trop restreint). Source unique : `author.area_served` dans `_data/author.yml`, consommée par un nouveau fragment `_includes/schema-area-served.html` injecté comme valeur (pas un bloc `<script>` autonome) dans les deux schémas. Bug trouvé au passage : le commentaire d'en-tête du fragment (en HTML `<!--- -->`) se retrouvait injecté tel quel dans le JSON puisqu'un fragment inliné en valeur ne doit contenir que le littéral JSON — corrigé en commentaire Liquid `{% comment %}`, supprimé au rendu.
- **`@type` resserré de `LegalService` à `Attorney`** sur le bloc cabinet (`head-seo.html`) et partout où il est référencé (`provider` dans `schema-service.html`, `publisher` dans `schema-article.html`), sur demande explicite (« SEO précis ») : `Attorney` est un sous-type de `LegalService` spécifiquement prévu pour l'activité d'un avocat, donc plus précis pour les moteurs/IA. Règle rappelée au passage : les noms de `@type` du vocabulaire Schema.org restent toujours en anglais (identifiants du standard, jamais traduits), à la différence des valeurs de champs (`name`, `description`…) qui restent en français.
- **Besançon réintroduite dans `areaServed`** en tête de liste (`City`), devant les deux régions (`State`) : `address.addressLocality` dit où est le cabinet, `areaServed` dit où il exerce — deux signaux distincts, et une ville précise en tête reste nécessaire pour ne pas diluer le signal local fort ("avocat urbanisme Besançon") derrière les deux régions plus larges. `author.area_served` dans `_data/author.yml` restructuré en liste d'objets `{type, name}` (au lieu de simples chaînes toutes typées `State`) pour permettre ce mélange City/State ; `schema-area-served.html` mis à jour en conséquence. Complété ensuite avec les sièges de tribunaux administratifs du ressort (Dijon, Nancy, Strasbourg), sur demande explicite : ordre final `[Besançon, Dijon, Nancy, Strasbourg, Bourgogne-Franche-Comté, Grand Est]`.
- **Collection `_decisions` mise en place, avec 2 premières fiches réelles** (TA Besançon 2021 + CAA Nancy 2025, rattachées au domaine `plu-documents-urbanisme`) :
  - Bug trouvé en testant avec du contenu réel : le `permalink` de collection documenté (`/domaines-intervention/:domaine/:slug/`) casse le build — Jekyll ne résout un placeholder de permalink qu'à partir d'un jeu de clés fixe (`path`, `title`, `slug`, `categories`, dates...), jamais d'un champ de front matter arbitraire comme `domaine`, sans plugin custom (risqué si l'hébergement final est GitHub Pages). Retiré du `_config.yml` ; chaque fiche fixe désormais son propre `permalink:` explicite, comme le font déjà les anciens articles de blog. Doc de la collection mise à jour en conséquence.
  - Nouveau `_layouts/decision.html` (page-header avec titre/résumé en lede, méta juridiction+date, contenu, lien vers le texte intégral, retour au domaine, schema.org `Article` via `schema-article.html`) et `_includes/decision-row.html` (juridiction/titre/résumé), réutilisé par l'aperçu accueil et par la page domaine plutôt que dupliqué.
  - `sections/decisions-preview.html` bascule du contenu d'exemple vers une vraie boucle sur `site.decisions` ; `_layouts/domaine.html` affiche désormais les décisions du domaine courant (filtre `where: "domaine", page.domaine`).
  - Point de vigilance déontologique traité (validation explicite du porteur du projet) : la citation de l'arrêt CAA Nancy nommait la mandante — remplacée par "la requérante" dans le passage cité.
  - Vérifié : build propre, JSON-LD `Article` valide sur les deux fiches, décisions affichées et triées par date décroissante sur l'accueil et sur `plu-documents-urbanisme/`, aucune occurrence du nom résiduelle dans le site généré.
- **Archive dédiée `/decisions/` créée** (sur demande explicite) : nouvelle page `decisions.html` listant `site.decisions` (triées par date décroissante), réutilisant `page-header.html` et `decision-row.html` plutôt que dupliqué. Liée depuis l'aperçu de l'accueil et — pour rester cohérent — un lien "Voir toutes les décisions" (`.section-foot`/`.link-arrow`, motif déjà utilisé par `blog-preview.html`) ajouté sous l'aperçu accueil ; aperçu accueil désormais masqué si `site.decisions` est vide (même garde que `blog-preview.html`). Pas encore ajoutée à `_data/nav.yml` (nav principale à 4 liens, décision volontairement pas prise ici) — à trancher avec le porteur du projet.
- Mentions d'une affaire cliente précise retirées du journal CLAUDE.md (ce fichier documente le projet, pas les dossiers clients) — contenu des fiches elles-mêmes inchangé.
- **Permalink de collection `_decisions` rendu dynamique via `:path`** (suite à une question du porteur du projet sur la maintenance des `permalink:` en dur) : le blocage initial documenté ci-dessus ne concernait que `:domaine` (champ arbitraire) — `:path`, lui, fait partie du jeu de placeholders fixes que Jekyll résout nativement et retient l'arborescence de dossiers relative à la racine de la collection. `permalink: /domaines-intervention/:path/` ajouté une fois dans `_config.yml` ; les 2 fiches existantes déplacées dans `_decisions/plu-documents-urbanisme/` (nom de fichier sans préfixe de date), leur `permalink:` explicite retiré. URLs générées vérifiées identiques à l'existant (aucun lien cassé). Conséquence pour l'avenir : plus aucun `permalink:` à écrire pour une nouvelle fiche, juste la ranger au bon endroit (`_decisions/<domaine>/<slug>.md`). Champ `tags:` optionnel ajouté au passage (pas encore d'UI de filtre associée, prématuré à 2 fiches).
- **Boutons de filtre par domaine sur `/decisions/`** : `.filter-bar` générée en Liquid depuis les domaines réellement représentés dans `site.decisions` (`map: "domaine" | uniq`, titres résolus via `_data/domaines.yml`) — s'auto-adapte à l'ajout de fiches, n'apparaît que si plus d'un domaine est représenté (inutile avec un seul groupe). `data-domaine` posé sur chaque `.decision-row` (`decision-row.html`), filtrage vanilla JS dans `main.js` (aucune dépendance ajoutée), dégradation sans JS via l'attribut `hidden` par défaut sur la barre (toutes les décisions restent visibles si JS désactivé). Testé en simulant temporairement 2 domaines pour vérifier le rendu, changement de test annulé avant commit.
- **Champ `titre` fusionné dans `title`** sur les fiches `_decisions` (doublon repéré par le porteur du projet) : les deux valaient toujours la même chaîne (contrairement à `resume`/`description`, délibérément distincts par contenu et longueur), `titre` servait uniquement l'affichage (`decision-row.html`, h1 de `_layouts/decision.html`) pendant que `title` restait requis pour `jekyll-seo-tag`/`<title>`. Toutes les références basculées sur `title` (déjà exposé nativement par Jekyll sur tout document) ; le paramètre `title=` devenu redondant retiré de l'appel à `page-header.html` dans `_layouts/decision.html`, qui utilise déjà `page.title` par défaut. Rendu vérifié strictement identique (h1, listes, `headline` JSON-LD).
- **Question posée sur d'éventuels plugins de placeholders de permalink personnalisés** (`jekyll_custom_permalink`, `jekyll-placeholders`), maintenant que le déploiement passe par une Action GitHub Actions avec Gemfile propre (donc hors du bac à sable `github-pages`) : les deux existent et fonctionneraient techniquement, mais tous deux abandonnés depuis 2018-2019 (une seule release 0.0.1 pour le premier, installation Git sans release pour le second, aucune compatibilité Jekyll 4.x déclarée) — écartés au profit de la solution `:path` déjà en place, qui produit la même URL sans dépendance tierce. Pas d'action de code, juste une clarification à conserver si la question revient.
