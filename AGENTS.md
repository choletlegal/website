# AGENTS.md - Cadre d'Intervention pour le Site Jekyll

## 📋 **Résumé du Projet**

Site web statique pour **Cabinet Antonin Cholet** - Avocat spécialisé en droit administratif français.

- **Type** : Site statique (SSG) pour optimisation SEO
- **Framework** : Jekyll 4.x
- **Hosting** : GitHub Pages
- **CI/CD** : GitHub Actions (à configurer)

---

## 🔧 **Stack Technique**

| Élément               | Technologie/Outils                          | Version   | Notes |
|-----------------------|--------------------------------------------|-----------|-------|
| **Framework**         | Jekyll (Ruby)                             | 4.4.1     | - |
| **Langage**           | Liquid (templates), Markdown (contenu)     | -         | - |
| **CSS Framework**     | Bootstrap 5 (CDN)                          | 5.3.2     | Mobile-first |
| **Icons**             | Font Awesome 6 (CDN)                       | 6.5.1     | Gratuit |
| **SEO**               | `jekyll-seo-tag`, `jekyll-sitemap`, `jekyll-feed` | Latest | Auto-génération |
| **Hosting**           | GitHub Pages                               | -         | Gratuit |
| **Versioning**        | Git                                        | -         | - |

---

## 🏗 **Structure du Projet**

```bash
.
├── _config.yml              # Configuration globale (SEO, métadonnées, plugins)
├── Gemfile                   # Dépendances Ruby
├── robots.txt               # Règles pour les crawlers
├── .gitignore                # Fichiers exclus du versioning
├── AGENTS.md                 # Ce fichier
│
├── _includes/                # Composants UI réutilisables
│   ├── head-seo.html         # Balises SEO, Open Graph, Schema.org
│   ├── head-css.html         # Import CSS (Bootstrap, FA, Custom)
│   ├── head-js.html          # Import JS (Bootstrap, Custom)
│   │
│   ├── header/
│   │   ├── navbar.html       # Navigation responsive
│   │   └── hero.html         # Bannière d'accueil
│   │
│   ├── sections/
│   │   ├── services.html     # Grille des services
│   │   └── cta.html          # Call-to-action
│   │
│   └── footer/
│       └── footer.html       # Pied de page complet
│
├── _layouts/                 # Templates de base
│   ├── base.html             # Structure HTML minimale
│   ├── default.html          # Layout principal (header + footer)
│   ├── page.html             # Pour les pages statiques (À propos, Services, Contact)
│   └── post.html             # Pour les articles de blog
│
├── _sass/                    # Styles SCSS (variables et custom)
│   ├── _variables.scss       # Couleurs, typographie, breakpoints
│   └── custom.scss           # Styles personnalisés
│
├── _data/                    # Données YAML
│   ├── services.yml          # Liste des services
│   └── author.yml            # Infos avocat
│
├── assets/                   # Fichiers statiques
│   ├── css/
│   │   └── main.css          # CSS compilé (custom)
│   ├── js/
│   │   └── main.js           # JavaScript custom
│   └── images/               # Images (à remplir)
│
├── blog/                     # Pages du blog
│   └── index.html            # Liste des articles
│
├── _posts/                   # Articles (Markdown)
│   └── *.md                  # Futurs articles
│
└── *.md, *.html              # Pages statiques (accueil, à propos, services, contact)
```

---

## 🚀 **Règles de Développement**

### 1. **Plan First, Implement in Small Diffs**
- **Toute feature > 2h** doit être planifiée en issue/todo.
- **Découper en commits atomiques** :
  - Ex: `feat(layout): add responsive navbar`
  - Ex: `fix(seo): update canonical URL in head`
  - Ex: `docs: add AGENTS.md`
- Utiliser `git rebase -i` pour squasher les commits si nécessaire.
- **Ne jamais commiter** sans avoir testé localement (`bundle exec jekyll serve`).

### 2. **Tests Before Feature (Quand Possible)**
- Pour les composants critiques (formulaire, navigation) :
  - Créer une page de test sous `/test/` (ex: `/test/form.html`).
  - Vérifier le rendu **mobile** ET **desktop** avant intégration.
- **Validation obligatoire** :
  - [Lighthouse](https://developer.chrome.com/docs/lighthouse/overview/) (SEO, accessibilité, performance)
  - [W3C Validator](https://validator.w3.org/)
  - [Responsinator](https://www.responsinator.com/) (multi-devices)

### 3. **Keep Components Small**
- **`/_includes/`** : Chaque fichier doit :
  - Avoir **une seule responsabilité**.
  - Être **< 50 lignes** (sinon, découper).
  - Ex: `navbar.html` ≠ `navbar + footer + hero`
- **`/_layouts/`** : Utiliser l'héritage (`base.html` → `default.html` → `page.html`).
- **Réutilisation** : Utiliser `{% include %}` pour les éléments répétés.

### 4. **Responsive by Default**
- **Mobile-First** : Designer d'abord pour `min-width: 320px`.
- **Bootstrap Breakpoints** :
  - `xs` (<576px), `sm` (≥576px), `md` (≥768px), `lg` (≥992px), `xl` (≥1200px)
- **Tests obligatoires** :
  - Chrome DevTools (Device Mode)
  - iPhone 5, Galaxy S9, iPad, Desktop 1920x1080
- **Priorité** : Lecture optimale sur téléphone (police lisible, boutons assez grands).

### 5. **Atomic Commit Messages**
- **Format** : `<type>(<scope>): <description>`
  - Types : `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
  - Scope : `layout`, `seo`, `blog`, `assets`, `data`, `config`
- **Exemples** :
  - `feat(seo): add Schema.org JSON-LD for author`
  - `fix(layout): correct navbar mobile toggle`
  - `style(buttons): adjust primary button hover`
  - `docs: update README with deployment instructions`
  - `chore(deps): update jekyll-seo-tag to v2.8.0`

---

## 📏 **Bonnes Pratiques Spécifiques**

### **Nommage**
| Type          | Convention          | Exemple                     |
|---------------|---------------------|-----------------------------|
| Fichiers      | `kebab-case`         | `droit-administratif.md`    |
| Classes CSS   | `BEM`                | `.button--primary`          |
| IDs           | `camelCase` ou `-`   | `heroSection` ou `hero-section` |
| Variables SCSS| `$nom-description`   | `$primary-color`            |

### **Images**
- **Formats** : `.webp` (prioritaire) + `.jpg` (fallback)
- **Tailles** : Max 500Ko par page
- **Optimisation** : Utiliser [Squoosh](https://squoosh.app/) ou `jekyll-image-optimize`
- **Balises** : `alt` **obligatoire** pour toutes les images

### **SEO**
- **Balises obligatoires** :
  - `title` (unique, < 60 caractères)
  - `description` (< 160 caractères)
  - `canonical_url`
  - `og:image` (1200x630px minimum)
- **URLs** : Courtes, avec mots-clés (ex: `/droit-administratif/conseil/`)
- **Schema.org** : JSON-LD pour `Person`, `WebSite`, `Article`, `BreadcrumbList`
- **Sitemap** : Auto-généré par `jekyll-sitemap`
- **Robots.txt** : Déjà configuré (autorise tout, bloque les dossiers internes)

### **Accessibilité**
- **Contraste** : Vérifier avec [WebAIM](https://webaim.org/resources/contrastchecker/) (ratio ≥ 4.5:1)
- **Balises** :
  - `aria-label` pour les icônes/liens
  - `alt` pour les images
  - `lang="fr"` sur `<html>`
- **Navigation** : Accessible au clavier (tabulation logique)

### **Performance**
- **CSS/JS** : Minifiés (via CDN pour Bootstrap/FA)
- **Lazy Loading** : Pour les images `loading="lazy"`
- **Preload** : Pour les polices critiques

---

## ⚠ **Contraintes**

- ❌ **Pas de JavaScript lourd** : Éviter React, Vue, Angular. Utiliser Vanilla JS ou Alpine.js si nécessaire.
- ❌ **Pas de dépendances inutiles** : Privilégier les CDN pour Bootstrap/Font Awesome.
- ❌ **Pas de duplication** : Réutiliser les composants via `{% include %}`.
- ❌ **Pas de commits larges** : Max 1 feature/commit.
- ❌ **Pas de merges sans review** : Toujours valider les PR avant merge.

---

## 📝 **Workflows**

### **Création d'une nouvelle page**
1. Créer le fichier `.md` ou `.html` à la racine ou dans `/blog/`
2. Ajouter le front matter avec `layout`, `title`, `description`
3. Utiliser un layout existant (`page`, `post`, ou `default`)
4. Tester localement avec `bundle exec jekyll serve`
5. Valider le SEO avec Lighthouse

### **Ajout d'un article de blog**
1. Créer le fichier dans `_posts/YYYY-MM-DD-titre.md`
2. Front matter obligatoire :
   ```yaml
   ---
   layout: post
   title: "Titre de l'article"
   description: "Description pour SEO"
   categories: ["Droit administratif"]
   image: "/assets/images/article.jpg"
   ---
   ```
3. Écrire le contenu en Markdown
4. Ajouter une image d'en-tête (1200x630px)

### **Mise à jour des données**
- Modifier les fichiers dans `_data/` (YAML)
- Ex: `services.yml` pour ajouter/modifier un service
- Ex: `author.yml` pour mettre à jour les infos de l'avocat

---

## 🛠 **Commandes Utiles**

| Commande | Description |
|----------|-------------|
| `bundle exec jekyll serve` | Lance le serveur local (http://localhost:4000) |
| `bundle exec jekyll build` | Génère le site dans `_site/` |
| `bundle exec jekyll serve --livereload` | Serveur avec rechargement automatique |
| `bundle install` | Installe les dépendances Ruby |
| `bundle update` | Met à jour les dépendances |

---

## 📞 **Support & Validation**

- **Problème technique** : Vérifier les logs de build, tester en isolation.
- **Validation requise** : Toujours valider avec le client avant déploiement.
- **Déploiement** : Push sur `main` → GitHub Pages (action automatique).

---

## 📅 **Prochaines Étapes (Phase 2)**

- [ ] Créer les pages de services détaillées (`/services/droit-administratif/`, etc.)
- [ ] Ajouter des articles de blog d'exemple dans `_posts/`
- [ ] Configurer les pages légales (mentions légales, RGPD)
- [ ] Optimiser les images (créer les placeholders)
- [ ] Configurer GitHub Actions pour le déploiement automatique
