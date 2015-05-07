{% for groupname, group in pillar.get('groups', {}).items() %}
{{groupname}}:
  group.present:
    - gid: {{group.gid}}

{% endfor %}

{% if grains.get('os_family') == "RedHat" %}
sudo:
  group.present:
    - gid: 299
{% endif %}

{% for username, user in pillar.get('users', {}).items() %}
{% set homedir = user.get('home_dir', '/home/%s' % (username)) %}
{{username}}:
  group.present:
    - gid: {{user.uid}}

  user.present:
    - home: {{homedir}}
    - shell: /bin/bash
    - fullname: {{user.get('fullname', username)}}
    - password: '{{user.get('password', '!!')}}'
    - enforce_password: False
{% if user.get('uid', False) %}
    - uid: {{user.uid}}
    - gid: {{user.uid}}
{% endif %}
{% if user.get('groups', False) %}
    - groups:
{% for group in user.get('groups', []) %}
      - {{group}}
{% endfor %}
{% endif %}

{% if username in ['jenkins'] %}
{{homedir}}:
  file.directory:
    - mode: 755
    - user: {{username}}
    - group: {{username}}
    - require:
      - user: {{username}}
{% endif %}

{{homedir}}/.ssh:
  file.directory:
    - mode: 700
    - user: {{username}}
    - group: {{username}}
    - require:
      - user: {{username}}

{% if user.get('nosshkeys', False) %}
{{username}}_authorized_keys:
  file:
    - absent
    - name: {{homedir}}/.ssh/authorized_keys

{% else %}
{{username}}_authorized_keys:
  ssh_auth:
    - present
    - user: {{username}}
    - source: salt://users/id_rsa.pub.{{username}}
    - require:
      - file: {{homedir}}/.ssh
{% endif %}
{% endfor %}

{% for user in pillar.get('oldusers', "").split() %}
{{ user }}:
  user.absent
{% endfor %}

/etc/sudoers:
  file.managed:
    - source: salt://users/sudoers
    - template: jinja
    - mode: 440
    - user: root
    - group: root

