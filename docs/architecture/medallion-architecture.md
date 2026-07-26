# DEV Medallion Architecture

## Database boundary

`NACHO_DEV_DB` is the first environment-specific database. `QA` and `PROD` databases are intentionally deferred until the environment-promotion strategy is introduced.

## Schema responsibilities

| Schema | Purpose | Data treatment |
|---|---|---|
| `BRONZE` | Raw landing layer | Preserve source fidelity; append load metadata; avoid business transformations. |
| `SILVER` | Conformed layer | Validate, parse, deduplicate, standardize, and apply business rules. |
| `GOLD` | Consumption layer | Publish dimensional models, facts, dimensions, and governed analytical products. |
| `CONTROL` | Operational layer | Store load audit records, data-quality results, and pipeline-control metadata. |

## Why schemas instead of separate databases per layer?

For a small, single-domain project, one database per environment with layer-specific schemas is the enterprise-recommended balance. It keeps environment isolation strong while allowing simple, governed cross-layer transformations inside a database.

A separate database for every layer can be appropriate when layers have different owners, retention rules, or sharing boundaries, but it increases grant complexity and operational overhead.

## Ownership

`NACHO_PLATFORM_ADMIN` creates and owns the DEV database and schemas. Data-engineering, analyst, and CI/CD access is granted later, after the relevant warehouse and consumer workflow exist.
