# lms-membership-db

> Membership bounded context: database

Part of the **LMS Library** distributed system — team `lms-library`, Grupo 2.
Governance and documentation live in [`library-docs`](https://github.com/code-corhuila/library-docs).

## Migration scope

**Comes from** `lms-library` → the `membership-db` and `membership-migrate` service blocks of
`docker-compose.yml`, the `membership-db-data` volume, and the DDL currently sitting in
`membership-service/migrations/`.

**This repository owns the whole database structure** — image, configuration, volume, healthcheck,
schema, seeds and migrations. `lms-membership-api` only consumes it; it no longer carries the schema.

Database: `membership_db`.

## Structure

Follows `rules/2-anexos/A-db-postgres.md` (the course's own repository norm), with **Liquibase**
as the migration tool (`ADR-010-liquibase-for-database-migrations.md`) — replacing the
`golang-migrate` this repo used before that norm was available here.

```
01_ddl/          → schema DDL: extensions, schema, tables, indexes (numbered = execution order)
02_dml/          → seeds/updates/deletes/upserts/patches — empty today, no seed data for students
03_dcl/          → roles (membership_reader/membership_writer, NOLOGIN) and their grants
04_tcl/          → transaction blocks, manual recoveries, release tags — empty today
05_rollbacks/    → mirrors 01_ddl/02_dml/03_dcl, one .rollback.sql per .sql that reverts it
changelog/
└── changelog-master.yaml → the single Liquibase entry point
deploy/
├── compose.yml            → this domain's own Postgres instance + the Liquibase executor
└── liquibase.properties   → changelog path, JDBC URL, credentials from environment
```

The `student` table (singular, per the norm's rule 1) lives in schema `membership`, never
`public`. Every text column is `text` with an explicit `CHECK` on length, not `VARCHAR(n)`.

## Verifying the migrations locally

```bash
docker compose -f deploy/compose.yml up --build
```

Or by hand with the Liquibase CLI/image directly, per `rules/2-anexos/A-db-postgres.md`'s
reconstruction check (also what `.github/workflows/db-ci.yml` runs on every PR):
`update` → `update` again (must apply zero changesets) → `rollback-count 999` → `update` again.

The full map lives in `library-docs`.

---

## Branching

Three permanent branches. **None of them accepts a direct commit** — you enter through a child
branch and leave through a Pull Request.

```
develop  <--PR--  feat/... fix/... chore/...
qa       <--PR--  qa/...
main     <--PR--  release/...  hotfix/...
```

Promotion happens **by re-application** (`git cherry-pick -x`), never by merging one permanent
branch into another: `merge develop -> qa` and `merge qa -> main` do not exist in this model.

`main` requires **1 approval from `ariel5253`**. On `develop` and `qa` the team sets its own review
rule.

Full policy: `00-governance/branching-policy.md` in `library-docs`.
