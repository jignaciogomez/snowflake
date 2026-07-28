# Snowflake Enterprise Data Platform

An incremental, production-oriented Snowflake data engineering project. We will build the platform in small, verified steps, from an empty Snowflake account and AWS S3 bucket.

## Delivery principles

- One major capability per step; no unverified dependencies.
- SQL, application code, documentation, and tests are versioned together.
- Every Snowflake object is created through reviewed, idempotent scripts where feasible.
- Secrets and account-specific identifiers are never committed.

## Repository layout

```text
.
|-- config/              # Non-secret configuration templates
|-- data/sample/          # Small, non-sensitive sample datasets only
|-- docs/                 # Architecture, runbooks, and prerequisites
|-- logs/                 # Local execution logs; ignored by Git
|-- sql/                  # Ordered, executable Snowflake SQL scripts
|-- src/snowpark/         # Snowpark Python application code
`-- tests/                # Automated tests
```

## Delivery sequence

1. Repository foundation and prerequisites
2. Snowflake account access and baseline identity model
3. Connect the local repository to GitHub and create the protected source-of-truth baseline
4. Core account objects: database, schemas, warehouses, and cost controls
5. AWS S3 integration and external data ingestion
6. Bronze-layer raw ingestion, validation, and load auditability
7. dbt project setup: models, tests, documentation, and environment targets
8. Silver/Gold transformations, dimensional modeling, and data quality
9. Snowflake Git Workspaces and CI/CD deployment controls

The detailed prerequisites for the next step are in [docs/SETUP_PREREQUISITES.md](docs/SETUP_PREREQUISITES.md).

## Conventions

- Environments: `DEV`, `QA`, `PROD`
- SQL folders use a numeric prefix to make deployment order explicit.
- Object names will use uppercase Snowflake identifiers unless a feature requires quoted identifiers.
- Account-specific values belong in local configuration, never hard-coded in SQL.
- GitHub is the source of truth; Snowflake Git repositories and Workspaces are downstream clients of it.

## Current DEV foundation

| Object type | Name |
|---|---|
| Database | `NACHO_DEV_DB` |
| Schemas | `BRONZE`, `SILVER`, `GOLD`, `CONTROL` |
| Warehouse | `NACHO_DEV_WH` |
| Resource monitor | `NACHO_DEV_RM` |
| Control table | `NACHO_DEV_DB.CONTROL.LOAD_AUDIT` |
| First source file | `data/sample/orders_2026-07-01.csv` |
| Second source file | `data/sample/orders_2026-07-02.csv` |
| First file format | `NACHO_DEV_DB.BRONZE.ORDERS_CSV_FORMAT` |
| First internal stage | `NACHO_DEV_DB.BRONZE.ORDERS_INTERNAL_STAGE` |
| First Bronze table | `NACHO_DEV_DB.BRONZE.ORDERS_RAW` |
| First validation script | `sql/02_ingestion/06_validate_bronze_orders_raw.sql` |

## Current DEV access model

| Role | Scope |
|---|---|
| `NACHO_PLATFORM_ADMIN` | Owns DEV infrastructure objects. |
| `NACHO_DATA_ENGINEER` | Can create DEV engineering objects across medallion schemas. |
| `NACHO_DATA_ANALYST` | Can access the DEV curated `GOLD` schema. |
