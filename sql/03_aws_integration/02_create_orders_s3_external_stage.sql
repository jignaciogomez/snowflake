-- =============================================================================
-- Step 5.5: S3 external stage for DEV orders
-- Purpose: Create a Snowflake external stage over the DEV orders S3 prefix.
-- Execution role: NACHO_PLATFORM_ADMIN
-- =============================================================================

USE ROLE NACHO_PLATFORM_ADMIN;
USE DATABASE NACHO_DEV_DB;
USE SCHEMA BRONZE;

CREATE STAGE IF NOT EXISTS ORDERS_S3_STAGE
    URL = 's3://amazn-bucket-snowflake/nacho/dev/orders/'
    STORAGE_INTEGRATION = NACHO_S3_DEV_INT
    FILE_FORMAT = ORDERS_CSV_FORMAT
    COMMENT = 'External S3 stage for DEV orders files.';

-- External stages use USAGE. Unlike internal stages, they do not use READ/WRITE.
GRANT USAGE
    ON STAGE ORDERS_S3_STAGE
    TO ROLE NACHO_DATA_ENGINEER;
