pm2:
  enabled: True
  user: root
  home_dir: /srv/pm2
  apps:
    my_app:
      enabled: True
      restart: True
      main_file: /srv/node/myapp/index.js
      cwd: /srv/node/myapp
      user: node
      args:
        - "--some=arg"
      env:
        MY_VAR: value
      instances: 1
      log_file: /var/log/myapp.log
      output_log_file: /var/log/myapp_output.log
      error_log_file: /var/log/myapp_error.log
      pid_file: /var/run/myapp.pid
      interpreter: node
      no_daemon: False
      merge_logs: True
      watch: True
      ignore_watch: "node_modules"
      node_args:
        - "--debug=7001"
    another_app:
      enabled: False
      main_file: /srv/another_app
      cwd: /srv/another_app
      interpreter: python