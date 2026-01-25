FROM alpine:3.23 AS builder

RUN apk add --no-cache cargo rust musl-dev
RUN cargo install sqlx-cli --version 0.8.6 --no-default-features --features postgres

FROM alpine:3.23

COPY database-migrations /database-migrations
COPY --from=builder /root/.cargo/bin/sqlx /usr/local/bin/sqlx

RUN apk add --no-cache postgresql-client libpq libgcc

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
