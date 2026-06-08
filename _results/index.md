---
layout: page
title: "Résultats"
description: "Décisions de justice et résultats obtenus"
lead: "Découvrez quelques-unes de mes décisions de justice récentes"
---

<div class="card-list">
  {% assign sorted_results = site.results | sort: 'date' | reverse %}
  {% paginate sorted_results as paginator, offset: 0, limit: 7 %}
    {% for result in paginator.items %}
      <div class="card mb-3">
        <div class="card-body">
          <h2 class="h3"><a class="stretched-link text-body" href="{{ result.url | relative_url }}">{{ result.title }}</a></h2>
          <p>{{ result.lead | default: result.description | safe }}</p>
          {% assign result_date = result.date %}
          {% include main/blog-meta.html %}
        </div>
      </div>
    {% endfor %}
    
    {% include main/pagination.html %}
  {% endpaginate %}
</div>
