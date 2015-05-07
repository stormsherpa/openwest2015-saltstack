include:
{% if grains.get('environment', None) %}
  - environment.{{grains['environment']}}:
      key: environment
{% else %}
{% endif %}

mine_functions:
  network.ipaddrs: [eth0]
  pillar.item:
    - environment
