# Bronze Orders Raw Design

## Purpose

`NACHO_DEV_DB.BRONZE.ORDERS_RAW` is the first Bronze table in the project.

It stores the contents of the orders CSV file with source fidelity and ingestion metadata.

## Grain

One row in `ORDERS_RAW` represents one row from one source file.

## Why source columns are stored as text

The source contract documents the intended interpretation of each field, but the Bronze table stores the incoming values as `VARCHAR`.

This is intentional:

- Bronze preserves what arrived from the source.
- Silver performs parsing, typing, validation, standardization, and deduplication.
- Bad source values remain inspectable instead of disappearing during an early cast failure.

## Metadata columns

| Column | Purpose |
|---|---|
| `METADATA_FILE_NAME` | Identifies the staged file that produced the row. |
| `METADATA_FILE_ROW_NUMBER` | Preserves the source row position reported by Snowflake. |
| `LOAD_TS` | Captures when Snowflake inserted the row. |

## Load behavior

The first load uses `COPY INTO` from `ORDERS_INTERNAL_STAGE`.

`ON_ERROR = ABORT_STATEMENT` is intentionally strict. If one row is malformed, the full load fails, making the issue visible during early development.

## Enterprise recommendation

Keep Bronze close to the source, append ingestion metadata, and defer business typing to Silver. This preserves lineage and makes data-quality issues easier to diagnose.

## Simpler alternative

Load directly into typed columns such as `TIMESTAMP_NTZ` and `NUMBER(12,2)`.

That is convenient for small demos, but it mixes ingestion and transformation concerns. In production, it can also obscure which source value caused a parsing issue.

## Common production mistake

Over-transforming in Bronze. Bronze should not become the place where business rules, deduplication, and dimensional modeling quietly start.
