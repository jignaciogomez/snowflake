-- =============================================================================
-- Step 4.3a: Bronze raw orders table
-- Purpose: Create the raw landing table for orders CSV ingestion.
-- Execution role: NACHO_PLATFORM_ADMIN
-- =============================================================================

USE ROLE NACHO_PLATFORM_ADMIN;
USE DATABASE NACHO_DEV_DB;
USE SCHEMA BRONZE;

CREATE TABLE IF NOT EXISTS ORDERS_RAW (
    ORDER_ID VARCHAR
        COMMENT 'Source order identifier, stored as raw text in Bronze.',
    CUSTOMER_ID VARCHAR
        COMMENT 'Source customer identifier, stored as raw text in Bronze.',
    ORDER_TS VARCHAR
        COMMENT 'Source order timestamp, stored as raw text in Bronze.',
    STATUS VARCHAR
        COMMENT 'Source order lifecycle status, stored as raw text in Bronze.',
    CURRENCY VARCHAR
        COMMENT 'Source currency code, stored as raw text in Bronze.',
    GROSS_AMOUNT VARCHAR
        COMMENT 'Source gross amount, stored as raw text in Bronze.',
    DISCOUNT_AMOUNT VARCHAR
        COMMENT 'Source discount amount, stored as raw text in Bronze.',
    TAX_AMOUNT VARCHAR
        COMMENT 'Source tax amount, stored as raw text in Bronze.',
    SOURCE_UPDATED_AT VARCHAR
        COMMENT 'Source update timestamp, stored as raw text in Bronze.',
    METADATA_FILE_NAME VARCHAR NOT NULL
        COMMENT 'Name of the staged source file loaded into this row.',
    METADATA_FILE_ROW_NUMBER NUMBER NOT NULL
        COMMENT 'Row number reported by Snowflake file metadata.',
    LOAD_TS TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP()
        COMMENT 'Timestamp when the row was inserted into the Bronze table.'
)
COMMENT = 'Raw Bronze landing table for daily orders CSV extracts.';

GRANT SELECT, INSERT
    ON TABLE ORDERS_RAW
    TO ROLE NACHO_DATA_ENGINEER;
