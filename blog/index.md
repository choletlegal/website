---
layout: page
title: "Blog"
description: "Articles et analyses juridiques en droit public"
lead: "Retrouvez ici mes articles et analyses sur l'actualité du droit public"
---

<div class="card-list">
  {% assign sorted_posts = site.posts | sort: 'date' | reverse %}
  {% paginate sorted_posts as paginator, offset: 0, limit: 7 %}
    {% for post in paginator.items %}
      <div class="card mb-3">
        <div class="card-body">
          <h2 class="h3"><a class="stretched-link text-body" href="{{ post.url | relative_url }}">{{ post.title }}</a></h2>
          <p>{{ post.lead | default: post.description | safe }}</p>
          {% assign post_date = post.date %}
          {% include main/blog-meta.html %}
        </div>
      </div>
    {% endfor %}
    
    {% include main/pagination.html %}
  {% endpaginate %}
</div>
