-- =============================================================================
-- Step 3.4: DEV database access grants
-- Purpose: Grant least-privilege access to the DEV database and schemas.
-- Execution role: NACHO_PLATFORM_ADMIN
-- =============================================================================

USE ROLE NACHO_PLATFORM_ADMIN;

-- Database visibility. Without USAGE on the database, a role cannot resolve
-- schemas or objects inside it even if lower-level privileges exist.
GRANT USAGE
    ON DATABASE NACHO_DEV_DB
    TO ROLE NACHO_DATA_ENGINEER;

GRANT USAGE
    ON DATABASE NACHO_DEV_DB
    TO ROLE NACHO_DATA_ANALYST;

-- Data engineers can work across all medallion layers in DEV.
GRANT USAGE
    ON SCHEMA NACHO_DEV_DB.BRONZE
    TO ROLE NACHO_DATA_ENGINEER;

GRANT USAGE
    ON SCHEMA NACHO_DEV_DB.SILVER
    TO ROLE NACHO_DATA_ENGINEER;

GRANT USAGE
    ON SCHEMA NACHO_DEV_DB.GOLD
    TO ROLE NACHO_DATA_ENGINEER;

GRANT USAGE
    ON SCHEMA NACHO_DEV_DB.CONTROL
    TO ROLE NACHO_DATA_ENGINEER;

-- Object creation privileges for development engineering work.
-- These are intentionally granted only in DEV.
GRANT CREATE TABLE, CREATE VIEW, CREATE STAGE, CREATE FILE FORMAT
    ON SCHEMA NACHO_DEV_DB.BRONZE
    TO ROLE NACHO_DATA_ENGINEER;

GRANT CREATE TABLE, CREATE VIEW
    ON SCHEMA NACHO_DEV_DB.SILVER
    TO ROLE NACHO_DATA_ENGINEER;

GRANT CREATE TABLE, CREATE VIEW
    ON SCHEMA NACHO_DEV_DB.GOLD
    TO ROLE NACHO_DATA_ENGINEER;

GRANT CREATE TABLE, CREATE VIEW
    ON SCHEMA NACHO_DEV_DB.CONTROL
    TO ROLE NACHO_DATA_ENGINEER;

-- Analysts start with access only to the curated consumption layer.
-- SELECT on specific tables/views will be introduced when those objects exist.
GRANT USAGE
    ON SCHEMA NACHO_DEV_DB.GOLD
    TO ROLE NACHO_DATA_ANALYST;
