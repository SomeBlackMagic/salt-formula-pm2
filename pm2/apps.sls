{%- from "pm2/map.jinja" import pm2 with context %}

{%- if pm2.apps is defined %}

  {%- for app_name, app in pm2.apps.iteritems() %}

    {#- If enabled #}
    {%- if app.enabled %}

      {%- set start_cmd = [] %}

      {#- Add env variables #}
      {%- if app.env is defined %}
        {%- for env_name, env_value in app.env.iteritems() %}
          {%- do start_cmd.append(env_name ~ "=\"" ~ env_value ~ "\"") %}
        {%- endfor %}
      {%- endif %}

      {#- Start command #}
      {%- do start_cmd.append("pm2 start " ~ app.main_file ~ " --name=" ~ app_name) %}

      {#- Add options #}
      {%- if app.user is defined %}{%- do start_cmd.append("--user=" ~ app.user) %}{%- endif %}
      {%- if app.instances is defined %}{%- do start_cmd.append("--instances " ~ app.instances) %}{%- endif %}
      {%- if app.log_file is defined %}{%- do start_cmd.append("--log=" ~ app.log_file) %}{%- endif %}
      {%- if app.output_log_file is defined %}{%- do start_cmd.append("--output=" ~ app.output_log_file) %}{%- endif %}
      {%- if app.error_log_file is defined %}{%- do start_cmd.append("--error=" ~ app.error_log_file) %}{%- endif %}
      {%- if app.pid_file is defined %}{%- do start_cmd.append("--pid=" ~ app.pid_file) %}{%- endif %}
      {%- if app.interpreter is defined %}{%- do start_cmd.append("--interpreter=" ~ app.interpreter) %}{%- endif %}
      {%- if app.no_daemon is defined and app.no_daemon %}{%- do start_cmd.append("--no-daemon") %}{%- endif %}
      {%- if app.merge_logs is defined and app.merge_logs %}{%- do start_cmd.append("--merge-logs") %}{%- endif %}
      {%- if app.watch is defined and app.watch %}{%- do start_cmd.append("--watch") %}{%- endif %}
      {%- if app.ignore_watch is defined %}{%- do start_cmd.append("--ignore-watch=\"" ~ app.ignore_watch ~ "\"") %}{%- endif %}
      {%- if app.node_args is defined %}{%- do start_cmd.append("--node-args=\"" ~ app.node_args|join(" ") ~ "\"") %}{%- endif %}

      {#- Add arguments #}
      {%- if app.args is defined %}{%- do start_cmd.append("-- " ~ app.args|join(" ")) %}{%- endif %}

      {#- Ensure CWD dir #}
      {%- if app.get('create_cwd_dir', True) %}

{{ app.cwd }}:
  file.directory:
  - user: {{ app.get('user', pm2.get('user', 'root')) }}
  - mode: 755
  - makedirs: True

      {%- endif %}

      {#- Delete if restart #}
      {%- if app.restart is defined and app.restart %}

pm2_restart_delete_{{ app_name }}:
  cmd.run:
    - name: pm2 delete {{ app_name }}
    - runas: {{ pm2.get('user', 'root') }}
    - onlyif: pm2 describe {{ app_name }}

      {%- endif %}

      {#- Start app #}
pm2_start_{{ app_name }}:
  cmd.run:
    - name: {{ start_cmd|join(" ") }}
    - cwd: {{ app.cwd }}
    - runas: {{ pm2.get('user', 'root') }}
    - unless: pm2 describe {{ app_name }}

    {#- If disabled #}
    {%- else %}

pm2_delete_{{ app_name }}:
  cmd.run:
    - name: pm2 delete {{ app_name }}
    - runas: {{ pm2.get('user', 'root') }}
    - onlyif: pm2 describe {{ app_name }}

    {%- endif %}

  {%- endfor %}

{%- endif %}