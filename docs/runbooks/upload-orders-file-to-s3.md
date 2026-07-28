# Upload Orders File to S3

## Purpose

This runbook uploads the third orders file to the DEV S3 landing prefix so Snowflake can load it through `ORDERS_S3_STAGE`.

## Target file

Local file:

```text
data/sample/orders_2026-07-03.csv
```

S3 destination:

```text
s3://amazn-bucket-snowflake/nacho/dev/orders/dt=2026-07-03/orders_2026-07-03.csv
```

## AWS Console steps

1. Open AWS Console.
2. Go to `S3`.
3. Open bucket `amazn-bucket-snowflake`.
4. Navigate to `nacho/dev/orders/`.
5. Create or open folder `dt=2026-07-03`.
6. Choose `Upload`.
7. Select `data/sample/orders_2026-07-03.csv`.
8. Keep default upload settings.
9. Complete the upload.

## Validation from Snowflake

After upload, this command should show the file:

```sql
LIST @NACHO_DEV_DB.BRONZE.ORDERS_S3_STAGE/dt=2026-07-03;
```

## Enterprise note

The date-style folder is a partition-like prefix. It helps organize files, supports lifecycle policies, and keeps listing operations focused as ingestion volume grows.
