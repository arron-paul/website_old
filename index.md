---
layout: page
title: Home
description: arron.io
---

### Hey, I'm Arron.

<img src="{% asset_path photographs/gpoy-greyscale.jpg %}" />

{% include fragments/about-me.md %} I have always been enthused by the intricacies of computer software and the creation of digital content. It has become a passion of mine to design & develop good software, in order to provoke positive human responses, present information effectively, and create intuitive and aesthetically pleasing user experiences.

### Writing
<ul class="items">
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>

### Projects
<ul class="items">
  {% for project in site.projects %}

    {% capture anchor_href %}
      {% if project.redirect %}
        {{ project.redirect }}
      {% else %}
        {{ project.url }}
      {% endif %}
    {% endcapture %}

    {% capture anchor_title %}
      {{ project.title }}
    {% endcapture %}

    <li>
      <a title="{{ anchor_title }}" href="{{ anchor_href }}">{{ project.title }}</a>
    </li>

  {% endfor %}
</ul>
