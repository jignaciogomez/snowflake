# Identity and Access Model

## Scope of Step 2.2

This document defines the initial account-role hierarchy for the `NACHO_` Snowflake project. It intentionally creates no users, databases, warehouses, data objects, or object privileges.

## Design decisions

Snowflake uses role-based access control (RBAC). A role can be granted to another role; the receiving (parent) role inherits the child role's privileges. We use functional account roles rather than granting privileges directly to people.

| Role | Responsibility | Intended user type |
|---|---|---|
| `NACHO_SECURITY_ADMIN` | Project security grants and role assignment. | Restricted human administrator |
| `NACHO_PLATFORM_ADMIN` | Project infrastructure and shared platform objects. | Restricted human administrator |
| `NACHO_DATA_ENGINEER` | Data ingestion, transformation, and operational workloads. | Data engineering users |
| `NACHO_DATA_ANALYST` | Consumption of approved data products. | Analyst users |
| `NACHO_CICD_DEPLOYER` | Automated, non-human deployment identity. | CI/CD service user |

## Initial hierarchy

```text
ACCOUNTADMIN                         (temporary bootstrap only)
+-- SYSADMIN
|   +-- NACHO_PLATFORM_ADMIN
|   |   +-- NACHO_DATA_ENGINEER
|   |       +-- NACHO_DATA_ANALYST
|   +-- NACHO_CICD_DEPLOYER
+-- SECURITYADMIN
    +-- NACHO_SECURITY_ADMIN
```

`NACHO_DATA_ENGINEER` inherits `NACHO_DATA_ANALYST` so engineers can validate downstream data products. The CI/CD role is deliberately separate from human administration roles; it will receive only deployment privileges for the target environment.

## Why not use built-in roles daily?

`ACCOUNTADMIN`, `SECURITYADMIN`, and `SYSADMIN` are account-level built-in roles. They remain necessary for controlled administration, but assigning them as daily working roles violates least privilege and makes audit evidence harder to interpret. Custom roles express project responsibilities and can be granted narrowly.

## Deferred decisions

- Granting roles to users.
- Database, schema, warehouse, and data privileges.
- Environment-specific roles for `DEV`, `QA`, and `PROD`.
- Service user and key-pair authentication for CI/CD.
- Network policies and future-grant strategy.

These decisions require the relevant objects to exist and will be handled in later steps.

## Source-control and dbt sequencing

The local project repository will be connected to GitHub before more project SQL is created, so every subsequent implementation step is versioned and reviewable. The Snowflake web Git integration is deferred until the dbt and CI/CD phase because it requires a controlled API integration and, for private repositories, a secure authentication design.

dbt is introduced after Bronze ingestion is stable and before Silver and Gold transformations. It will own transformation models, tests, source definitions, documentation, and lineage. We will choose between dbt Core and dbt Projects on Snowflake at that point, based on the required operating model.

## Bootstrap transition for the project owner

For the initial project owner, `NACHO_PLATFORM_ADMIN` is assigned as the default role. It receives only `CREATE DATABASE` and `CREATE WAREHOUSE` at account scope, which are required to provision the project's first controlled resources. The existing `ACCOUNTADMIN` assignment is retained as emergency bootstrap access but is not a daily-working role.

This is deliberately not a complete platform-administration permission set. Security administration, user administration, integration creation, grant management, and cost-governance privileges remain outside this role until a later step has a justified need for each privilege.
