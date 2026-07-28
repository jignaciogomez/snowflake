# Snowflake Storage Integration

## Purpose

`NACHO_S3_DEV_INT` is the Snowflake account-level object that allows external stages to access the approved DEV orders S3 prefix.

It points to the AWS IAM role:

```text
arn:aws:iam::245395155735:role/NachoSnowflakeS3OrdersDevRole
```

And restricts stages to:

```text
s3://amazn-bucket-snowflake/nacho/dev/orders/
```

## Why ACCOUNTADMIN?

Storage integrations are account-level security objects. Creating them requires high-level administrative privileges. In this project, `ACCOUNTADMIN` is used only for this controlled bootstrap step.

## Why not CREATE OR REPLACE?

The script uses `CREATE STORAGE INTEGRATION IF NOT EXISTS`.

This is intentional. Replacing a storage integration after AWS trust is configured can change generated integration metadata such as the external ID. That can break the AWS trust relationship and cause confusing S3 access failures.

## What happens after creation?

After creating the integration, Snowflake generates values that must be copied into the AWS IAM role trust policy:

| Snowflake property | AWS trust policy usage |
|---|---|
| `STORAGE_AWS_IAM_USER_ARN` | AWS trusted principal |
| `STORAGE_AWS_EXTERNAL_ID` | `sts:ExternalId` condition |

The integration is not fully usable until the AWS role trust policy is updated with these values.

For this project, the generated values are:

```text
STORAGE_AWS_IAM_USER_ARN = arn:aws:iam::877643141453:user/k7t02000-s
STORAGE_AWS_EXTERNAL_ID  = JA46364_SFCRole=2_SoayQE5D6AvnO9FkBOvMgh9W2Gc=
```

## Enterprise recommendation

Use one integration per meaningful security boundary. For this project, the boundary is DEV orders ingestion. In a larger enterprise, boundaries may be separated by environment, data domain, data sensitivity, or platform team ownership.

## Common production mistake

Granting a storage integration access to a broad S3 bucket and trying to enforce all restrictions only at the external stage level. Defense-in-depth means both the integration and the IAM policy should be narrow.
