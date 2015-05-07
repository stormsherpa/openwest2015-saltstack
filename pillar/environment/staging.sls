
description: Staging environment

smtp:
  host: smtp.gmail.com
  port: 587
  user:
  password:
  use_tls: True
  from_email:


mezzapp:
  django_debug: True

  database:
    default:
      dbname: mezzapp
      username: mezzapp
      password: mezzapp
      host: localhost
      engine: django.db.backends.postgresql_psycopg2

