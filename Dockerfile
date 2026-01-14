FROM alpine:3.23 AS builder

RUN apk add --no-cache cargo rust musl-dev
RUN cargo install sqlx-cli --no-default-features --features postgres

FROM alpine:3.23

COPY database-migrations /database-migrations
COPY --from=builder /root/.cargo/bin/sqlx /usr/local/bin/sqlx

RUN apk add --no-cache postgresql-client libpq libgcc

RUN cat > /entrypoint.sh << 'EOF'
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
EOF

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
