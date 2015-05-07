

haproxy:
  pkg.installed: []
  service:
    - running
    - require:
      - pkg: haproxy
    - enable: True
    - restart: reload
    - watch:
      - file: /etc/haproxy/haproxy.cfg
      - file: /etc/default/haproxy
  file.managed:
    - name: /etc/default/haproxy
    - source: salt://haproxy/haproxy.default
    - mode: 644

/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://haproxy/haproxy.cfg
    - template: jinja
    - mode: 644

/etc/pound/pound.cfg:
  file.managed:
    - source: salt://haproxy/pound.cfg
    - template: jinja
    - mode: 644

/etc/ssl/snakeoil-bundle.pem:
  file.managed:
    - source: salt://haproxy/snakeoil-bundle.pem
    - mode: 644

pound:
  pkg.installed: []
  service:
    - running
    - require:
      - pkg: pound
      - file: /etc/ssl/snakeoil-bundle.pem
      - file: /etc/default/pound
      - file: /etc/pound/pound.cfg
    - enable: True
    - restart: True
    - watch:
      - file: /etc/ssl/snakeoil-bundle.pem
  file.managed:
    - name: /etc/default/pound
    - source: salt://haproxy/pound.default
    - mode: 644

