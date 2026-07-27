-- =============================================================================
-- Step 3.3: DEV warehouse resource monitor
-- Purpose: Add a monthly credit guardrail to the DEV warehouse.
-- Execution role: ACCOUNTADMIN
-- =============================================================================

USE ROLE ACCOUNTADMIN;

CREATE RESOURCE MONITOR IF NOT EXISTS NACHO_DEV_RM
    WITH
        CREDIT_QUOTA = 10
        FREQUENCY = MONTHLY
        START_TIMESTAMP = IMMEDIATELY
        TRIGGERS
            ON 50 PERCENT DO NOTIFY
            ON 80 PERCENT DO NOTIFY
            ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE NACHO_DEV_WH
    SET RESOURCE_MONITOR = NACHO_DEV_RM;

-- Resource monitors are account-level cost controls. In Snowflake, creating
-- resource monitors and assigning them to warehouses is intentionally restricted
-- to ACCOUNTADMIN.
