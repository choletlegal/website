---
layout: page
title: "Nos Services - Maître Antonin Cholet"
description: "Découvrez nos prestations en droit de l'urbanisme : permis de construire, contentieux, accompagnement."
permalink: /services/
---

<!-- Hero Services -->
<div class="bg-light py-5">
  <div class="container text-center py-5">
    <span class="badge bg-primary mb-3">Nos Services</span>
    <h1>{{ page.title }}</h1>
    <p class="lead text-muted mb-5">
      Nous offrons un accompagnement complet en droit de l'urbanisme
      pour les particuliers, professionnels et collectivités.
    </p>
  </div>
</div>

<!-- Services Grid -->
<div class="container my-5">
  {% assign services_data = site.data.services.services %}
  {% for service in services_data %}
  <div class="row g-5 mb-5 align-items-center">
    <div class="col-lg-6 {% if forloop.index0 > 1 %}order-lg-2{% endif %}">
      <div class="p-4 bg-light rounded">
        <span class="badge mb-3">Service</span>
        <h2 class="h3">{{ service.title }}</h2>
        <p class="text-muted">
          {{ service.description }}
        </p>
        <ul class="list-unstyled mb-4">
          {% for feature in service.features %}
          <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> {{ feature }}</li>
          {% endfor %}
        </ul>
        <a href="{{ service.url }}" class="btn btn-outline-primary">
          <i class="fas fa-arrow-right me-2"></i> En savoir plus
        </a>
      </div>
    </div>
    <div class="col-lg-6 {% if forloop.index0 > 1 %}order-lg-1{% endif %}">
      <!-- <img src="{{ service.image }}"
           alt="{{ service.title }}"
           class="img-fluid rounded shadow-sm"> -->
    </div>
  </div>
  {% endfor %}
</div>

<!-- CTA -->
<div class="text-center my-5">
  <span class="badge bg-primary mb-3">Besoin d'un avis juridique en droit de l'urbanisme ?</span>
  <h2 class="h3 mb-4">Contactez-nous dès maintenant</h2>
  <a href="/contact/" class="btn btn-primary btn-lg px-4">
    <i class="fas fa-calendar-alt me-2"></i> Prendre rendez-vous
  </a>
</div>
