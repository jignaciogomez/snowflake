# Compute Strategy

## DEV warehouse

`NACHO_DEV_WH` is the first project warehouse. It is intentionally small and conservative:

| Setting | Value | Reason |
|---|---:|---|
| `WAREHOUSE_SIZE` | `XSMALL` | Lowest-cost compute size for development and small sample data. |
| `WAREHOUSE_TYPE` | `STANDARD` | General-purpose Snowflake compute. Snowpark-optimized warehouses are deferred until we have a workload that justifies them. |
| `AUTO_SUSPEND` | `60` seconds | Reduces idle compute cost during hands-on development. |
| `AUTO_RESUME` | `TRUE` | Improves developer ergonomics by resuming automatically when a query runs. |
| `INITIALLY_SUSPENDED` | `TRUE` | Prevents the warehouse from consuming credits immediately after creation. |

## Why a dedicated DEV warehouse?

Snowflake separates storage from compute. The database stores data and metadata; the warehouse executes SQL, COPY commands, Snowpark jobs, dbt models, and analytical queries.

Using a dedicated DEV warehouse gives us workload isolation. Development experiments, failed queries, and iterative testing should not compete with future QA or PROD workloads.

## Grant model

| Role | Warehouse privileges | Intended use |
|---|---|---|
| `NACHO_PLATFORM_ADMIN` | `USAGE`, `OPERATE`, `MONITOR` | Owns and administers platform compute. |
| `NACHO_DATA_ENGINEER` | `USAGE`, `OPERATE` | Runs ingestion and transformation workloads. |
| `NACHO_DATA_ANALYST` | `USAGE` | Runs queries only. |

## Production note

In mature environments, warehouses are usually separated by workload class:

- ingestion warehouse
- transformation warehouse
- analyst warehouse
- BI warehouse
- data science or Snowpark warehouse

For this project, we start with one DEV warehouse to keep the learning path focused. We will split compute later when the workload boundaries become real.
