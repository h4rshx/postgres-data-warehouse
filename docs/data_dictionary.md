# Data dictionary

One section per table. Write the grain first: a table without a stated grain is not finished.

## food_delivery.orders

**Grain:** one row per order.
**Built by:** `sql/food_delivery/01_schema.sql`, filled by `03_seed.sql`.

| Column | Type | Meaning | Rule or source |
| --- | --- | --- | --- |
| order_id | | | primary key |
| customer_id | | | foreign key to customers |
| status | | | one of: placed, accepted, picked_up, delivered, cancelled |
| placed_at | | | |
| delivered_at | | | NULL unless delivered; later than placed_at |

<!-- Copy the block above for every table in food_delivery, staging, dw and mart.
For staging tables, add a line: "Rows vs raw: X vs Y, because ..." -->
