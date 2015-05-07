

/var/lib/jenkins/environments.properties:
  file.managed:
    - source: salt://jenkins/environments.properties
    - template: jinja
    - mode: 644
    - user: jenkins
    - group: jenkins

/var/lib/jenkins/environments:
  file.directory:
    - dir_mode: 755
    - user: jenkins
    - group: jenkins

/var/lib/jenkins/scripts:
  file.recurse:
    - source: salt://jenkins/scripts
    - file_mode: 755
    - dir_mode: 755
    - user: jenkins
    - group: jenkins

{% set env_list = salt['pillar.item']('environment_list')['environment_list'] %}
{% for env_name in env_list %}
/var/lib/jenkins/environments/{{env_name}}.sh:
  file.managed:
    - source: salt://jenkins/environment.sh
    - template: jinja
    - context:
        env_name: {{env_name}}
    - mode: 644
    - user: jenkins
    - group: jenkins


{% endfor %}
