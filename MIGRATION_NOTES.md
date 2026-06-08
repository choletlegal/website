# Notes de Migration : Hugo → Jekyll

## 📋 Résumé

Ce document décrit les changements effectués lors de la migration du site **choletlegal/website** du framework **Hugo + thème Doks** vers **Jekyll**.

## 🎯 Objectifs de la Migration

1. **Simplifier la maintenance** : Jekyll est plus simple à maintenir pour un site de cette taille
2. **Améliorer la compatibilité** : Meilleure intégration avec GitHub Pages
3. **Conserver le design** : Garder l'apparence et les fonctionnalités du site original
4. **Optimiser les performances** : Jekyll génère des sites statiques très performants

## 📁 Structure du Projet

### Avant (Hugo)
```
.
├── config/                  # Configuration Hugo
├── content/                # Contenu Markdown
├── layouts/                # Templates Hugo
├── assets/                 # Ressources statiques
├── static/                 # Fichiers statiques
├── netlify.toml            # Configuration Netlify
└── theme.toml              # Thème Doks
```

### Après (Jekyll)
```
.
├── _config.yml             # Configuration principale
├── _data/                  # Données structurées (menus, etc.)
├── _includes/              # Partiels réutilisables
├── _layouts/               # Layouts principaux
├── _posts/                 # Articles de blog
├── _docs/                  # Documentation (collection)
├── _results/               # Résultats juridiques (collection)
├── assets/                # CSS, JS, images
├── blog/                   # Pages du blog
├── docs/                   # Pages de documentation
├── results/                # Pages des résultats
├── contributors/           # Pages des contributeurs
├── Gemfile                 # Dépendances Ruby
├── Gemfile.lock            # Verrouillage des dépendances
└── .github/workflows/      # GitHub Actions
```

## 🔧 Changements Techniques

### 1. Configuration

| **Hugo** | **Jekyll** | **Notes** |
|----------|------------|-----------|
| `config.toml` | `_config.yml` | Format YAML au lieu de TOML |
| `params.toml` | Intégré dans `_config.yml` | Tous les paramètres dans un seul fichier |
| `menus.fr.toml` | `_data/menus.yml` | Structure YAML pour les menus |

### 2. Contenu

| **Hugo** | **Jekyll** | **Notes** |
|----------|------------|-----------|
| `content/fr/blog/*.md` | `_posts/YYYY-MM-DD-title.md` | Format de date obligatoire |
| `content/fr/docs/*.md` | `_docs/*.md` | Collection Jekyll |
| `content/fr/results/*.md` | `_results/*.md` | Collection Jekyll |
| `content/fr/_index.md` | `index.md` | Page d'accueil |

### 3. Layouts

| **Hugo** | **Jekyll** | **Notes** |
|----------|------------|-----------|
| `layouts/_default/baseof.html` | `_layouts/default.html` | Layout de base |
| `layouts/blog/single.html` | `_layouts/post.html` | Article de blog |
| `layouts/docs/single.html` | `_layouts/docs.html` | Page de documentation |
| `layouts/results/single.html` | `_layouts/result.html` | Résultat juridique |
| `layouts/_partials/*` | `_includes/*` | Partiels réutilisables |

### 4. Plugins

| **Fonctionnalité Hugo** | **Plugin Jekyll** | **Notes** |
|------------------------|-------------------|-----------|
| Pagination | `jekyll-paginate-v2` | Pagination avancée |
| Sitemap | `jekyll-sitemap` | Génération automatique |
| SEO | `jekyll-seo-tag` | Balises SEO automatiques |
| Feed RSS | `jekyll-feed` | Flux RSS |
| Compression HTML | `jekyll-compress` | Minification |

### 5. Assets

- **CSS** : Conversion du SCSS Doks vers un SCSS personnalisé
- **JS** : Conservation des scripts existants (darkmode, instant.page, etc.)
- **Images** : Copiées depuis `assets/images/` et `static/images/`

## 🎨 Design et Fonctionnalités

### Conservé
- ✅ Design général (couleurs, typographie, mise en page)
- ✅ Barre de navigation avec menu responsive
- ✅ Sidebar pour la documentation
- ✅ Dark mode
- ✅ InstantPage pour le chargement rapide
- ✅ LazySizes pour les images
- ✅ Highlight.js pour la coloration syntaxique
- ✅ Bootstrap 5 pour les composants UI

### Modifié
- 🔄 **Menus** : Structure simplifiée dans `_data/menus.yml`
- 🔄 **Pagination** : Utilisation de `jekyll-paginate-v2` au lieu de la pagination Hugo
- 🔄 **SEO** : Utilisation de `jekyll-seo-tag` pour les balises méta
- 🔄 **Recherche** : Intégration prévue avec Algolia (à configurer)

### Supprimé
- ❌ **FlexSearch** : Remplacé par Algolia
- ❌ **KaTeX** : Désactivé (non utilisé)
- ❌ **Mermaid** : Désactivé (non utilisé)

## 📊 Comparaison des Fonctionnalités

| **Fonctionnalité** | **Hugo** | **Jekyll** | **Statut** |
|-------------------|---------|------------|------------|
| Multilingue | ✅ | ⚠️ (Plugin nécessaire) | Désactivé |
| Collections | ✅ | ✅ | Implémenté |
| Pagination | ✅ | ✅ | Implémenté |
| SEO | ✅ | ✅ | Amélioré |
| Sitemap | ✅ | ✅ | Implémenté |
| Feed RSS | ✅ | ✅ | Implémenté |
| Recherche | FlexSearch | Algolia | À configurer |
| Dark Mode | ✅ | ✅ | Implémenté |
| InstantPage | ✅ | ✅ | Implémenté |
| LazySizes | ✅ | ✅ | Implémenté |

## 🚀 Déploiement

### Avant (Netlify)
- Configuration via `netlify.toml`
- Déploiement automatique sur push

### Après (GitHub Pages)
- Configuration via GitHub Actions (`.github/workflows/jekyll.yml`)
- Déploiement automatique sur push vers `master` ou `vibe/jekyll-migration-aeaf64`
- CNAME : `www.cholet-avocat.fr`

## 🔧 Configuration Requise

### 1. Algolia
Pour activer la recherche avec Algolia :
1. Créer un compte sur [Algolia](https://www.algolia.com/)
2. Créer un index
3. Remplir les informations dans `_config.yml` :
   ```yaml
   algolia:
     application_id: "VOTRE_APPLICATION_ID"
     search_only_api_key: "VOTRE_API_KEY"
     index_name: "VOTRE_INDEX"
   ```
4. Créer un fichier `assets/js/algolia.js` pour l'intégration

### 2. Domaines Personnalisés
Le site est configuré pour utiliser `www.cholet-avocat.fr` via GitHub Pages.

### 3. HTTPS
GitHub Pages fournit automatiquement un certificat SSL.

## 📝 Notes Supplémentaires

### Différences entre Hugo et Jekyll

1. **Syntaxe des templates** :
   - Hugo utilise les templates Go (`.html`)
   - Jekyll utilise Liquid (`.html` avec `{{ }}` et `{% %}`)

2. **Gestion des collections** :
   - Hugo : Dossiers dans `content/` avec `_index.md`
   - Jekyll : Collections définies dans `_config.yml`

3. **Variables** :
   - Hugo : `.Site.Params`, `.Page.Title`
   - Jekyll : `site.params`, `page.title`

4. **URLs** :
   - Hugo : `{{ .RelPermalink }}`
   - Jekyll : `{{ page.url | relative_url }}`

5. **Dates** :
   - Hugo : `{{ .Date | time.Format "2006-01-02" }}`
   - Jekyll : `{{ page.date | date: "%Y-%m-%d" }}`

### Problèmes Connus

1. **Pagination** : `jekyll-paginate-v2` a une syntaxe différente de la pagination Hugo
2. **Collections** : Les collections Jekyll nécessitent une configuration explicite
3. **Permalinks** : Les URLs peuvent différer légèrement

### Améliorations Apportées

1. **SEO** : Meilleure intégration avec `jekyll-seo-tag`
2. **Structure** : Organisation plus claire des fichiers
3. **Maintenance** : Moins de dépendances externes
4. **Performance** : Génération statique optimisée

## 🎯 Prochaines Étapes

1. [ ] Tester le site localement avec `bundle exec jekyll serve`
2. [ ] Configurer Algolia pour la recherche
3. [ ] Vérifier tous les liens internes
4. [ ] Tester le déploiement sur GitHub Pages
5. [ ] Vérifier le SEO avec Google Search Console
6. [ ] Mettre à jour les liens externes (réseaux sociaux, etc.)

## 📞 Support

Pour toute question concernant cette migration, contactez :
- **Antonin Cholet** : contact@cholet-avocat.fr
- **GitHub** : [choletlegal/website](https://github.com/choletlegal/website/)

---

*Document généré le : {{ "now" | date: "%Y-%m-%d" }}*
*Version : 1.0*
