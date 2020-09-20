import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  new Typed('#banner-typed-text', {
    strings: ["permis de construire", "rémunération", "zonage d'urbanisme", "discipline", "propriété"],
    typeSpeed: 50,
    loop: true
  });
}

export { loadDynamicBannerText };
