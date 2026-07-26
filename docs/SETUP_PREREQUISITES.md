# Prerequisites and Access Baseline

Complete this checklist before Step 2. Do not create project databases, warehouses, users, roles, or S3 objects yet.

## 1. Snowflake account access

Obtain the following from the account administrator:

- Account identifier and Snowsight URL.
- A user able to use the `ACCOUNTADMIN` role for the initial, controlled bootstrap only.
- Confirmation that the account is on AWS and the AWS region/cloud-region pair.
- Confirmation that the account edition supports the features we introduce. Enterprise Edition is the recommended baseline because it supports the full enterprise learning path, including multi-cluster warehouses and advanced governance capabilities. A lower edition can support early steps, but may limit later exercises.

Record account-specific values locally; never commit them.

## 2. AWS access

Obtain an AWS identity with permission to manage only the project bucket and its IAM integration resources. The target scope for later steps is:

- One empty, dedicated S3 bucket in the same AWS region as Snowflake where possible.
- Permission to create or update an IAM role and least-privilege bucket policy for the Snowflake storage integration.
- Permission to configure S3 event notifications when we implement Snowpipe.

Do not use account-root credentials or long-lived access keys for Snowflake ingestion.

## 3. Local workstation

- Install Git and ensure `git --version` works in PowerShell.
- Install Python 3.11 or later and ensure `python --version` works.
- Use a code editor with SQL and Python support.
- Install the Snowflake CLI only after the Snowflake identity model is established; this avoids storing an `ACCOUNTADMIN` credential in local automation.

## 4. Security decisions to confirm

For this learning project, we will use separate functional roles, least privilege, and non-human automation identities later. Bring the following information to Step 2:

- Your preferred initials or neutral project prefix (for user/role naming when required).
- Whether your organization requires SSO/MFA and network policies.
- Whether an existing security administrator must approve role and integration creation.

## Values to have ready (keep outside Git)

```text
SNOWFLAKE_ORGANIZATION=<organization_name>
SNOWFLAKE_ACCOUNT=<account_locator_or_account_name>
SNOWFLAKE_CLOUD_REGION=<aws_region>
AWS_REGION=<aws_region>
S3_BUCKET_NAME=<globally_unique_empty_bucket_name>
```

These are placeholders, not credentials. We will introduce a local `.env.example` template only when a script needs it.
