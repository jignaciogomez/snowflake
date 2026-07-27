-- =============================================================================
-- Step 4.1: Orders CSV file format
-- Purpose: Define how Snowflake should parse the first source CSV files.
-- Execution role: NACHO_PLATFORM_ADMIN
-- =============================================================================

USE ROLE NACHO_PLATFORM_ADMIN;
USE DATABASE NACHO_DEV_DB;
USE SCHEMA BRONZE;

CREATE FILE FORMAT IF NOT EXISTS ORDERS_CSV_FORMAT
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    EMPTY_FIELD_AS_NULL = TRUE
    NULL_IF = ('', 'NULL', 'null')
    TRIM_SPACE = TRUE
    ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE
    ENCODING = 'UTF8'
    COMMENT = 'CSV parser for daily orders extracts.';

GRANT USAGE
    ON FILE FORMAT ORDERS_CSV_FORMAT
    TO ROLE NACHO_DATA_ENGINEER;
