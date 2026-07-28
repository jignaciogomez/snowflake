# Update AWS IAM Trust for Snowflake

## Purpose

This runbook updates `NachoSnowflakeS3OrdersDevRole` so Snowflake can assume it through the storage integration `NACHO_S3_DEV_INT`.

## Values

| Field | Value |
|---|---|
| AWS IAM role | `NachoSnowflakeS3OrdersDevRole` |
| AWS IAM role ARN | `arn:aws:iam::245395155735:role/NachoSnowflakeS3OrdersDevRole` |
| Snowflake IAM user ARN | `arn:aws:iam::877643141453:user/k7t02000-s` |
| Snowflake external ID | `JA46364_SFCRole=2_SoayQE5D6AvnO9FkBOvMgh9W2Gc=` |

## AWS Console steps

1. Open AWS Console.
2. Go to `IAM`.
3. Go to `Roles`.
4. Open `NachoSnowflakeS3OrdersDevRole`.
5. Open `Trust relationships`.
6. Choose `Edit trust policy`.
7. Replace the existing temporary trust policy with the JSON below.
8. Save the policy.

## Trust policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::877643141453:user/k7t02000-s"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "JA46364_SFCRole=2_SoayQE5D6AvnO9FkBOvMgh9W2Gc="
        }
      }
    }
  ]
}
```

## Why this is required

The AWS role controls who can assume it. The Snowflake storage integration generated a Snowflake-owned AWS IAM user ARN and an external ID. AWS must trust that principal and require the external ID before Snowflake can use the role.

## Common mistake

Leaving the temporary AWS account principal in place. If the trust policy does not use Snowflake's generated principal and external ID, Snowflake will not be able to list or read S3 files.
