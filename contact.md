---
layout: default
title: "Contact"
description: "Contactez Maître Antonin Cholet, avocat au Barreau de Besançon : coordonnées, horaires et prise de rendez-vous en ligne."
permalink: /contact/
---

{% assign author = site.data.author.author %}

{% capture lede %}
Maître Antonin Cholet vous reçoit sur rendez-vous, au cabinet ou par téléphone, pour tout
dossier de droit public ou de droit de l'urbanisme. Vous pouvez choisir parmi les différentes
modalités de contact suivantes.
{% endcapture %}
{% include page-header.html eyebrow_text="Contact" lede=lede %}

<div class="section">
  <div class="wrap split-layout contact-split">
    <div>
      <h2>Prendre rendez-vous en ligne</h2>
      <p>Réservez directement un créneau de consultation via mon profil Avocat.fr.</p>
      <a class='avocat-consultingwidget' href='https://consultation.avocat.fr/avocat-40539-9f4b.html' data-widget-id='324d442c2bc87652cfdf'>Consulter mon profil Avocat.fr</a>
      <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src='https://consultation.avocat.fr/js/consultingwidget.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','avocat-widget');</script>
    </div>

    <aside>
      <div class="info-card">
        <h3>Informations</h3>
        <dl class="info-list">
          <div>
            <dt>Adresse</dt>
            <dd>
              {{ author.name }}<br>
              {{ author.address.street }}<br>
              {{ author.address.postal_code }} {{ author.address.city }}<br>
              {{ author.address.country }}
            </dd>
          </div>
          <div>
            <dt>Téléphone</dt>
            <dd><a href="tel:{{ author.phone | replace: ' ', '' }}">{{ author.phone }}</a></dd>
          </div>
          <div>
            <dt>Horaires</dt>
            <dd>
              Lundi – vendredi : 9h00 – 18h00<br>
              Samedi : sur rendez-vous
            </dd>
          </div>
        </dl>
      </div>

      <div class="info-card">
        <h3>Nous trouver</h3>
        <div class="map-embed">
          <iframe
            src="https://www.openstreetmap.org/export/embed.html?bbox=6.01752%2C47.23185%2C6.02928%2C47.23635&layer=mapnik&marker=47.2341014%2C6.0233971"
            width="100%" height="100%" style="border:0;" loading="lazy"
            title="Localisation du cabinet, 24 rue de la Préfecture, Besançon"></iframe>
        </div>
        <a class="action-btn action-btn-outline"
           href="https://www.google.com/maps/dir/?api=1&destination=24+Rue+de+la+Pr%C3%A9fecture,+25000+Besan%C3%A7on"
           target="_blank" rel="noopener noreferrer">Itinéraire</a>
      </div>
    </aside>
  </div>
</div>
