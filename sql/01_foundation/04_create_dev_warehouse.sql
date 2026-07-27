-- =============================================================================
-- Step 3.2: DEV warehouse
-- Purpose: Create the compute boundary for development workloads.
-- Execution role: NACHO_PLATFORM_ADMIN
-- =============================================================================

USE ROLE NACHO_PLATFORM_ADMIN;

CREATE WAREHOUSE IF NOT EXISTS NACHO_DEV_WH
    WAREHOUSE_SIZE = XSMALL
    WAREHOUSE_TYPE = STANDARD
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Development warehouse for the NACHO Snowflake data platform.';

-- Allow the platform admin role to operate the warehouse explicitly.
-- Ownership is created automatically by the role that creates the warehouse.
GRANT USAGE, OPERATE, MONITOR
    ON WAREHOUSE NACHO_DEV_WH
    TO ROLE NACHO_PLATFORM_ADMIN;

-- Data engineers will use this warehouse for ingestion and transformation work.
GRANT USAGE, OPERATE
    ON WAREHOUSE NACHO_DEV_WH
    TO ROLE NACHO_DATA_ENGINEER;

-- Analysts receive USAGE only. They can run queries but should not control
-- warehouse lifecycle operations in this project.
GRANT USAGE
    ON WAREHOUSE NACHO_DEV_WH
    TO ROLE NACHO_DATA_ANALYST;
