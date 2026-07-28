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

## Project progress

### 1. Repository and local tooling

Status: completed

| Sub-step | Outcome |
|---|---|
| Local project structure | Created folders for SQL, docs, config, sample data, Snowpark code, tests, and logs. |
| Git repository | Connected local repository to GitHub as the source of truth. |
| Snowflake CLI | Installed and configured Snowflake CLI connections for bootstrap and platform work. |
| Git and Python | Installed and validated local tooling required for project development. |

### 2. Snowflake identity and access foundation

Status: completed

| Sub-step | Script | Outcome |
|---|---|---|
| Role hierarchy | `sql/01_foundation/01_create_role_hierarchy.sql` | Created project roles for security, platform administration, engineering, analytics, and CI/CD. |
| Platform-admin assignment | `sql/01_foundation/02_assign_platform_admin.sql` | Granted `NACHO_PLATFORM_ADMIN` to the project owner and gave it controlled account-level creation privileges. |
| DEV database and schemas | `sql/01_foundation/03_create_dev_database_and_schemas.sql` | Created `NACHO_DEV_DB` with `BRONZE`, `SILVER`, `GOLD`, and `CONTROL` schemas. |
| DEV warehouse | `sql/01_foundation/04_create_dev_warehouse.sql` | Created `NACHO_DEV_WH` as the development compute warehouse. |
| DEV resource monitor | `sql/01_foundation/05_create_dev_resource_monitor.sql` | Created `NACHO_DEV_RM` and attached it to the DEV warehouse. |
| DEV grants | `sql/01_foundation/06_grant_dev_database_access.sql` | Granted least-privilege DEV access to engineering and analyst roles. |
| Load audit table | `sql/01_foundation/07_create_control_load_audit.sql` | Created `NACHO_DEV_DB.CONTROL.LOAD_AUDIT`. |

### 3. Local/internal-stage ingestion

Status: completed

| Sub-step | Script or file | Outcome |
|---|---|---|
| First source contract | `docs/data-contracts/orders-csv-contract.md` | Defined the orders CSV file contract. |
| First sample file | `data/sample/orders_2026-07-01.csv` | Created first 10-row orders extract. |
| CSV file format | `sql/02_ingestion/01_create_csv_file_format.sql` | Created `NACHO_DEV_DB.BRONZE.ORDERS_CSV_FORMAT`. |
| Internal stage | `sql/02_ingestion/02_create_internal_orders_stage.sql` | Created `NACHO_DEV_DB.BRONZE.ORDERS_INTERNAL_STAGE`. |
| Bronze raw table | `sql/02_ingestion/03_create_bronze_orders_raw.sql` | Created `NACHO_DEV_DB.BRONZE.ORDERS_RAW`. |
| First internal load | `sql/02_ingestion/04_copy_orders_from_internal_stage.sql` | Loaded the first file into Bronze. |
| Second sample file | `data/sample/orders_2026-07-02.csv` | Created second 10-row orders extract. |
| Audit-aware internal load | `sql/02_ingestion/05_copy_orders_2026_07_02_with_audit.sql` | Loaded the second file and wrote a `LOAD_AUDIT` record. |
| Bronze validation | `sql/02_ingestion/06_validate_bronze_orders_raw.sql` | Added validation checks for row counts, file counts, required fields, uniqueness, domain values, and parseability. |

### 4. AWS S3 external-stage ingestion

Status: completed

| Sub-step | Script or file | Outcome |
|---|---|---|
| S3 security plan | `docs/architecture/s3-ingestion-security-plan.md` | Defined S3 prefix layout and least-privilege integration strategy. |
| AWS IAM policy template | `config/aws_s3_orders_dev_policy.template.json` | Defined read-only access to `s3://amazn-bucket-snowflake/nacho/dev/orders/`. |
| AWS IAM role | AWS Console | Created `NachoSnowflakeS3OrdersDevRole`. |
| Snowflake storage integration | `sql/03_aws_integration/01_create_s3_storage_integration.sql` | Created `NACHO_S3_DEV_INT`. |
| AWS trust-policy update | `docs/runbooks/update-aws-iam-trust-for-snowflake.md` | Updated the IAM role trust policy with Snowflake-generated principal and external ID. |
| S3 external stage | `sql/03_aws_integration/02_create_orders_s3_external_stage.sql` | Created `NACHO_DEV_DB.BRONZE.ORDERS_S3_STAGE`. |
| Third sample file | `data/sample/orders_2026-07-03.csv` | Created third 10-row orders extract. |
| S3 upload runbook | `docs/runbooks/upload-orders-file-to-s3.md` | Documented upload to `nacho/dev/orders/dt=2026-07-03/`. |
| Audit-aware S3 load | `sql/03_aws_integration/03_copy_orders_2026_07_03_from_s3_with_audit.sql` | Loaded the third file from S3 and wrote a `LOAD_AUDIT` record. |

### 5. Next planned phase

Status: not started

| Sub-step | Planned outcome |
|---|---|
| Update Bronze validation | Adjust checks for 30 rows and three files after the S3 load. |
| Silver typed orders table | Parse and type raw Bronze values into a validated Silver structure. |
| Silver data-quality rules | Add conformance checks for typed data. |
| dbt setup | Introduce dbt after the raw ingestion path is stable. |

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
| Third source file | `data/sample/orders_2026-07-03.csv` |
| First file format | `NACHO_DEV_DB.BRONZE.ORDERS_CSV_FORMAT` |
| First internal stage | `NACHO_DEV_DB.BRONZE.ORDERS_INTERNAL_STAGE` |
| First Bronze table | `NACHO_DEV_DB.BRONZE.ORDERS_RAW` |
| First validation script | `sql/02_ingestion/06_validate_bronze_orders_raw.sql` |
| S3 DEV orders prefix | `s3://amazn-bucket-snowflake/nacho/dev/orders/` |
| Storage integration | `NACHO_S3_DEV_INT` |
| S3 external stage | `NACHO_DEV_DB.BRONZE.ORDERS_S3_STAGE` |

## Current DEV access model

| Role | Scope |
|---|---|
| `NACHO_PLATFORM_ADMIN` | Owns DEV infrastructure objects. |
| `NACHO_DATA_ENGINEER` | Can create DEV engineering objects across medallion schemas. |
| `NACHO_DATA_ANALYST` | Can access the DEV curated `GOLD` schema. |
