-- =============================================================================
-- Step 4.2: Internal stage for orders files
-- Purpose: Create a Snowflake-managed landing location for the first CSV file.
-- Execution role: NACHO_PLATFORM_ADMIN
-- =============================================================================

USE ROLE NACHO_PLATFORM_ADMIN;
USE DATABASE NACHO_DEV_DB;
USE SCHEMA BRONZE;

CREATE STAGE IF NOT EXISTS ORDERS_INTERNAL_STAGE
    FILE_FORMAT = ORDERS_CSV_FORMAT
    COMMENT = 'Internal stage for local development uploads of daily orders CSV files.';

-- For internal stages, Snowflake uses READ and WRITE privileges.
-- WRITE requires READ to be granted first.
GRANT READ
    ON STAGE ORDERS_INTERNAL_STAGE
    TO ROLE NACHO_DATA_ENGINEER;

GRANT WRITE
    ON STAGE ORDERS_INTERNAL_STAGE
    TO ROLE NACHO_DATA_ENGINEER;
