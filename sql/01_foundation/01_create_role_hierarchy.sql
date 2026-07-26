-- =============================================================================
-- Step 2.2: Enterprise RBAC foundation
-- Purpose: Create project account roles and their inheritance hierarchy only.
-- Execution role: ACCOUNTADMIN (temporary bootstrap role)
-- Safety: CREATE ROLE IF NOT EXISTS is idempotent. Do not use CREATE OR REPLACE
--         for roles because replacement can remove grants.
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- Functional roles. Privileges are intentionally assigned in later, focused steps.
CREATE ROLE IF NOT EXISTS NACHO_SECURITY_ADMIN
    COMMENT = 'Manages project security grants and role assignments; no daily data work.';

CREATE ROLE IF NOT EXISTS NACHO_PLATFORM_ADMIN
    COMMENT = 'Owns and administers project platform objects and shared infrastructure.';

CREATE ROLE IF NOT EXISTS NACHO_DATA_ENGINEER
    COMMENT = 'Builds and operates project data pipelines and transformations.';

CREATE ROLE IF NOT EXISTS NACHO_DATA_ANALYST
    COMMENT = 'Consumes approved project data products for analysis.';

CREATE ROLE IF NOT EXISTS NACHO_CICD_DEPLOYER
    COMMENT = 'Non-human deployment role; environment-specific privileges added later.';

-- Role hierarchy: a parent role inherits the privileges of its child role.
-- Analysts are the least-privileged functional users; engineers inherit read access.
GRANT ROLE NACHO_DATA_ANALYST TO ROLE NACHO_DATA_ENGINEER;
GRANT ROLE NACHO_DATA_ENGINEER TO ROLE NACHO_PLATFORM_ADMIN;

-- Anchor platform roles beneath Snowflake's built-in administrative roles.
-- This preserves emergency administration while keeping project permissions custom.
GRANT ROLE NACHO_PLATFORM_ADMIN TO ROLE SYSADMIN;
GRANT ROLE NACHO_CICD_DEPLOYER TO ROLE SYSADMIN;
GRANT ROLE NACHO_SECURITY_ADMIN TO ROLE SECURITYADMIN;

-- No users, databases, warehouses, or object privileges are created in this step.
