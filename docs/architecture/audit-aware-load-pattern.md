# Audit-Aware Load Pattern

## Purpose

This step turns `CONTROL.LOAD_AUDIT` from an empty structure into an active part of the ingestion workflow.

The script loads `orders_2026-07-02.csv.gz` and writes an audit trail around the load attempt.

## Flow

```text
insert STARTED audit row
    -> COPY INTO BRONZE.ORDERS_RAW
    -> capture COPY query id with SQLID
    -> read COPY output with RESULT_SCAN
    -> update audit row to SUCCEEDED
```

If the load fails, the exception handler updates the same audit row to `FAILED` and stores the error code and message.

## Why use Snowflake Scripting?

Snowflake Scripting lets multiple SQL statements run as one procedural block. That is useful when a pipeline step needs variables, exception handling, and control flow but we are not ready to introduce Snowpark or an external orchestrator.

Because this script runs through Snowflake CLI, it uses `EXECUTE IMMEDIATE $$ ... $$`.

## Query id capture

The global Snowflake Scripting variable `SQLID` stores the query id of the last executed SQL statement. Immediately after `COPY INTO`, the script saves `SQLID` into `v_copy_query_id`.

Then it uses `RESULT_SCAN(:v_copy_query_id)` to read the output rows returned by the `COPY INTO` command, including parsed rows, loaded rows, and errors seen.

## Enterprise recommendation

Every ingestion step should produce durable operational evidence:

- source identifier
- status
- start and completion timestamps
- row counts
- query id
- error details when applicable

This evidence should live in the data platform, not only in a terminal session or orchestration log.

## Simpler alternative

Run `COPY INTO` manually and inspect the result in the terminal.

That is acceptable for a first experiment, but it gives no durable pipeline history.

## Common production mistake

Logging only successful loads. Failed loads are usually the records you need most during support, incident review, and SLA reporting.
