-- =============================================================================
-- Step 3.5: CONTROL load audit table
-- Purpose: Create the first operational metadata table for ingestion tracking.
-- Execution role: NACHO_PLATFORM_ADMIN
-- =============================================================================

USE ROLE NACHO_PLATFORM_ADMIN;
USE WAREHOUSE NACHO_DEV_WH;
USE DATABASE NACHO_DEV_DB;
USE SCHEMA CONTROL;

CREATE TABLE IF NOT EXISTS LOAD_AUDIT (
    LOAD_ID NUMBER AUTOINCREMENT START 1 INCREMENT 1
        COMMENT 'Surrogate identifier for each load attempt.',
    PIPELINE_NAME VARCHAR(200) NOT NULL
        COMMENT 'Logical pipeline name, such as bronze_orders_copy.',
    SOURCE_SYSTEM VARCHAR(200)
        COMMENT 'Source application, provider, or domain that produced the data.',
    SOURCE_FILE_NAME VARCHAR(500)
        COMMENT 'Original file name loaded by the pipeline.',
    SOURCE_FILE_PATH VARCHAR(2000)
        COMMENT 'Full source path or stage-relative path for the file.',
    FILE_SIZE_BYTES NUMBER
        COMMENT 'Source file size in bytes when available.',
    FILE_LAST_MODIFIED_TS TIMESTAMP_TZ
        COMMENT 'Last modified timestamp reported by the source storage layer.',
    LOAD_STARTED_AT TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP()
        COMMENT 'Timestamp when the load attempt started.',
    LOAD_COMPLETED_AT TIMESTAMP_TZ
        COMMENT 'Timestamp when the load attempt finished.',
    STATUS VARCHAR(30) NOT NULL
        COMMENT 'Load status, for example STARTED, SUCCEEDED, FAILED, or PARTIALLY_LOADED.',
    ROWS_PARSED NUMBER DEFAULT 0
        COMMENT 'Number of source rows parsed or read.',
    ROWS_LOADED NUMBER DEFAULT 0
        COMMENT 'Number of rows successfully loaded.',
    ROWS_REJECTED NUMBER DEFAULT 0
        COMMENT 'Number of rows rejected or quarantined.',
    ERROR_CODE VARCHAR(200)
        COMMENT 'Snowflake or application error code, when applicable.',
    ERROR_MESSAGE VARCHAR(5000)
        COMMENT 'Human-readable error details, when applicable.',
    SNOWFLAKE_QUERY_ID VARCHAR(100)
        COMMENT 'Snowflake query id associated with the load command.',
    CREATED_BY VARCHAR(200) NOT NULL DEFAULT CURRENT_USER()
        COMMENT 'Snowflake user that inserted the audit record.',
    CREATED_AT TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP()
        COMMENT 'Timestamp when the audit record was inserted.'
)
COMMENT = 'Operational audit table for tracking ingestion and transformation load attempts.';

GRANT SELECT, INSERT
    ON TABLE LOAD_AUDIT
    TO ROLE NACHO_DATA_ENGINEER;
