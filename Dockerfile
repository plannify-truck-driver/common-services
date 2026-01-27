FROM alpine:3.23 AS builder

RUN apk add --no-cache cargo rust musl-dev
RUN cargo install sqlx-cli --version 0.8.6 --no-default-features --features postgres

FROM alpine:3.23

COPY database-migrations /database-migrations
COPY --from=builder /root/.cargo/bin/sqlx /usr/local/bin/sqlx

RUN apk add --no-cache postgresql-client libpq libgcc

RUN addgroup -g 1000 appgroup && adduser -D -u 1000 -G appgroup appuser

COPY --chown=appuser:appgroup entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN chown -R appuser:appgroup /database-migrations

USER appuser

ENTRYPOINT ["/entrypoint.sh"]
