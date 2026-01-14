# Common Services

This directory contains common services used across multiple Plannify projects.

## Usage

```bash
docker compose up -d
```

## Services

### PostgreSQL Database

#### Add migrations

```bash
sqlx migrate add <migration-name> --source database-migrations
```

#### Apply migrations

```bash
sqlx migrate run --source database-migrations --database-url postgresql://plannify_user:plannify_password@localhost:5432/plannify_db
```

#### Running database migrations

If using the common-services Docker image with migrations, set the `DATABASE_URL` environment variable:

```bash
docker run -e DATABASE_URL=postgresql://plannify_user:plannify_password@host.docker.internal:5432/plannify_db cs:latest
```

### Garage

#### Configuration

```bash
./configurations/setup-garage.sh
```
