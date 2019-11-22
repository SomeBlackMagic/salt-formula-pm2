{%- from "pm2/map.jinja" import pm2 with context %}

{%- set selected_instance = pm2.default_instance %}
{%- if (pillar['instance'] is defined) and (pillar['instance'] is not none) %}
  {%- set selected_instance = pillar['instance'] %}
{%- endif %}


{%- if pm2.instances is defined  %}

  {%- for user, instance in pm2.instances.items() %}

    {%- if user ==  selected_instance %}
pm2_{{ user }}_stop:
  cmd.run:
    - name: 'pm2 ls {{ instance.ecosystem_file_path }}'
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

        WARNING: You can change default instance(user)
        WARNING: state.apply ... pillar='{"instance": "root"}'

        -----------------------------------------------------------------------------------------------------

