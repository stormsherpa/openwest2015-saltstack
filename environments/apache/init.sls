
apache2:
  pkg.installed: []
  service:
    - running
    - require:
      - pkg: apache2
    - enable: True
    - restart: reload
    - watch:
      - file: /etc/apache2/ports.conf
      - file: /etc/apache2/sites-available/static_assets.conf
      - file: /etc/apache2/mods-enabled/rewrite.load
      - file: /etc/apache2/mods-enabled/proxy.load
      - file: /etc/apache2/mods-enabled/proxy.conf
      - file: /etc/apache2/mods-enabled/proxy_http.load

/etc/apache2/mods-enabled/rewrite.load:
  file.symlink:
    - target: ../mods-available/rewrite.load
/etc/apache2/mods-enabled/proxy.load:
  file.symlink:
    - target: ../mods-available/proxy.load
/etc/apache2/mods-enabled/proxy.conf:
  file.symlink:
    - target: ../mods-available/proxy.conf
/etc/apache2/mods-enabled/proxy_http.load:
  file.symlink:
    - target: ../mods-available/proxy_http.load

/etc/apache2/ports.conf:
  file.managed:
    - source: salt://apache/ports.conf
    - mode: 644

/etc/apache2/sites-available/static_assets.conf:
  file.managed:
    - source: salt://apache/static_assets.conf
    - mode: 644
    - template: jinja

/etc/apache2/sites-enabled/static_assets.conf:
  file.symlink:
    - target: ../sites-available/static_assets.conf
