---
layout: page
title: "Notre équipe"
description: "Présentation de notre équipe d'avocats"
lead: "Découvrez les membres de notre cabinet spécialisé en droit public"
---

<div class="row justify-content-center">
  <div class="col-md-12 col-lg-10 col-xl-8">
    <div class="contributors-list">
      {% for contributor in site.contributors %}
        <div class="contributor-card card mb-4">
          <div class="card-body">
            <h2 class="h3">
              <a href="{{ contributor.url | relative_url }}">{{ contributor.title }}</a>
            </h2>
            {% if contributor.description %}
              <p>{{ contributor.description | safe }}</p>
            {% endif %}
            {% if contributor.lead %}
              <p class="text-muted">{{ contributor.lead | safe }}</p>
            {% endif %}
          </div>
        </div>
      {% endfor %}
    </div>
  </div>
</div>
