# S3 External Stage Strategy

## Purpose

`NACHO_DEV_DB.BRONZE.ORDERS_S3_STAGE` points Snowflake at the DEV orders prefix in S3:

```text
s3://amazn-bucket-snowflake/nacho/dev/orders/
```

This is the first external stage in the project.

## How it fits

```text
S3 bucket prefix
    -> Snowflake storage integration NACHO_S3_DEV_INT
    -> external stage NACHO_DEV_DB.BRONZE.ORDERS_S3_STAGE
    -> COPY INTO BRONZE.ORDERS_RAW
```

## Why external stage now?

We already proved the Snowflake loading pattern with an internal stage. The external stage now replaces Snowflake-managed file storage with AWS S3 as the landing boundary.

The `COPY INTO` pattern will remain familiar. The source location changes from:

```text
@NACHO_DEV_DB.BRONZE.ORDERS_INTERNAL_STAGE
```

to:

```text
@NACHO_DEV_DB.BRONZE.ORDERS_S3_STAGE
```

## Privilege difference

| Stage type | Common privileges |
|---|---|
| Internal stage | `READ`, `WRITE` |
| External stage | `USAGE` |

The S3 read permissions are controlled by AWS IAM and the Snowflake storage integration. The Snowflake stage privilege controls whether a Snowflake role can reference the stage.

## Enterprise recommendation

Use external stages for durable enterprise ingestion boundaries. Keep the stage URL scoped to the smallest useful prefix and use a storage integration rather than access keys.

## Common production mistake

Creating an external stage with a broad bucket URL such as `s3://bucket-name/` and relying on file patterns to limit access. The URL, storage integration, and IAM policy should all align to the intended prefix.
