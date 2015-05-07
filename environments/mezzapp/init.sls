
mezzapp_deps:
  pkg.installed:
    - pkgs:
      - python-virtualenv
      - python-pip
      - python-dev
      - build-essential
      - supervisor
      - libpq-dev


/home/mezzapp/logs:
  file.directory:
    - dir_mode: 755
    - user: mezzapp
    - group: mezzapp

/home/mezzapp/scripts:
  file.directory:
    - dir_mode: 755
    - user: mezzapp
    - group: mezzapp

/home/mezzapp/config:
  file.directory:
    - dir_mode: 755
    - user: mezzapp
    - group: mezzapp

/home/mezzapp/static_root:
  file.directory:
    - dir_mode: 755
    - user: mezzapp
    - group: mezzapp

/home/mezzapp/config/local_settings.py:
  file.managed:
    - source: salt://mezzapp/local_settings.py
    - template: jinja
    - mode: 640
    - user: mezzapp
    - group: mezzapp

/home/mezzapp/config/local_settings.pyc:
  file.absent: []

/home/mezzapp/config/mezzapp_wsgi.py:
  file.managed:
    - source: salt://mezzapp/mezzapp_wsgi.py
    - template: jinja
    - mode: 640
    - user: mezzapp
    - group: mezzapp

/home/mezzapp/config/mezzapp_wsgi.pyc:
  file.absent: []


/home/mezzapp/scripts/mezzapp_manage.sh:
  file.managed:
    - source: salt://mezzapp/mezzapp_manage.sh
    - template: jinja
    - mode: 750
    - user: mezzapp
    - group: mezzapp

