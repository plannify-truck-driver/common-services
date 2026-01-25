#!/bin/sh
set -e

if [ -z "$DATABASE_URL" ]; then
  echo "ERROR: DATABASE_URL environment variable is not set"
  exit 1
fi

echo "Running database migrations..."
sqlx migrate run --source /database-migrations --database-url "$DATABASE_URL"
echo "Migrations completed successfully"

exec "$@"