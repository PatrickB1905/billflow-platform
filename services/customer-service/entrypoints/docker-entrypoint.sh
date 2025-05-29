#!/usr/bin/env bash
set -e

# Wait for Postgres to be ready
until pg_isready -h "$DB_HOST" -U "$DB_USERNAME"; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

# Create the database and run migrations
bundle exec rails db:create db:migrate

# Execute the container’s main process (what’s in CMD)
exec "$@"