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
(function () {
  var header = document.querySelector('.site-header');
  if (!header) return;
  var threshold = 40;
  function onScroll() {
    header.classList.toggle('is-scrolled', window.scrollY > threshold);
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
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

// --- Google Analytics (à décommenter après configuration) ---
// function loadGA() {
//   if (window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1') {
//     window.dataLayer = window.dataLayer || [];
//     function gtag(){dataLayer.push(arguments);}
//     gtag('js', new Date());
//     gtag('config', 'GA_MEASUREMENT_ID');
//
//     const script = document.createElement('script');
//     script.src = 'https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID';
//     script.async = true;
//     document.head.appendChild(script);
//   }
// }
// loadGA();
