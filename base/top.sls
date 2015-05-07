base:
  '*':
    - users
    - common

environments:
  'roles:mezzapp':
    - match: grain
    - apache
    - mezzapp
    - mezzapp.supervisor
    - rsyslog

  'roles:loadbalancer':
    - match: grain
    - haproxy
    - rsyslog

  'roles:jenkins':
    - match: grain
    - jenkins
    - map

