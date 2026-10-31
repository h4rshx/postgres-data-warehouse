# Design decisions

Short records of each choice between two reasonable designs, newest at the bottom. These are your answers to "why did you build it this way?"

## Template

### D-00: Title

- **Date:**
- **Context:** what forced a choice
- **Options:** A, B (and C)
- **Decision:** what you chose
- **Why:** 1 to 3 reasons
- **Consequence:** what this makes harder later

## Decisions you will face

Fill each one in when you reach it, using the template.

| ID | Decision | When |
| --- | --- | --- |
| D-01 | `order_items` key: composite `(order_id, line_no)` or a surrogate id | 4 Nov |
| D-02 | `ON DELETE` behaviour for orders and order items | 4 Nov |
| D-03 | Price snapshot in `order_items` plus a Type 2 price history table | 4 Nov |
| D-04 | Raw layer as all-text columns, with or without `loaded_at` | 9 Nov |
| D-05 | `dim_customer` keyed on `customer_unique_id`, not `customer_id` | 10 Nov |
| D-06 | Which duplicate review wins | 11 Nov |
| D-07 | One geolocation row per zip prefix: average or first row | 11 Nov |
| D-08 | Partition `fact_order_items` by year, not month | 12 Nov |
| D-09 | Full rebuild (truncate and reload) or incremental load | 19 Nov |
