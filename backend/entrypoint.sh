#!/bin/sh
set -eu
python manage.py migrate --noinput
python manage.py seed_content
if [ "$#" -gt 0 ]; then
  exec "$@"
fi
if [ "${DJANGO_DEBUG:-0}" = "0" ]; then
  python manage.py collectstatic --noinput
  exec gunicorn config.wsgi:application --bind 0.0.0.0:8000 --workers 3 --access-logfile -
fi
exec python manage.py runserver 0.0.0.0:8000
