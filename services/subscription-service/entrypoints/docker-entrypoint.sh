#!/usr/bin/env bash
set -e

# 1) Wait for Postgres to be ready
until pg_isready -h "$DB_HOST" -p "${DB_PORT:-5432}" -U "$DB_USERNAME" >/dev/null 2>&1; do
  >&2 echo "Postgres is unavailable — sleeping"
  sleep 1
done

# 2) Create & migrate the database
bundle exec rails db:create db:migrate

# 3) Seed demo subscription plan & default admin user data
bundle exec rails db:seed

# 4) Generate the OpenAPI spec (swagger/v1/swagger.yaml) from your rswag specs
bundle exec rake rswag:specs:swaggerize

# 5) Launch the main process (rails server by default)
exec "$@"
