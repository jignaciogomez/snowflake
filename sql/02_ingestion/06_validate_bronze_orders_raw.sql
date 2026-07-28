-- =============================================================================
-- Step 4.5: Bronze orders validation checks
-- Purpose: Validate the raw orders ingestion results without transforming data.
-- Execution role: NACHO_PLATFORM_ADMIN
-- =============================================================================

USE ROLE NACHO_PLATFORM_ADMIN;
USE WAREHOUSE NACHO_DEV_WH;
USE DATABASE NACHO_DEV_DB;
USE SCHEMA BRONZE;

WITH validation_checks AS (
    SELECT
        'ROW_COUNT_TOTAL' AS check_name,
        'ERROR' AS severity,
        'PASS' AS expected_result,
        IFF(COUNT(*) = 20, 'PASS', 'FAIL') AS actual_result,
        COUNT(*)::VARCHAR AS observed_value,
        'Expected 20 rows after loading two 10-row files.' AS notes
    FROM ORDERS_RAW

    UNION ALL

    SELECT
        'FILE_COUNT' AS check_name,
        'ERROR' AS severity,
        'PASS' AS expected_result,
        IFF(COUNT(DISTINCT METADATA_FILE_NAME) = 2, 'PASS', 'FAIL') AS actual_result,
        COUNT(DISTINCT METADATA_FILE_NAME)::VARCHAR AS observed_value,
        'Expected exactly two source files in Bronze.' AS notes
    FROM ORDERS_RAW

    UNION ALL

    SELECT
        'REQUIRED_FIELDS_NOT_NULL' AS check_name,
        'ERROR' AS severity,
        'PASS' AS expected_result,
        IFF(COUNT(*) = 0, 'PASS', 'FAIL') AS actual_result,
        COUNT(*)::VARCHAR AS observed_value,
        'Required source fields should not be null in Bronze.' AS notes
    FROM ORDERS_RAW
    WHERE
        ORDER_ID IS NULL
        OR CUSTOMER_ID IS NULL
        OR ORDER_TS IS NULL
        OR STATUS IS NULL
        OR CURRENCY IS NULL

    UNION ALL

    SELECT
        'ORDER_ID_UNIQUENESS' AS check_name,
        'ERROR' AS severity,
        'PASS' AS expected_result,
        IFF(COUNT(*) = COUNT(DISTINCT ORDER_ID), 'PASS', 'FAIL') AS actual_result,
        (COUNT(*) - COUNT(DISTINCT ORDER_ID))::VARCHAR AS observed_value,
        'Duplicate order ids are not expected in this raw sample.' AS notes
    FROM ORDERS_RAW

    UNION ALL

    SELECT
        'STATUS_DOMAIN_RAW' AS check_name,
        'WARN' AS severity,
        'PASS' AS expected_result,
        IFF(COUNT(*) = 0, 'PASS', 'FAIL') AS actual_result,
        COUNT(*)::VARCHAR AS observed_value,
        'Observed statuses should be within the currently known source domain.' AS notes
    FROM ORDERS_RAW
    WHERE STATUS NOT IN ('PLACED', 'SHIPPED', 'CANCELLED', 'RETURNED')

    UNION ALL

    SELECT
        'NUMERIC_TEXT_PARSEABLE' AS check_name,
        'ERROR' AS severity,
        'PASS' AS expected_result,
        IFF(COUNT(*) = 0, 'PASS', 'FAIL') AS actual_result,
        COUNT(*)::VARCHAR AS observed_value,
        'Amount fields should be parseable as numeric values before Silver casting.' AS notes
    FROM ORDERS_RAW
    WHERE
        TRY_TO_DECIMAL(GROSS_AMOUNT, 12, 2) IS NULL
        OR TRY_TO_DECIMAL(DISCOUNT_AMOUNT, 12, 2) IS NULL
        OR TRY_TO_DECIMAL(TAX_AMOUNT, 12, 2) IS NULL

    UNION ALL

    SELECT
        'TIMESTAMP_TEXT_PARSEABLE' AS check_name,
        'ERROR' AS severity,
        'PASS' AS expected_result,
        IFF(COUNT(*) = 0, 'PASS', 'FAIL') AS actual_result,
        COUNT(*)::VARCHAR AS observed_value,
        'Timestamp fields should be parseable before Silver casting.' AS notes
    FROM ORDERS_RAW
    WHERE
        TRY_TO_TIMESTAMP_NTZ(ORDER_TS) IS NULL
        OR TRY_TO_TIMESTAMP_NTZ(SOURCE_UPDATED_AT) IS NULL
)
SELECT
    check_name,
    severity,
    expected_result,
    actual_result,
    observed_value,
    notes
FROM validation_checks
ORDER BY
    IFF(actual_result = 'FAIL', 0, 1),
    IFF(severity = 'ERROR', 0, 1),
    check_name;
