# Load Audit Design

## Purpose

`NACHO_DEV_DB.CONTROL.LOAD_AUDIT` is the first operational metadata table in the project.

Its job is to answer operational questions:

- Which pipeline ran?
- Which file or source was processed?
- When did it start and finish?
- Did it succeed, partially load, or fail?
- How many rows were parsed, loaded, or rejected?
- Which Snowflake query id can we inspect for troubleshooting?

## Why this table exists before ingestion

Enterprise pipelines need observability from the beginning. If we ingest data first and add logging later, the first failures have no durable operational evidence.

Creating the audit table now gives every future ingestion path a consistent place to record load attempts.

## Design decisions

| Decision | Choice | Reason |
|---|---|---|
| Table location | `CONTROL` schema | Operational metadata is separated from business data layers. |
| Grain | One row per load attempt | Supports retries, partial failures, and troubleshooting. |
| Identifier | `LOAD_ID` autoincrement | Simple surrogate key for joining future detail tables. |
| Timestamps | `TIMESTAMP_TZ` | Preserves timezone context for operational events. |
| Query tracking | `SNOWFLAKE_QUERY_ID` | Connects audit records to Snowflake query history and query profile. |

## Enterprise recommendation

Keep audit tables simple, append-oriented, and durable. Do not hide operational state only in orchestration logs, because orchestration systems change and log retention varies.

## Simpler alternative

Rely only on Snowflake query history.

That is useful for diagnostics, but it is not a replacement for pipeline-specific audit data. Query history does not know your business pipeline name, source-system semantics, retry attempt policy, or row-quality interpretation.

## Deferred enhancements

Later we may add:

- a load status reference table
- a file-level rejection detail table
- task execution history integration
- data-quality result tables
- alerts or notifications
- a stream on the audit table for operational events
