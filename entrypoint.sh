#!/usr/bin/env bash

# Check if database is ready
while ! pg_isready -q -h ${POSTGRES_HOST:-postgres} -p ${POSTGRES_PORT:-5432} -U ${POSTGRES_USER:-postgres}; do
    echo "Waiting for database connection..."
    sleep 1
done

if [ -z "${SKIP_MIGRATION}" ]; then
    python manage.py migrate --noinput
fi

if [ -z "${SKIP_COLLECTSTATIC}" ]; then
    python manage.py collectstatic --noinput
fi

if [ -z "${USE_WSGI}" ]; then
    exec python manage.py runserver 0.0.0.0:${PORT:-8000}
else
    exec gunicorn --bind 0.0.0.0:${PORT:-8000} hello_world.wsgi:application
fi
