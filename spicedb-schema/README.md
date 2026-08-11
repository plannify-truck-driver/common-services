# SpiceDB schema — admin API authorization

Flat/global RBAC for the Plannify admin API. Only `employee` subjects call this
API. See `schema.zed` for the full model and the header comment for the
mapping from the previous SQL-only RBAC tables.

## Conventions

- Every resource type (`driver`, `workday`, `workday_document`,
  `driver_suspension`, `driver_mail`, `driver_mail_attachment`,
  `driver_information`, `employee`) is checked against a single fixed object
  id: `global`. There is no per-record scoping — permission on `driver:global`
  applies to every driver record.
- All grants (role assignment or direct derogation) are time-bound and require
  a `within_validity_period` caveat context: `{start_at, end_at}` as RFC 3339
  timestamps. If a grant has no expiration, pass a far-future sentinel for
  `end_at` (e.g. `9999-12-31T23:59:59Z`) — this repo's caveat always requires
  both bounds to keep the CEL expression simple.

## Loading the schema

```bash
zed context set plannify localhost:50051 foobar --insecure
zed schema write spicedb-schema/schema.zed
```

## Writing relationships

Bind a role to a permission (static, equivalent to the old
`link_employee_authorization` — no caveat needed):

```bash
zed relationship create driver:global updater role:dispatcher#assignee
```

Assign an employee to a role for a period (equivalent to
`employee_accreditation_authorizations`):

```bash
zed relationship create role:dispatcher assignee employee:123 \
  --caveat 'within_validity_period:{"start_at":"2026-08-11T00:00:00Z","end_at":"9999-12-31T23:59:59Z"}'
```

Grant a one-off derogation directly to an employee (equivalent to
`employee_authorization_derogations`):

```bash
zed relationship create driver:global updater employee:123 \
  --caveat 'within_validity_period:{"start_at":"2026-08-11T00:00:00Z","end_at":"2026-09-01T00:00:00Z"}'
```

## Checking permissions

```bash
zed permission check driver:global update employee:123 \
  --caveat-context '{"current_time":"2026-08-11T10:00:00Z"}'
```

Your API should perform this check (via the SpiceDB gRPC/HTTP client, not the
CLI) on every write/read path, passing `current_time` as the server's current
time.

## Notes / follow-ups

- No role hierarchy is implied (a "super_admin" role does not automatically
  inherit other roles' permissions) — this matches the explicit
  `link_employee_authorization` binding in the previous model. If you want a
  bypass-all super-admin, that would need to be added explicitly to each
  `permission` expression (e.g. `permission update = updater + superadmin`)
  and is intentionally left out for now.
- The old SQL RBAC tables (`employee_authorization_categories`,
  `employee_authorizations`, `employee_authorization_types`,
  `link_employee_authorization`, `employee_accreditation_authorizations`,
  `employee_authorization_derogations`) become redundant once the API reads
  from SpiceDB. `employees` and `employee_levels` can stay as reference data
  (display names, etc.) if useful, but should no longer be the enforcement
  path.
