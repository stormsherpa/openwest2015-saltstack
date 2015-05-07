
mezzapp_sup:
  file.managed:
    - name: /etc/supervisor/conf.d/mezzapp_sup.conf
    - source: salt://mezzapp/mezzapp_sup.conf
    - mode: 644

mezzapp_user_sup:
  file.managed:
    - name: /home/mezzapp/supervisord.conf
    - source: salt://user_sup.conf
    - mode: 644

/home/mezzapp/supervisor.d:
  file.directory:
    - dir_mode: 755
    - user: mezzapp
    - group: mezzapp

/home/mezzapp/supervisor.d/mezzapp.conf:
  file.managed:
    - source: salt://mezzapp/mezzapp.conf
    - template: jinja
    - mode: 644

mezzapp_sup_reload:
  cmd.run:
    - name: supervisorctl update
    - prereq:
      - file: mezzapp_sup
      - file: mezzapp_user_sup

