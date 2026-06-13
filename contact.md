---
layout: page
title: "Contact - Maître Antonin Cholet"
description: "Prenez contact avec Maître Antonin Cholet, avocat en droit de l'urbanisme à Besançon."
permalink: /contact/
---

{% assign author = site.data.author.author %}

<div class="row g-5">
  <!-- Colonne 1: Formulaire -->
  <div class="col-lg-8">
    <span class="badge bg-primary mb-3">Contact</span>
    <h1>{{ page.title }}</h1>
    <p class="lead text-muted mb-5">
      Vous pouvez choisir parmis les différentes modalités de contact suivantes:
    </p>
    <a class='avocat-consultingwidget ' href='https://consultation.avocat.fr/avocat-40539-9f4b.html' data-widget-id='324d442c2bc87652cfdf'>Consulter mon profil Avocat.fr</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src='https://consultation.avocat.fr/js/consultingwidget.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','avocat-widget');</script>

  </div>

  <!-- Colonne 2: Infos Contact -->
  <div class="col-lg-4">
    <div class="card shadow-sm mb-4">
      <div class="card-body">
        <h3 class="h5 mb-4"><i class="fas fa-info-circle text-primary me-2"></i> Informations</h3>

        <div class="d-flex align-items-start mb-4">
          <div class="me-3">
            <i class="fas fa-map-marker-alt text-primary fa-lg"></i>
          </div>
          <div>
            <h4 class="h6 mb-1">Adresse</h4>
            <p class="mb-0 small">
              {{ author.name }}<br>
              {{ author.address.street }}<br>
              {{ author.address.postal_code }} {{ author.address.city }}<br>
              {{ author.address.country }}
            </p>
          </div>
        </div>

        <div class="d-flex align-items-start mb-4">
          <div class="me-3">
            <i class="fas fa-phone text-primary fa-lg"></i>
          </div>
          <div>
            <h4 class="h6 mb-1">Téléphone</h4>
            <p class="mb-0 small">
              <a href="tel:{{ author.phone | replace: ' ', '' }}" class="text-decoration-none">{{ author.phone }}</a>
            </p>
          </div>
        </div>

        <div class="d-flex align-items-start">
          <div class="me-3">
            <i class="fas fa-clock text-primary fa-lg"></i>
          </div>
          <div>
            <h4 class="h6 mb-1">Horaires</h4>
            <p class="mb-0 small">
              Lundi - Vendredi : 9h00 - 18h00<br>
              Samedi : Sur rendez-vous
            </p>
          </div>
        </div>
      </div>
    </div>

    <div class="card shadow-sm">
      <div class="card-body">
        <h3 class="h5 mb-4"><i class="fas fa-map text-primary me-2"></i> Nous trouver</h3>
        <div class="ratio ratio-16x9 mb-3">
          <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2692.507298541913!2d6.0242552156707!3d47.2376884792842!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x478d67e75b1b1bb7%3A0x40c0a3c8e88b220!2s24%20Rue%20de%20la%20Pr%C3%A9fecture%2C%2025000%20Besan%C3%A7on!5e0!3m2!1sfr!2sfr!4v1635724267890!5m2!1sfr!2sfr"
                  width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
        </div>
        <a href="https://www.google.com/maps/dir/?api=1&destination=24+Rue+de+la+Pr%C3%A9fecture,+25000+Besan%C3%A7on"
           class="btn btn-primary btn-sm w-100" target="_blank">
          <i class="fas fa-directions me-2"></i> Itinéraire
        </a>
      </div>
    </div>
  </div>
</div>
