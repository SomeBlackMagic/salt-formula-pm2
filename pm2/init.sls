
{%- if pillar.pm2 is defined and pillar.pm2.enabled %}
include:
- pm2.install
- pm2.apps
{%- endif %}
