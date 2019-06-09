{%- from "pm2/map.jinja" import pm2 with context %}


{%- if pm2.instances is defined %}

  {%- for instance in pm2.instances %}

  {%- set user = 'root' %}
  {%- if (instance.user is defined) %}{%- set user = instance.user  %}{%- endif %}
  {% set apps = dict(apps=instance.apps) %}

pm2_{{ user }}_setup_ecosystem:
  file.serialize:
    - name: {{ instance.ecosystem_file_path }}
    - user: {{ user }}
    - group: {{ user }}
    - mode: 600
    - show_changes: True
    - create: True
    - merge_if_exists: False
    - formatter: yaml
    - dataset: {{ apps }}

  {%- endfor %}
{%- endif %}
