===
PM2
===

NodeJS Process Manager PM2 (http://pm2.keymetrics.io/)

Requires NodeJS to be installed on host machine.

Sample pillars
==============

Full-featured example:

.. code-block:: yaml

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
          create_cwd_dir: True
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

Read more
=========

* http://pm2.keymetrics.io/
* https://github.com/jirihybek/salt-formula-pm2

License
=======

Formula derived from https://github.com/salt-formulas/salt-formula-java

Apache 2 license

Copyright (C) 2017 Jiri Hybek <jiri@hybek.cz>

Copyright (C) 2014-2015 tcp cloud (original salt-formula-java)