# Cost Governance

## DEV resource monitor

`NACHO_DEV_RM` is the monthly credit guardrail for the development warehouse.

| Setting | Value | Reason |
|---|---:|---|
| `CREDIT_QUOTA` | `10` credits | Small monthly cap for controlled learning and development. |
| `FREQUENCY` | `MONTHLY` | Resets usage tracking each month. |
| `50%` trigger | `NOTIFY` | Early signal that development activity is consuming credits. |
| `80%` trigger | `NOTIFY` | Stronger signal before compute is suspended. |
| `100%` trigger | `SUSPEND` | Prevents new queries on the assigned warehouse after the quota is reached. |

## Why resource monitors exist

Snowflake warehouses consume credits while running. Auto-suspend reduces idle waste, but it does not protect against legitimate queries that run too long or too often.

Resource monitors solve that problem by tracking credit usage and applying actions when usage reaches configured thresholds.

## Warehouse-level versus account-level monitors

For this project, the monitor is attached only to `NACHO_DEV_WH`.

| Monitor scope | Use case |
|---|---|
| Warehouse-level | Best when you want workload-specific limits, such as DEV, ETL, BI, or experimentation. |
| Account-level | Best as a global safety net across all warehouses in the account. |

In enterprise environments, both are common: an account-level monitor provides the hard outer boundary, and warehouse-level monitors provide chargeback and workload-specific control.

## Production note

The `10` credit quota is intentionally conservative for this learning project. In production, quotas should be based on workload forecasts, historical query patterns, service-level requirements, and agreed FinOps budgets.
