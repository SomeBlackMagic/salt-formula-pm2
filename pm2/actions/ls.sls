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

  {%- for user, instance in pm2.instances.items() %}

    {%- if user ==  selected_instance %}
pm2_{{ user }}_ls:
  cmd.run:
    - name: 'pm2 ls'
    - runas: '{{ user }}'
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

