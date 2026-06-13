---
layout: page
title: "Maître Antonin Cholet"
description: "Découvrez le parcours et les spécialisations de Maître Antonin Cholet, avocat en droit de l'urbanisme à Besançon."
permalink: /equipe/antonin-cholet/
---

<div class="row g-5 align-items-center">
  <div class="col-lg-6">
    <span class="badge mb-3">Votre avocat</span>
    <h1>{{ page.title }}</h1>
    <p class="lead text-muted mb-5">
      Avocat au Barreau de Besançon, en droit de l'urbanisme.
    </p>

    {% assign author = site.data.author.author %}
    <h2>Mon Parcours</h2>

    <p>
      <strong>Avocat en droit public de métier</strong>, j’ai prêté serment auprès de la
      <strong>Cour d’appel de Paris</strong> en janvier 2014.
    </p>

    <p>
      Je suis issu d’un parcours classique en faculté de droit, à l’université de Besançon
      puis à celle de Versailles.
    </p>

    <p>
      Une première expérience de juriste à la <strong>Direction juridique d’ENEDIS</strong>
      (ex ERDF), à La Défense, m’a permis de développer une activité de conseil juridique
      auprès de ses directions locales.
    </p>

    <p>
      <strong>Directeur administratif, financier et des ressources humaines</strong> d’un
      établissement public administratif de Seine-Saint-Denis, j’ai pris part au
      fonctionnement particulier d’une collectivité territoriale et appréhendé la pratique
      du droit public à travers elle.
    </p>

    <p>
      Titulaire du Certificat d’aptitude à la profession d’avocat à la suite de mon
      intégration au sein de la <strong>Haute école des avocats conseil de Versailles</strong>,
      j’ai pu parfaire ma connaissance des mécanismes du contentieux administratif auprès
      du <strong>TRIBUNAL ADMINISTRATIF de Rouen</strong>.
    </p>

    <p>
      Mon parcours dans différentes sociétés d’avocats de renommée nationale tel que
      <strong>ADAMAS</strong>, <strong>SOLER-COUTEAUX / LLORENS</strong> ou
      <strong>LAZARE AVOCATS</strong> m’ont permis d’acquérir une méthode de travail rigoureuse
      et une haute technicité juridique.
    </p>

    <p>
      Depuis 2017, je fais partie du Barreau de Besançon où j’ai créé mon propre cabinet
      d’avocat à l’expertise reconnue en droit administratif, notamment en droit de
      l’urbanisme.
    </p>

    <p>
      Les collectivités territoriales comme les entreprises, les particuliers et les
      associations ont recours à mes services dans ce domaine. Mon rôle est de les accompagner
      dans les décisions qu’ils ont à prendre et, le cas échéant, de les représenter devant
      les juridictions administratives.
    </p>
  </div>

  <div class="col-lg-6">
    <div class="card shadow-sm mb-4">
      <div class="card-body text-center">
        <img src="{{ author.avatar }}"
             alt="{{ author.name }}"
             class="rounded mb-3"
             style="width: 500px; height: 500px; object-fit: cover;">
        <h2 class="h4 mb-1">{{ author.name }}</h2>
        <p class="text-muted mb-3">{{ author.bio }}</p>
        {% if author.social %}
        <div class="d-flex justify-content-center gap-3 mb-3">
          {% if author.social.twitter %}
          <a href="https://twitter.com/{{ author.social.twitter | replace: '@', '' }}" class="btn btn-outline-primary btn-sm">
            <i class="fab fa-twitter me-1"></i> Twitter
          </a>
          {% endif %}
          {% if author.social.linkedin %}
          <a href="https://{{ author.social.linkedin }}" class="btn btn-outline-primary btn-sm">
            <i class="fab fa-linkedin-in me-1"></i> LinkedIn
          </a>
          {% endif %}
          {% if author.social.github %}
          <a href="https://{{ author.social.github }}" class="btn btn-outline-primary btn-sm">
            <i class="fab fa-github me-1"></i> GitHub
          </a>
          {% endif %}
          {% if author.social.facebook %}
          <a href="https://{{ author.social.facebook }}" class="btn btn-outline-primary btn-sm">
            <i class="fab fa-facebook-f me-1"></i> Facebook
          </a>
          {% endif %}
        </div>
        {% endif %}
        <div class="text-start">
          <h4 class="h6 mb-3">Domaines d'intervention</h4>
          <ul class="list-unstyled small">
            {% for spec in author.specializations %}
            <li class="mb-2"><i class="fas fa-check-circle icon me-2"></i> {{ spec }}</li>
            {% endfor %}
          </ul>
        </div>
      </div>
    </div>

    {% if author.certifications.size > 0 %}
    <div class="card shadow-sm">
      <div class="card-body">
        <h4 class="mb-3"><i class="fas fa-award text-primary me-2"></i> Certifications</h4>
        <div class="row g-2">
          {% for cert in author.certifications %}
          <div class="col-6">
            <div class="p-3 bg-light rounded">
              <p class="mb-0 small">{{ cert }}</p>
            </div>
          </div>
          {% endfor %}
        </div>
      </div>
    </div>
    {% endif %}
  </div>
</div>
