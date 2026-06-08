---
layout: docs
title: "Documentation"
description: "Notre méthode, nos services et nos tarifs"
lead: "Retrouvez ici toutes les informations sur nos services, notre méthode de travail et nos tarifs"
weight: 1
toc: false
---

<div class="row justify-content-center">
  <div class="col-md-12 col-lg-10 col-xl-8">
    <div class="card-list">
      {% for doc in site.docs %}
        {% if doc.url != page.url %}
          <div class="card my-3">
            <div class="card-body">
              <a class="stretched-link" href="{{ doc.url | relative_url }}">{{ doc.title | title }} &rarr;</a>
            </div>
          </div>
        {% endif %}
      {% endfor %}
    </div>
  </div>
</div>
