# Design decisions

Short records of each choice between two reasonable designs, newest at the bottom. These are the answers to "why it is build this way?"

## Template

### D-00: Title

- **Date:**
- **Context:** what forced a choice
- **Options:** A, B (and C)
- **Decision:** what was chosen
- **Why:** 1 to 3 reasons
- **Consequence:** what this makes harder later

## Decisions still to make

| ID | Decision | When |
| --- | --- | --- |
| D-03 | Price snapshot in `order_items` plus a Type 2 price history table | 4 Nov |
| D-04 | Raw layer as all-text columns, with or without `loaded_at` | 9 Nov |
| D-05 | `dim_customer` keyed on `customer_unique_id`, not `customer_id` | 10 Nov |
| D-06 | Which duplicate review wins | 11 Nov |
| D-07 | One geolocation row per zip prefix: average or first row | 11 Nov |
| D-08 | Partition `fact_order_items` by year, not month | 12 Nov |
| D-09 | Full rebuild (truncate and reload) or incremental load | 19 Nov |

## Decisions made

### D-01: Key for order_items

- **Date:** 1 Nov 2026
- **Context:** Each order has one or more lines, and each line needs an identity.
- **Options:** A composite key `(order_id, line_no)`; or a generated `order_item_id` of its own.
- **Decision:** Composite primary key `(order_id, line_no)`.
- **Why:** A line has no meaning outside its order, so "line 2 of order 5001" is its natural identity. It also stops duplicate line numbers within an order without an extra constraint.
- **Consequence:** Any table that ever points to a single order line needs both columns in its foreign key.

### D-02: What happens when a row is deleted

- **Date:** 1 Nov 2026
- **Context:** Every foreign key needs a rule for what happens to child rows when the parent row is deleted.
- **Options:** RESTRICT (refuse the delete), CASCADE (delete the children too), SET NULL (keep the children, blank the link).
- **Decision:**

| Link | On delete |
| --- | --- |
| orders → customers, restaurants, riders | RESTRICT |
| menu_items → restaurants | RESTRICT |
| order_items → orders | CASCADE |
| order_items → menu_items | RESTRICT |
| history tables → their parent | CASCADE |

- **Why:** Orders and bills are financial records and must never disappear as a side effect. Order lines and history rows have no meaning without their parent, so they go with it.
- **Consequence:** Customers, restaurants, riders and dishes are never deleted in practice; they are deactivated with `is_active = false` or `is_available = false`.

### D-10: Fixed value lists as CHECK constraints

- **Date:** 1 Nov 2026
- **Context:** `restaurants.cuisine`, `riders.vehicle_type`, `menu_items.category` and `orders.status` only make sense with a small, known set of values.
- **Options:** A CHECK constraint listing the allowed values; or a separate lookup table (e.g. `cuisines`) with a foreign key.
- **Decision:** CHECK constraints.
- **Why:** The lists are short and rarely change. A CHECK stops spelling variants such as "Chinese" and "chinese" from splitting one group into two in reports, without an extra table and join.
- **Consequence:** Adding a new value means changing the schema (`ALTER TABLE`). If a list starts changing often, move it to a lookup table.

### D-11: Business time and system time on orders

- **Date:** 1 Nov 2026
- **Context:** An order has two different moments: when the customer placed it, and when its row was written into the database.
- **Options:** Keep only `placed_at`; or keep both `placed_at` and `created_at`.
- **Decision:** Keep both.
- **Why:** They differ whenever data arrives late: the seed script inserts orders placed months ago, but every row is created today. Analysis uses `placed_at`; debugging loads uses `created_at`.
- **Consequence:** Queries must use the right one. Revenue by day always uses `placed_at`.
