-- =============================================================================
-- Step 2.3: Transition the project owner to the custom platform role
-- Purpose: Grant the minimum account-level provisioning capabilities required
--          for the next step, then make NACHO_PLATFORM_ADMIN the user's default.
-- Execution role: ACCOUNTADMIN (temporary bootstrap role)
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- Required to create the project's first database and dedicated warehouse.
-- No security, user-management, integration, or grant-management privileges
-- are included here.
GRANT CREATE DATABASE ON ACCOUNT TO ROLE NACHO_PLATFORM_ADMIN;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE NACHO_PLATFORM_ADMIN;

-- Assign the custom daily-working role to the existing project owner.
GRANT ROLE NACHO_PLATFORM_ADMIN TO USER JIGNACIOGOMEZR;

-- New CLI/Snowsight sessions now begin with the least-privileged role that can
-- perform the project's next platform-provisioning task.
ALTER USER JIGNACIOGOMEZR SET DEFAULT_ROLE = NACHO_PLATFORM_ADMIN;

-- ACCOUNTADMIN is intentionally not revoked in this learning bootstrap.
-- It remains a break-glass role and must not be used for routine work.
