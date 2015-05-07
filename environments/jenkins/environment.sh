
{% set mezzapp_hosts = salt['mine.get']('G@environment:{} and G@roles:mezzapp'.format(env_name), 'pillar.item', expr_form='compound').items() %}
# env_name: {{env_name}}

MEZZAPP_HOSTS="{% for h in mezzapp_hosts %}{{h[0]}} {% endfor %}"

