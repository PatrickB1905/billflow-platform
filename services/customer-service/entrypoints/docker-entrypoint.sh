#!/usr/bin/env bash
set -e

# 1) Wait for Postgres to be ready
until pg_isready -h "$DB_HOST" -p "${DB_PORT:-5432}" -U "$DB_USERNAME" >/dev/null 2>&1; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

# 2) Create the database and run migrations
bundle exec rails db:create db:migrate

# 3) Build the Swagger YAML from your specs
bundle exec rake rswag:specs:swaggerize

# 4) Execute the container’s main process (what’s in CMD)
exec "$@"
