-- =============================================================================
-- Step 5.3: S3 storage integration
-- Purpose: Create the Snowflake account-level integration for DEV orders S3 reads.
-- Execution role: ACCOUNTADMIN
-- =============================================================================

USE ROLE ACCOUNTADMIN;

CREATE STORAGE INTEGRATION IF NOT EXISTS NACHO_S3_DEV_INT
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::245395155735:role/NachoSnowflakeS3OrdersDevRole'
    STORAGE_ALLOWED_LOCATIONS = ('s3://amazn-bucket-snowflake/nacho/dev/orders/')
    COMMENT = 'Storage integration allowing Snowflake to read DEV orders files from S3.';

-- Run this after creation to retrieve the values required for the AWS IAM role
-- trust policy:
--
-- DESC INTEGRATION NACHO_S3_DEV_INT;
--
-- Capture these properties:
-- - STORAGE_AWS_IAM_USER_ARN
-- - STORAGE_AWS_EXTERNAL_ID
