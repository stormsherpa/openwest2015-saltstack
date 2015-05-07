base-packages:
  pkg.installed:
    - pkgs:
      - python-dev
      - python3-dev
      - mailutils
      - python-pip
      - python3-pip
      - python-virtualenv
      - htop
      - git
      - supervisor
      - ntp
      - postgresql-client-9.3

#  Having suffered the consequences of an automatic upgrade of salt I learned my lesson...
#salt:
#  pkg.latest:
#    - pkgs:
#      - salt-minion

/etc/screenrc:
  file.managed:
    - source: salt://common/screenrc
    - mode: 644

/etc/hosts:
  file.managed:
    - source: salt://common/hosts
    - mode: 644

/etc/ssh/ssh_config:
  file.managed:
    - source: salt://common/ssh_config


openssh-server:
  pkg.installed:
    - pkgs:
      - openssh-server
  service.running:
    - name: ssh
    - enable: true
    - require:
      - pkg: openssh-server
    - watch:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://common/sshd_config
    - require:
      - pkg: openssh-server

/etc/sudoers.d/sudo_agent:
  file.managed:
    - source: salt://common/sudo_agent
    - mode: 440

salt-mine:
  file:
    - managed
    - name: /etc/salt/minion.d/mine.conf
    - source: salt://common/mine.conf
    - mode: 644

restart-salt:
  cmd.wait:
    - name: echo "service salt-minion restart" | at now +3 min
    - watch:
      - file: salt-mine

/etc/security/limits.d/openfiles.conf:
  file.managed:
    - source: salt://common/limits-openfiles.conf
    - mode: 644

