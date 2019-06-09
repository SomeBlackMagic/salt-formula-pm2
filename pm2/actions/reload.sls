{%- from "pm2/map.jinja" import pm2 with context %}

{%- set selected_instance = pm2.default_instance %}
{%- if (pillar['instance'] is defined) and (pillar['instance'] is not none) %}
  {%- set selected_instance = pillar['instance'] %}
{%- endif %}

{%- set process = 'all' %}
{%- if (pillar['process'] is defined) and (pillar['process'] is not none) %}
  {%- set process = pillar['process'] %}
{%- endif %}



{%- if pm2.instances is defined  %}

  {%- for instance in pm2.instances %}

    {%- if instance.user ==  selected_instance %}
pm2_{{ instance.user }}_start_or_reload:
  cmd.run:
    - name: 'pm2 startOrReload {{ instance.ecosystem_file_path }} --update-env {{ process }}'
    - runas: '{{ instance.user }}'
    - env:
        - PM2_HOME: '{{ instance.home_dir }}/.pm2'

pm2_{{ instance.user }}_save_config:
  cmd.run:
    - name: 'pm2 save'
    - runas: '{{ instance.user }}'
    - env:
        - PM2_HOME: '{{ instance.home_dir }}/.pm2'
    {%- endif %}
  {%- endfor %}
{%- endif %}

pm2_info_block:
  test.show_notification:
    - name: state_warning
    - text: |
        -----------------------------------------------------------------------------------------------------

        WARNING: You can change default instance(user) and process name in pillar
        WARNING: state.apply ... pillar='{"instance": "root", "process": 'default'}'

        -----------------------------------------------------------------------------------------------------

