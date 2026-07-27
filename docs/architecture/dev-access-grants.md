# DEV Access Grants

## Purpose

This step grants initial access to `NACHO_DEV_DB` using least privilege.

Snowflake object access is hierarchical. A role needs `USAGE` on each container in the path before it can access objects inside the container:

```text
database -> schema -> table/view/stage/file format
```

For example, a role cannot query `NACHO_DEV_DB.GOLD.SALES_FACT` unless it has:

- `USAGE` on database `NACHO_DEV_DB`
- `USAGE` on schema `NACHO_DEV_DB.GOLD`
- `SELECT` on the table or view

## Grant decisions

| Role | Access | Reason |
|---|---|---|
| `NACHO_DATA_ENGINEER` | `USAGE` on all DEV schemas | Engineers build and validate ingestion and transformation logic across layers. |
| `NACHO_DATA_ENGINEER` | `CREATE TABLE`, `CREATE VIEW` on all DEV schemas | DEV needs iterative object creation during engineering. |
| `NACHO_DATA_ENGINEER` | `CREATE STAGE`, `CREATE FILE FORMAT` on `BRONZE` | Ingestion-specific objects belong in the raw landing layer. |
| `NACHO_DATA_ANALYST` | `USAGE` on database and `GOLD` schema | Analysts should consume curated products, not raw or intermediate layers. |

## Why not grant SELECT yet?

No tables or views exist yet. We will introduce `SELECT` grants when we create publishable data objects.

This keeps the learning sequence clear:

1. Grant access to containers.
2. Create data objects.
3. Grant access to data objects.
4. Add future grants only when we understand the operational behavior.

## Enterprise recommendation

Use functional roles and grant privileges to roles, not directly to users. Keep raw and intermediate layers restricted, and expose curated data through `GOLD` tables, views, or secure views.

## Common production mistake

Granting broad privileges such as `OWNERSHIP`, `ALL PRIVILEGES`, or account-level permissions to engineering and analyst roles. This makes access reviews difficult and can allow accidental object replacement or privilege escalation.
