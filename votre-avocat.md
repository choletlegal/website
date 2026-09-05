---
layout: default
title: "Maître Antonin Cholet"
description: "Découvrez le parcours et les spécialisations de Maître Antonin Cholet, avocat en droit de l'urbanisme à Besançon."
permalink: /votre-avocat/
---

{% assign author = site.data.author.author %}

{% include page-header.html eyebrow_text="Votre avocat" lede="Avocat au Barreau de Besançon, en droit de l'urbanisme." %}

<div class="section">
  <div class="wrap split-layout">
    <div class="page-domaine-content">
      <h2>Mon parcours</h2>

      <p>
        <strong>Avocat en droit public de métier</strong>, j'ai prêté serment auprès de la
        <strong>Cour d'appel de Paris</strong> en janvier 2014.
      </p>

      <p>
        Je suis issu d'un parcours classique en faculté de droit, à l'université de Besançon
        puis à celle de Versailles.
      </p>

      <p>
        Une première expérience de juriste à la <strong>Direction juridique d'ENEDIS</strong>
        (ex ERDF), à La Défense, m'a permis de développer une activité de conseil juridique
        auprès de ses directions locales.
      </p>

      <p>
        <strong>Directeur administratif, financier et des ressources humaines</strong> d'un
        établissement public administratif de Seine-Saint-Denis, j'ai pris part au
        fonctionnement particulier d'une collectivité territoriale et appréhendé la pratique
        du droit public à travers elle.
      </p>

      <p>
        Titulaire du Certificat d'aptitude à la profession d'avocat à la suite de mon
        intégration au sein de la <strong>Haute école des avocats conseil de Versailles</strong>,
        j'ai pu parfaire ma connaissance des mécanismes du contentieux administratif auprès
        du <strong>TRIBUNAL ADMINISTRATIF de Rouen</strong>.
      </p>

      <p>
        Mon parcours dans différentes sociétés d'avocats de renommée nationale tel que
        <strong>ADAMAS</strong>, <strong>SOLER-COUTEAUX / LLORENS</strong> ou
        <strong>LAZARE AVOCATS</strong> m'ont permis d'acquérir une méthode de travail rigoureuse
        et une haute technicité juridique.
      </p>

      <p>
        Depuis 2017, je fais partie du Barreau de Besançon où j'ai créé mon propre cabinet
        d'avocat à l'expertise reconnue en droit administratif, notamment en droit de
        l'urbanisme.
      </p>

      <p>
        Les collectivités territoriales comme les entreprises, les particuliers et les
        associations ont recours à mes services dans ce domaine. Mon rôle est de les accompagner
        dans les décisions qu'ils ont à prendre et, le cas échéant, de les représenter devant
        les juridictions administratives.
      </p>
    </div>

    <aside class="info-card avocat-card">
      <img class="avocat-portrait"
           src="{{ author.avatar }}"
           alt="{{ author.name }}, avocat au Barreau de Besançon"
           width="914" height="913">
      <p class="avocat-name">{{ author.name }}</p>
      <p class="avocat-title">{{ author.bio }}</p>

      {% if author.social %}
      <div class="footer-socials">
        {% if author.social.linkedin %}
        <a href="https://{{ author.social.linkedin }}" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn">
          {% include icons/social-linkedin.svg.html %}
        </a>
        {% endif %}
        {% if author.social.facebook %}
        <a href="https://{{ author.social.facebook }}" target="_blank" rel="noopener noreferrer" aria-label="Facebook">
          {% include icons/social-facebook.svg.html %}
        </a>
        {% endif %}
        {% if author.social.wsocial %}
        <a href="https://{{ author.social.wsocial }}" target="_blank" rel="noopener noreferrer" aria-label="W Social">
          {% include icons/social-wsocial.svg.html %}
        </a>
        {% endif %}
      </div>
      {% endif %}

      {% if author.specializations.size > 0 %}
      <h3>Domaines d'intervention</h3>
      <ul class="feature-list">
        {% for spec in author.specializations %}
        <li>{{ spec }}</li>
        {% endfor %}
      </ul>
      {% endif %}

      {% if author.certifications.size > 0 %}
      <h3>Certifications</h3>
      <ul class="feature-list">
        {% for cert in author.certifications %}
        <li>{{ cert }}</li>
        {% endfor %}
      </ul>
      {% endif %}
    </aside>
  </div>
</div>

{% include sections/cta.html %}
