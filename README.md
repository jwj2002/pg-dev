📦 pg-dev — Local Postgres + pgAdmin (Docker, WSL-friendly)

This project provides a ready-to-use PostgreSQL 16 development environment with pgAdmin 4 for database management.
It is designed to work seamlessly on Windows 11 + WSL2, Linux, or macOS.

🚀 Features

PostgreSQL 16 with persistent storage (pg_data)

pgAdmin 4 web UI for managing databases (pgadmin_data)

Configurable via .env

Optional initdb/ folder for seed SQL (executed on first startup)

WSL2-friendly (binds to 127.0.0.1 only)

🛠️ Prerequisites

Docker Desktop
 with WSL2 backend enabled (on Windows)

Git

psql client
 (optional, for CLI access)

⚙️ Setup
1. Clone the repository
git clone git@github.com:jwj2002/pg-dev.git
cd pg-dev

2. Configure environment variables

Copy the example file and adjust as needed:

cp .env.example .env


Default values in .env:

POSTGRES_USER=appuser
POSTGRES_PASSWORD=changeme
POSTGRES_DB=appdb
POSTGRES_PORT=5432

PGADMIN_EMAIL=admin@example.com
PGADMIN_PASSWORD=supersecret
PGADMIN_PORT=5050

TZ=America/Los_Angeles
DATABASE_URL=postgresql+psycopg://appuser:changeme@localhost:5432/appdb

3. Start the stack
docker compose up -d

4. Verify services
docker compose ps


You should see both pg-dev (Postgres) and pgadmin running.

💻 Usage
pgAdmin (Web UI)

Open http://localhost:5050

Login with the email/password from .env (PGADMIN_EMAIL / PGADMIN_PASSWORD)

Register a new server:

Name: Local Dev

Host name/address:

If pgAdmin is running in Docker (default here): db

If using pgAdmin desktop: localhost

Port: 5432

Username: appuser

Password: changeme

Maintenance database: postgres

psql (CLI)
psql "postgresql://appuser:changeme@localhost:5432/appdb"


Run commands:

\l          -- list databases
\c app_test -- connect to database
\dt         -- list tables

Seeding databases

Place .sql files in initdb/ — these will run once on first initialization of the data volume.
If you need to re-run them, either:

Run them manually:

docker exec -i pg-dev psql -U appuser -d postgres < initdb/init.sql


Or reset the volume:

docker compose down -v && docker compose up -d

🔄 Common Commands
# Start services
docker compose up -d

# Stop services
docker compose stop

# Remove containers (keep volumes)
docker compose down

# Full reset (remove containers + volumes)
docker compose down -v

# Logs
docker logs -f pg-dev

# psql inside container
docker exec -it pg-dev psql -U appuser -d appdb

🗄️ Backup & Restore

Backup:

docker exec -t pg-dev pg_dump -U appuser -d appdb -Fc > backup_$(date +%F).dump


Restore:

pg_restore -h localhost -U appuser -d appdb -c backup_YYYY-MM-DD.dump

👥 Recommended Workflow

Keep your real .env out of Git. Only commit .env.example.

For application projects, reference the DATABASE_URL from .env.

Use pgAdmin for schema management, and psql for scripting/tests.

For real schema changes: consider using Alembic
 (Python) or Flyway
.

⚠️ Notes

Postgres data persists in Docker volumes (pg_data).

pgAdmin settings persist in pgadmin_data.

To “wipe everything” for a clean start, use docker compose down -v.

The version: field is deprecated in Compose v2 — safe to remove from your YAML.

✅ This gives you a reproducible local Postgres environment with a nice GUI, CLI, and clear reset/backup paths.
