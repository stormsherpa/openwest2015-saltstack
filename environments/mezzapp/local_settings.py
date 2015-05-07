{% set env_base = pillar.get('environment', {}) %}
{% set env = env_base.get('mezzapp', {}) %}
{% set env_name = salt['grains.get']('environment') %}
{% set fqdn = salt['grains.get']('fqdn') %}

from mezzapp.settings import *

{% set aws = env.get('aws', {}) %}
AWS_ACCESS_KEY_ID="{{aws.get('access_id')}}"
AWS_SECRET_ACCESS_KEY="{{aws.get('secret_key')}}"

ALLOWED_HOSTS = "{{env.get('allowed_hosts', '*')}}"

SECRET_KEY = "1b26f625-b5fc-4e00-a4f6-e83b9ce01e65f61838f6-ab05-4bb2-a6e0-e3258c0aab0917064ab6-b3dd-477f-9448-52ea89d292e4"
NEVERCACHE_KEY = "93e0b905-dd39-4c4f-b429-3905d2c260fbf142e887-bd41-4cb3-b27c-03a7d7636f5ca007855b-7017-47ca-b245-c29655814501"


### Media file settings
MEDIA_URL="/media/"
{% if env.get('media_files', {}).get('filesystem_root', False) %}
DEFAULT_FILE_STORAGE = THUMBNAIL_DEFAULT_STORAGE = "django.core.files.storage.FileSystemStorage"
MEDIA_ROOT="{{env.get('media_files', {})['filesystem_root']}}"

{% elif env.get('media_files', {}).get('s3_bucket', False) %}
{% set media_files = env.get('media_files', {}) %}
DEFAULT_FILE_STORAGE='storages.backends.s3boto.S3BotoStorage'
AWS_STORAGE_BUCKET_NAME="{{media_files.get('s3_bucket')}}"
AWS_QUERYSTRING_AUTH=False

{% endif %}


### Static files settings
STATICFILES_STORAGE='django.contrib.staticfiles.storage.StaticFilesStorage'
STATIC_ROOT="/home/mezzapp/static_root/static/"


### Debug
DEBUG={{env.get('django_debug', 'False')}}


### Database config
{% if env.get('database', False) %}
  {% set default_db = env['database'].get('default', {}) %}
DATABASES = {
    'default': {
        'NAME': "{{default_db.get('dbname', 'mezzappdefaultdb')}}",
        'ENGINE': "{{default_db.get('engine', 'django.db.backends.postgresql_psycopg2')}}",
        'USER': "{{default_db.get('username', 'mezzappdefaultuser')}}",
        'HOST': "{{default_db.get('host', '')}}",
        'PASSWORD': "{{default_db.get('password', '')}}",
    },
}
{% endif %}


### SMTP Config
{% set smtp = env_base.get('smtp') %}
{% if smtp %}
DEFAULT_FROM_EMAIL = "{{smtp.get('from_email')}}"
EMAIL_HOST = "{{smtp.get('host')}}"
EMAIL_PORT = {{smtp.get('port')}}
EMAIL_HOST_USER = "{{smtp.get('user')}}"
EMAIL_HOST_PASSWORD = "{{smtp.get('password')}}"
EMAIL_USE_TLS = {{smtp.get('use_tls', False)}}
{% else %}
# No SMTP settings provided
{% endif %}




