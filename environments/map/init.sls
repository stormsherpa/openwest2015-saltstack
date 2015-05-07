
/var/www/map:
  file.directory:
    - dir_mode: 755
    - makedirs: True

map_boostrap:
  archive:
    - extracted
    - name: /var/www/map/
    - source: salt://map/bootstrap-3.3.1-dist.zip
    - archive_format: zip
    - if_missing: /var/www/map/dist/

/var/www/map/index.html:
  file.managed:
    - source: salt://map/index.html
    - template: jinja
    - mode: 644

{% for env in pillar.get('environment_list', []) %}
/var/www/map/{{env}}.html:
  file.managed:
    - source: salt://map/environment.html
    - template: jinja
    - context:
        env_name: {{env}}
    - mode: 644

{% endfor %}

