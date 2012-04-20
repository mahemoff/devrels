---
layout: default
title: Homepage | Devrels
---

<ul class="posts">
  {% for page in site.pages %}
    {% if page.name %}
      <li><a href='{{ page.url }}'>{{ page.name }}</a></li>
    {% endif %}
  {% endfor %}
</ul>
