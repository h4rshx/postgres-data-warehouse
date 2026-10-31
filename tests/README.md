# Data tests

Each `.sql` file is one test: a single `SELECT` that returns the rows breaking a rule. `make test` runs them all; zero rows means pass, and any row fails the build.

The two `.sql.example` files show the pattern. Rename one to `.sql` once the tables it reads exist.

## Test ideas

**Part A (`tests/food_delivery/`)**

- Every order has at least one order item.
- A delivered order has `delivered_at` after `placed_at`.
- Every order has a status history row matching its current status.
- No menu item has more than one current price.
- No rider is assigned to a cancelled order that was never accepted.

**Part B (`tests/olist/`)**

- Each fact table has no duplicate rows at its grain.
- Every fact row's keys find a row in each dimension.
- Total price in `fact_order_items` equals the total in staging.
- `dim_date` has no missing days between its first and last date.
- No negative prices, freight values or delivery days.
- Review scores are between 1 and 5.
- No staging table has more rows than its raw table.
- Every order in `fact_orders` appears in `fact_order_items`, unless it has no items in the source.
