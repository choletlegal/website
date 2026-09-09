// ============================================
// JavaScript — vanilla, aucune dépendance (Bootstrap retiré)
// ============================================

// --- Menu burger mobile (header natif, Piste B) ---
(function () {
  var btn = document.getElementById('burger-btn');
  var panel = document.getElementById('mobile-panel');
  if (!btn || !panel) return;
  btn.addEventListener('click', function () {
    var open = btn.getAttribute('aria-expanded') === 'true';
    btn.setAttribute('aria-expanded', String(!open));
    panel.hidden = open;
    btn.setAttribute('aria-label', open ? 'Ouvrir le menu' : 'Fermer le menu');
  });
})();

// --- Header : bascule des couleurs du hero vers l'apparence claire au scroll ---
// N'a d'effet visuel que sur les pages avec `hero: true` en front matter
// (cf. main.css, body.has-inverted-hero) ; inoffensif ailleurs.
// IntersectionObserver sur une sentinelle (#scroll-sentinel, cf. main.css) plutôt qu'un
// listener `scroll` + lecture de `window.scrollY` : cette lecture forçait un reflow
// synchrone (~104ms mesurés via Lighthouse, cf. CLAUDE.md) car le header est en
// `position: sticky` — connu de Chrome pour forcer un recalcul de mise en page dès
// qu'une géométrie de scroll est interrogée après une invalidation de style. L'IO
// ne lit jamais de géométrie depuis le fil principal et ne s'exécute pas à chaque
// frame de scroll, ce qui élimine le problème à la racine plutôt que de le déplacer.
(function () {
  var header = document.querySelector('.site-header');
  var sentinel = document.getElementById('scroll-sentinel');
  if (!header || !sentinel || !('IntersectionObserver' in window)) return;
  var observer = new IntersectionObserver(function (entries) {
    header.classList.toggle('is-scrolled', !entries[0].isIntersecting);
  });
  observer.observe(sentinel);
})();

// --- Décisions obtenues : filtre par domaine (page /decisions/) ---
// N'a d'effet que si la page contient un .filter-bar (posé par decisions.html
// uniquement quand les décisions couvrent plus d'un domaine) ; masqué par
// défaut via l'attribut "hidden" pour ne pas afficher des boutons inertes si
// le JS est désactivé — toutes les décisions restent alors visibles.
(function () {
  var bar = document.querySelector('.filter-bar');
  if (!bar) return;
  var rows = document.querySelectorAll('.proof-list .decision-row');
  var buttons = bar.querySelectorAll('.filter-btn');
  bar.hidden = false;
  bar.addEventListener('click', function (e) {
    var btn = e.target.closest('.filter-btn');
    if (!btn) return;
    var filter = btn.getAttribute('data-filter');
    for (var i = 0; i < buttons.length; i++) {
      buttons[i].setAttribute('aria-pressed', String(buttons[i] === btn));
    }
    for (var j = 0; j < rows.length; j++) {
      rows[j].hidden = filter !== 'all' && rows[j].getAttribute('data-domaine') !== filter;
    }
  });
})();

// --- Google Analytics (GA4) ---
// Chargé dynamiquement plutôt qu'en <script> statique dans head-js.html pour ne
// jamais peser sur le rendu (aucun impact LCP/FCP) ; désactivé sur localhost pour
// ne pas polluer les statistiques avec le trafic de développement.
(function loadGA() {
  if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') return;
  window.dataLayer = window.dataLayer || [];
  function gtag() { dataLayer.push(arguments); }
  gtag('js', new Date());
  gtag('config', 'G-LVMH7WLBL6');

  var script = document.createElement('script');
  script.src = 'https://www.googletagmanager.com/gtag/js?id=G-LVMH7WLBL6';
  script.async = true;
  document.head.appendChild(script);
})();
