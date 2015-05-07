
description: Production environment

smtp:
  host:
  port:
  user:
  password:
  use_tls:
  from_email:


mezzapp:
  django_debug: True
  #django_debug: False


  aws:
    access_id: {{ grains.get('aws_access_id')}}
    secret_key: {{ grains.get('aws_secret_key')}}

  media_files:
    s3_bucket: prod-mezzapp-media
    s3_bucket_url: http://prod-mezzapp-media.s3-website-us-west-2.amazonaws.com/

  database:
    default:
      dbname: mezzapp
      username: mezzapp
      password: mezzapp
      host: mezzapp.cvuqkzoz4dvj.us-west-2.rds.amazonaws.com
      engine: django.db.backends.postgresql_psycopg2

