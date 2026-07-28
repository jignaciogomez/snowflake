# Orders CSV Contract

## Source

The first source dataset is a small order extract represented by:

```text
data/sample/orders_2026-07-01.csv
```

The second file, `data/sample/orders_2026-07-02.csv`, follows the same contract and is used to demonstrate incremental ingestion with audit logging.

The third file, `data/sample/orders_2026-07-03.csv`, follows the same contract and is used to demonstrate S3 external-stage ingestion.

## Format

| Property | Value |
|---|---|
| File type | CSV |
| Header row | Yes |
| Delimiter | Comma |
| Text enclosure | Optional double quote |
| Character encoding | UTF-8 |
| Null representation | Empty field |
| Compression | None for local sample files |

## Columns

| Column | Target interpretation | Notes |
|---|---|---|
| `order_id` | `VARCHAR` | Source natural key. |
| `customer_id` | `VARCHAR` | Source customer identifier. |
| `order_ts` | `TIMESTAMP_NTZ` | Business event timestamp. |
| `status` | `VARCHAR` | Order lifecycle status. |
| `currency` | `VARCHAR` | ISO-style currency code. |
| `gross_amount` | `NUMBER(12,2)` | Pre-discount gross amount. |
| `discount_amount` | `NUMBER(12,2)` | Discount applied to the order. |
| `tax_amount` | `NUMBER(12,2)` | Tax amount. |
| `source_updated_at` | `TIMESTAMP_NTZ` | Timestamp from the source system. |

## Design decision

The first ingestion format is CSV because it is common in batch integration and exposes important file-loading concepts clearly:

- header handling
- delimiters
- optional quoting
- empty-string-to-null behavior
- column count validation
- timestamp parsing
- load error handling

JSON and `VARIANT` ingestion are deferred intentionally. We will introduce semi-structured data after the first structured ingestion path is observable and tested.

## Enterprise recommendation

Treat every source file layout as a contract. Keep the contract versioned with the code, and do not rely on informal spreadsheet screenshots or tribal knowledge.

## Common production mistake

Assuming a CSV file is simple. CSV files fail in production because of unexpected delimiters, embedded commas, unescaped quotes, encoding changes, blank strings, extra columns, and inconsistent timestamp formats.
