# S3 Ingestion Security Plan

## Purpose

This document defines the first AWS S3 ingestion boundary for the project before we create IAM objects or Snowflake storage integrations.

The goal is to connect Snowflake to S3 using an enterprise-style, least-privilege design.

## Known account values

| Setting | Value |
|---|---|
| Snowflake organization | `DXJIWCG` |
| Snowflake account | `GR54000` |
| Snowflake region | `AWS_US_EAST_2` |
| AWS region | `us-east-2` |
| S3 bucket | `amazn-bucket-snowflake` |

## Recommended S3 prefix layout

For this single-account learning project, environments are separated by path prefix inside one S3 bucket:

```text
s3://amazn-bucket-snowflake/nacho/dev/orders/
s3://amazn-bucket-snowflake/nacho/qa/orders/
s3://amazn-bucket-snowflake/nacho/prod/orders/
```

For the next ingestion step, we will use only:

```text
s3://amazn-bucket-snowflake/nacho/dev/orders/
```

Daily files will land under date-partition-style folders:

```text
s3://amazn-bucket-snowflake/nacho/dev/orders/dt=2026-07-03/orders_2026-07-03.csv
```

## Why prefix-level isolation?

Snowflake storage integrations allow us to restrict external stages to approved cloud locations. We should not grant Snowflake access to the whole bucket unless the integration genuinely needs it.

The first Snowflake storage integration should therefore use:

```sql
STORAGE_ALLOWED_LOCATIONS = ('s3://amazn-bucket-snowflake/nacho/dev/orders/')
```

This limits the blast radius if a stage is misconfigured.

## Object model we will build next

| Layer | Object | Planned name |
|---|---|---|
| AWS | IAM policy | `NachoSnowflakeS3OrdersDevReadPolicy` |
| AWS | IAM role | `NachoSnowflakeS3OrdersDevRole` |
| Snowflake | Storage integration | `NACHO_S3_DEV_INT` |
| Snowflake | External stage | `NACHO_DEV_DB.BRONZE.ORDERS_S3_STAGE` |

The AWS IAM role ARN is:

```text
arn:aws:iam::245395155735:role/NachoSnowflakeS3OrdersDevRole
```

## Security flow

```text
Snowflake external stage
    -> Snowflake storage integration
    -> Snowflake-generated AWS IAM user ARN
    -> AWS IAM role trust policy
    -> AWS IAM policy
    -> S3 bucket prefix
```

## Enterprise recommendation

Use a Snowflake storage integration instead of static AWS access keys. A storage integration avoids storing cloud secrets in stages and uses AWS IAM trust with an external ID.

## Simpler alternative

Create an external stage with AWS access key and secret key credentials.

This is simpler for demos, but it is not the recommended enterprise pattern because secrets must be stored, rotated, and protected.

## Production mistakes to avoid

- Granting Snowflake access to `s3://amazn-bucket-snowflake/` when only one prefix is needed.
- Using long-lived AWS access keys in stage definitions.
- Skipping the external ID condition in the IAM trust policy.
- Mixing `DEV`, `QA`, and `PROD` source files in the same prefix.
- Creating Snowflake integrations with `CREATE OR REPLACE` after AWS trust is configured, because that can generate a new external ID.
