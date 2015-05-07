#!/bin/bash

export MEZZAPP_LOG_LOCATION=/home/mezzapp/logs
export DJANGO_SETTINGS_MODULE=local_settings
export PYTHONPATH=/home/mezzapp/config

/home/mezzapp/vmezzapp/bin/django-admin.py $@

