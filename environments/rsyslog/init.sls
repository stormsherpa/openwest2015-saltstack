
rsyslog:
  pkg.installed: []
  service:
    - running
    - require:
      - pkg: rsyslog
    - enable: True
    - watch:
      - file: /etc/rsyslog.d/40-haproxy.conf
      - file: /etc/rsyslog.d/40-mezzapp.conf
      - file: /etc/rsyslog.d/41-apache.conf
      - file: /etc/rsyslog.d/10-common.conf

/var/log/myapps:
  file.directory:
    - dir_mode: 755
    - user: syslog
    - group: adm

/etc/rsyslog.d/10-common.conf:
  file.managed:
    - source: salt://rsyslog/common.conf
    - template: jinja
    - mode: 644

/etc/rsyslog.d/41-apache.conf:
  file.managed:
    - source: salt://rsyslog/apache.conf
    - template: jinja
    - mode: 644

/etc/rsyslog.d/40-mezzapp.conf:
  file.managed:
    - source: salt://rsyslog/mezzapp.conf
    - template: jinja
    - mode: 644

{% if 'loadbalancer' in grains.get('roles', []) %}

/etc/rsyslog.d/40-haproxy.conf:
  file.managed:
    - source: salt://rsyslog/haproxy.conf
    - template: jinja
    - mode: 644

{% else %}

/etc/rsyslog.d/40-haproxy.conf:
  file.absent: []

{% endif %}

