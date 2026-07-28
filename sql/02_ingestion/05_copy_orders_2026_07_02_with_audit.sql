-- =============================================================================
-- Step 4.4: Audit-aware orders load
-- Purpose: Load the second orders file and write operational audit evidence.
-- Execution role: NACHO_PLATFORM_ADMIN
-- =============================================================================

EXECUTE IMMEDIATE $$
DECLARE
    v_pipeline_name VARCHAR DEFAULT 'bronze_orders_internal_stage_copy';
    v_source_file_name VARCHAR DEFAULT 'orders_2026-07-02.csv.gz';
    v_source_file_path VARCHAR DEFAULT '@NACHO_DEV_DB.BRONZE.ORDERS_INTERNAL_STAGE/orders_2026-07-02.csv.gz';
    v_started_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP();
    v_copy_query_id VARCHAR;
    v_rows_parsed NUMBER DEFAULT 0;
    v_rows_loaded NUMBER DEFAULT 0;
    v_rows_rejected NUMBER DEFAULT 0;
BEGIN
    USE ROLE NACHO_PLATFORM_ADMIN;
    USE WAREHOUSE NACHO_DEV_WH;
    USE DATABASE NACHO_DEV_DB;
    USE SCHEMA BRONZE;

    INSERT INTO NACHO_DEV_DB.CONTROL.LOAD_AUDIT (
        PIPELINE_NAME,
        SOURCE_SYSTEM,
        SOURCE_FILE_NAME,
        SOURCE_FILE_PATH,
        LOAD_STARTED_AT,
        STATUS
    )
    VALUES (
        :v_pipeline_name,
        'ORDER_MANAGEMENT',
        :v_source_file_name,
        :v_source_file_path,
        :v_started_at,
        'STARTED'
    );

    COPY INTO NACHO_DEV_DB.BRONZE.ORDERS_RAW (
        ORDER_ID,
        CUSTOMER_ID,
        ORDER_TS,
        STATUS,
        CURRENCY,
        GROSS_AMOUNT,
        DISCOUNT_AMOUNT,
        TAX_AMOUNT,
        SOURCE_UPDATED_AT,
        METADATA_FILE_NAME,
        METADATA_FILE_ROW_NUMBER,
        LOAD_TS
    )
    FROM (
        SELECT
            $1::VARCHAR AS ORDER_ID,
            $2::VARCHAR AS CUSTOMER_ID,
            $3::VARCHAR AS ORDER_TS,
            $4::VARCHAR AS STATUS,
            $5::VARCHAR AS CURRENCY,
            $6::VARCHAR AS GROSS_AMOUNT,
            $7::VARCHAR AS DISCOUNT_AMOUNT,
            $8::VARCHAR AS TAX_AMOUNT,
            $9::VARCHAR AS SOURCE_UPDATED_AT,
            METADATA$FILENAME::VARCHAR AS METADATA_FILE_NAME,
            METADATA$FILE_ROW_NUMBER::NUMBER AS METADATA_FILE_ROW_NUMBER,
            CURRENT_TIMESTAMP() AS LOAD_TS
        FROM @NACHO_DEV_DB.BRONZE.ORDERS_INTERNAL_STAGE/orders_2026-07-02.csv.gz
    )
    FILE_FORMAT = (FORMAT_NAME = NACHO_DEV_DB.BRONZE.ORDERS_CSV_FORMAT)
    ON_ERROR = ABORT_STATEMENT;

    v_copy_query_id := SQLID;

    SELECT
        COALESCE(SUM("rows_parsed"), 0),
        COALESCE(SUM("rows_loaded"), 0),
        COALESCE(SUM("errors_seen"), 0)
    INTO
        :v_rows_parsed,
        :v_rows_loaded,
        :v_rows_rejected
    FROM TABLE(RESULT_SCAN(:v_copy_query_id));

    UPDATE NACHO_DEV_DB.CONTROL.LOAD_AUDIT
    SET
        LOAD_COMPLETED_AT = CURRENT_TIMESTAMP(),
        STATUS = 'SUCCEEDED',
        ROWS_PARSED = :v_rows_parsed,
        ROWS_LOADED = :v_rows_loaded,
        ROWS_REJECTED = :v_rows_rejected,
        SNOWFLAKE_QUERY_ID = :v_copy_query_id
    WHERE
        PIPELINE_NAME = :v_pipeline_name
        AND SOURCE_FILE_NAME = :v_source_file_name
        AND LOAD_STARTED_AT = :v_started_at
        AND STATUS = 'STARTED';

EXCEPTION
    WHEN OTHER THEN
        UPDATE NACHO_DEV_DB.CONTROL.LOAD_AUDIT
        SET
            LOAD_COMPLETED_AT = CURRENT_TIMESTAMP(),
            STATUS = 'FAILED',
            ERROR_CODE = :SQLCODE,
            ERROR_MESSAGE = :SQLERRM,
            SNOWFLAKE_QUERY_ID = SQLID
        WHERE
            PIPELINE_NAME = :v_pipeline_name
            AND SOURCE_FILE_NAME = :v_source_file_name
            AND LOAD_STARTED_AT = :v_started_at
            AND STATUS = 'STARTED';

        RAISE;
END;
$$;
