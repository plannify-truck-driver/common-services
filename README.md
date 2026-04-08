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
docker run -e DATABASE_URL=postgresql://plannify_user:plannify_password@localhost:5432/plannify_db ghcr.io/plannify-truck-driver/common-services:latest
```

### Garage

When the docker compose starts, the garage service will initialize by the `garage-init.sh` script. This script will create a bucket and a key in the S3-compatible storage service for storing documents data.

The web interface of the garage service is available at `http://localhost:3909` and the credentials for the S3-compatible storage service are available in the `garage.env` file at the root of the project.
