# Bronze Validation Strategy

## Purpose

The first Bronze validation script checks whether `NACHO_DEV_DB.BRONZE.ORDERS_RAW` is suitable for downstream Silver transformation.

The script does not transform data. It only reports evidence.

## Checks

| Check | Severity | Purpose |
|---|---|---|
| `ROW_COUNT_TOTAL` | `ERROR` | Confirms both sample files loaded completely. |
| `FILE_COUNT` | `ERROR` | Confirms Bronze contains two distinct source files. |
| `REQUIRED_FIELDS_NOT_NULL` | `ERROR` | Detects missing required source fields. |
| `ORDER_ID_UNIQUENESS` | `ERROR` | Detects duplicate source order identifiers in the sample. |
| `STATUS_DOMAIN_RAW` | `WARN` | Detects unexpected source status values. |
| `NUMERIC_TEXT_PARSEABLE` | `ERROR` | Confirms amount fields can be cast later in Silver. |
| `TIMESTAMP_TEXT_PARSEABLE` | `ERROR` | Confirms timestamp fields can be cast later in Silver. |

## Why validate Bronze?

Bronze preserves raw data, but that does not mean we ignore quality. Raw-layer validation answers a different question:

```text
Did the source file land completely and is it structurally usable?
```

Silver validation later answers:

```text
Did the data conform to business and analytical rules?
```

## Enterprise recommendation

Keep Bronze checks focused on ingestion integrity, source completeness, basic parseability, and lineage metadata. Save business rules and conforming logic for Silver.

## Simpler alternative

Skip Bronze validation and wait for Silver transformations to fail.

That is simpler, but it delays detection and makes debugging harder because the failure appears farther away from the source file.

## Common production mistake

Treating every validation failure the same. A row-count mismatch may be a hard stop, while a new source status may be a warning that requires domain review.
