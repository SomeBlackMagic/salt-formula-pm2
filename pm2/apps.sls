{%- from "pm2/map.jinja" import pm2 with context %}


{%- if pm2.instances is defined %}

  {%- for user, instance in pm2.instances.items() %}

    {%- set apps = [] -%}

    {%- for alias, item in instance.apps.items() %}
      {%- do apps.append(item) -%}
    {%- endfor %}

   {% set apps_dst = dict(apps=apps) %}

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
    - dataset: {{ apps_dst }}



  {%- endfor %}
{%- endif %}


