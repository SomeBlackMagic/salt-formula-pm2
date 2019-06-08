{%- from "pm2/map.jinja" import pm2 with context %}

pm2_install:
  npm.installed:
    - name: pm2@{{ pm2.get('version', 'latest') }}


  {%- if pm2.instances is defined %}

    {%- for instance in pm2.instances %}

      {%- set startup_cmd = ["pm2 startup --user=" ~ pm2.get('user', 'root')] %}
      {%- if pm2.home_dir is defined %}{%- do startup_cmd.append("--hp=" ~ pm2.home_dir) %}{%- endif %}
      {%- if pm2.startup_platform is defined %}{%- do startup_cmd.append(pm2.startup_platform) %}{%- endif %}

      {%- set user = 'root' %}
      {%- if (instance.user is defined) %}{%- set user = instance.user  %}{%- endif %}

      {%- set home_dir = '/root/' %}
      {%- if (instance.home_dir is defined) %}{%- set home_dir = instance.home_dir  %}{%- endif %}

      {%- if (instance.startup is defined) and (instance.startup is not none) and (instance.startup) %}
        {%- set startup_cmd = "pm2 startup --no-daemon --user=" ~ user ~ " --hp=" ~ home_dir %}

pm2_{{ user }}_startup_script:
  cmd.run:
    - name: {{ startup_cmd }}

pm2_{{ user }}_startup_enable:
  service.enabled:
    - name: 'pm2-{{ user }}'

pm2_{{ user }}_startup_run:
  service.running:
    - name: 'pm2-{{ user }}'
    - enable: True

      {%- endif %}

      {# install pm2 modules for instance #}

      {%- if (instance.modules is defined) and (instance.modules is not none) %}
        {%- for name, config in instance.modules.items() %}
pm2_{{ user }}_install_module_{{ name }}:
  cmd.run:
    - name: 'pm2 install {{ name }}'
    - user: '{{ user }}'
    - env:
        - PM2_HOME: '{{ home_dir }}/.pm2'
          {# config pm2 module for instance #}
          {%- for key, value in config.items() %}
pm2_{{ user }}_install_module_{{ name }}_set_{{key}}:
  cmd.run:
    - name: 'pm2 set {{ name }}:{{ key }}  {{ value }}'
    - user: '{{ user }}'
    - env:
        - PM2_HOME: '{{ home_dir }}/.pm2'

          {%- endfor %}
        {%- endfor %}
      {%- endif %}

      {# install bash completion for instance #}
      {%- if (instance.completion_install is defined) and (instance.completion_install is not none) and  (instance.completion_install)%}
pm2_{{ user }}_install_complition:
  cmd.run:
    - name: 'pm2 completion install'
    - user: '{{ user }}'
    - env:
        - PM2_HOME: '{{ home_dir }}/.pm2'
        - SHELL: '{{ instance.completion_shell }}'
        - HOME: '{{ home_dir }}'

      {%- endif %}


    {%- endfor %}
  {%- endif %}

