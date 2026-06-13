// ============================================
// Main JavaScript - Cholet Legal
// ============================================

// --- DOM Ready ---
document.addEventListener('DOMContentLoaded', function() {
  // Initialize Bootstrap tooltips
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
  tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });

  // Initialize Bootstrap popovers
  const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
  popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl);
  });

  // Form validation
  const forms = document.querySelectorAll('.needs-validation');
  Array.from(forms).forEach(form => {
    form.addEventListener('submit', function(event) {
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    }, false);
  });

  // Smooth scroll for anchor links
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const targetId = this.getAttribute('href');
      const targetElement = document.querySelector(targetId);
      if (targetElement) {
        targetElement.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });

  // Add fade-in animation on scroll
  const animateOnScroll = () => {
    const elements = document.querySelectorAll('.fade-in');
    elements.forEach(element => {
      const elementPosition = element.getBoundingClientRect().top;
      const windowHeight = window.innerHeight;
      if (elementPosition < windowHeight - 100) {
        element.classList.add('animated');
      }
    });
  };

  // Run on load and scroll
  animateOnScroll();
  window.addEventListener('scroll', animateOnScroll);

  // Mobile menu close on click
  const navbarToggler = document.querySelector('.navbar-toggler');
  const navbarCollapse = document.querySelector('.navbar-collapse');
  if (navbarToggler && navbarCollapse) {
    document.querySelectorAll('.navbar-nav .nav-link').forEach(link => {
      link.addEventListener('click', () => {
        if (navbarCollapse.classList.contains('show')) {
          navbarToggler.click();
        }
      });
    });
  }
});

// --- Timeline CSS (pour la page À propos) ---
document.addEventListener('DOMContentLoaded', function() {
  const style = document.createElement('style');
  style.textContent = `
    .timeline-marker {
      width: 12px;
      height: 12px;
      border-radius: 50%;
      margin-top: 6px;
      flex-shrink: 0;
    }
    
    .timeline::before {
      content: '';
      position: absolute;
      left: 7px;
      top: 0;
      bottom: 0;
      width: 2px;
      background-color: #e2e8f0;
    }
    
    @media (max-width: 767.98px) {
      .timeline::before {
        left: 20px;
      }
    }
  `;
  document.head.appendChild(style);
});

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
