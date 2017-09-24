{%- from "pm2/map.jinja" import pm2 with context %}

pm2_install:
  npm.installed:
    - name: pm2@{{ pm2.get('version', 'latest') }}

{%- set startup_cmd = ["pm2 startup --user=" ~ pm2.get('user', 'root')] %}
{%- if pm2.home_dir is defined %}{%- do startup_cmd.append("--hp=" ~ pm2.home_dir) %}{%- endif %}
{%- if pm2.startup_platform is defined %}{%- do startup_cmd.append(pm2.startup_platform) %}{%- endif %}

pm2_startup_script:
  cmd.run:
    - name: {{ startup_cmd|join(" ") }}