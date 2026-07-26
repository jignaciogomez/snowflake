-- =============================================================================
-- Step 3.1: DEV database and medallion schemas
-- Purpose: Create the logical storage boundary for the project's DEV environment.
-- Execution role: NACHO_PLATFORM_ADMIN
-- =============================================================================

USE ROLE NACHO_PLATFORM_ADMIN;

CREATE DATABASE IF NOT EXISTS NACHO_DEV_DB
    COMMENT = 'Development database for the NACHO Snowflake data platform.';

CREATE SCHEMA IF NOT EXISTS NACHO_DEV_DB.BRONZE
    COMMENT = 'Raw, append-oriented ingestion layer. Source fidelity is preserved.';

CREATE SCHEMA IF NOT EXISTS NACHO_DEV_DB.SILVER
    COMMENT = 'Validated, standardized, and deduplicated transformation layer.';

CREATE SCHEMA IF NOT EXISTS NACHO_DEV_DB.GOLD
    COMMENT = 'Curated analytics layer containing dimensional data products.';

CREATE SCHEMA IF NOT EXISTS NACHO_DEV_DB.CONTROL
    COMMENT = 'Operational metadata, load audit, and data-quality control objects.';

-- The creating role owns the database and schemas. Grants to engineering,
-- analytics, and automation roles are introduced only when each consumer exists.
