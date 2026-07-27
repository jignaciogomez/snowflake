# Internal Stage Strategy

## Purpose

`NACHO_DEV_DB.BRONZE.ORDERS_INTERNAL_STAGE` is a Snowflake-managed internal stage used for local development uploads.

This is a bridge step before AWS S3. It lets us learn Snowflake staging mechanics without mixing in IAM, storage integrations, bucket policies, or cloud event notifications yet.

## How internal stages work

An internal stage stores files inside Snowflake-managed storage. A client uploads local files into the stage with `PUT`, then Snowflake can inspect or load those staged files with commands such as `LIST` and `COPY INTO`.

```text
local CSV file -> PUT -> internal stage -> COPY INTO -> bronze table
```

## Why use an internal stage first?

| Option | Use now? | Reason |
|---|---|---|
| Internal stage | Yes | Fastest way to isolate Snowflake loading concepts. |
| External S3 stage | Later | Requires AWS IAM, storage integration, S3 path design, and cloud security decisions. |
| Snowsight manual upload | No | Useful for demos, but less reproducible than versioned CLI commands. |

## Privileges

For internal stages, Snowflake uses `READ` and `WRITE` privileges:

| Privilege | Purpose |
|---|---|
| `READ` | Allows listing, reading, and downloading staged files. |
| `WRITE` | Allows uploading and removing files from the stage. |

`USAGE` applies to external stages, not internal stages.

## Enterprise recommendation

Use internal stages for controlled development, small utility files, Snowpark dependencies, and temporary workflows. Use external stages backed by cloud storage for enterprise ingestion at scale.

## Common production mistake

Using internal stages as the permanent landing zone for source-system files. That hides the ingestion boundary inside Snowflake and bypasses cloud-native storage governance, lifecycle policies, and event-driven ingestion patterns.
