# Data dictionary

One section per table. Write the grain first: a table without a stated grain is not finished.

## food_delivery.customers

**Grain:** one row per customer.
**Built by:** `sql/food_delivery/01_schema.sql`, filled by `03_seed.sql`.

| Column | Type | Meaning | Rule or source |
| --- | --- | --- | --- |
| customer_id | bigint | Unique number for each customer | primary key, generated identity |
| name | text | Customer's full name | NOT NULL |
| email | text | Login email | NOT NULL, UNIQUE |
| phone | text | Mobile number with country code, e.g. +91… | NOT NULL, UNIQUE |
| city | text | City the customer orders in | NOT NULL |
| created_at | timestamptz | When the account was created | NOT NULL, default now() |


## food_delivery.orders

**Grain:** one row per order.
**Built by:** `sql/food_delivery/01_schema.sql`, filled by `03_seed.sql`.

| Column | Type | Meaning | Rule or source |
| --- | --- | --- | --- |
| order_id | bigint | Unique number for each order | primary key, generated identity |
| customer_id | bigint | Who placed the order | NOT NULL, foreign key to customers |
| restaurant_id | bigint | Restaurant the order is from | NOT NULL, foreign key to restaurants |
| rider_id | bigint | Rider who delivers the order; NULL until one is assigned | NULL allowed, foreign key to riders |
| status | text | current status of the order | NOT NULL, default 'placed'; one of: placed, accepted, picked_up, delivered, cancelled |
| placed_at | timestamptz | When the customer placed the order (business time) | NOT NULL , default now() |
| delivered_at | timestamptz | When the order was delivered | Filled if and only if status = 'delivered'; later than placed_at |
| created_at | timestamptz | When this row was written (system time) | NOT NULL, default now() |

## food_delivery.restaurants

**Grain:** one row per restaurant.
**Built by:** `sql/food_delivery/01_schema.sql`, filled by `03_seed.sql`.

| Column | Type | Meaning | Rule or source |
| --- | --- | --- | --- |
| restaurant_id | bigint | Unique number for each restaurant | primary key, generated identity |
| name | text | Restaurant's display name | NOT NULL |
| cuisine | text | Main cuisine served | NOT NULL; one of: north_indian, south_indian, chinese, italian, biryani, fast_food, desserts, cafe |
| city | text | City the restaurant operates in | NOT NULL |
| owner_login | text | Database login of the restaurant's owner, used by row-level security | NOT NULL, UNIQUE |
| is_active | boolean | Whether it currently accepts orders | NOT NULL, default true |
| created_at | timestamptz | When this row was written | NOT NULL, default now() |

## food_delivery.menu_items

**Grain:** one row per dish on a restaurant's menu.
**Built by:** `sql/food_delivery/01_schema.sql`, filled by `03_seed.sql`.

| Column | Type | Meaning | Rule or source |
| --- | --- | --- | --- |
| menu_item_id | bigint | Unique number for each dish | primary key, generated identity |
| restaurant_id | bigint | Restaurant that sells this dish | NOT NULL, foreign key to restaurants |
| name | text | Dish name, e.g. Paneer Tikka | NOT NULL; unique together with restaurant_id |
| category | text | Section of the menu | NOT NULL; one of: starter, main, side, dessert, beverage |
| is_veg | boolean | Vegetarian dish or not | NOT NULL |
| price | numeric(8,2) | Current price in rupees | NOT NULL, greater than 0 |
| is_available | boolean | Whether it can be ordered right now | NOT NULL, default true |
| created_at | timestamptz | When this row was written | NOT NULL, default now() |

## food_delivery.riders

**Grain:** one row per delivery rider.
**Built by:** `sql/food_delivery/01_schema.sql`, filled by `03_seed.sql`.

| Column | Type | Meaning | Rule or source |
| --- | --- | --- | --- |
| rider_id | bigint | Unique number for each rider | primary key, generated identity |
| name | text | Rider's full name | NOT NULL |
| phone | text | Mobile number with country code | NOT NULL, UNIQUE |
| city | text | City the rider delivers in | NOT NULL |
| vehicle_type | text | What the rider delivers on | NOT NULL; one of: bicycle, bike, scooter, ev_scooter |
| is_active | boolean | Whether the rider is currently working with the platform | NOT NULL, default true |
| created_at | timestamptz | When this row was written | NOT NULL, default now() |

## food_delivery.order_items

**Grain:** one row per dish in an order.
**Built by:** `sql/food_delivery/01_schema.sql`, filled by `03_seed.sql`.

| Column | Type | Meaning | Rule or source |
| --- | --- | --- | --- |
| order_id | bigint | Order this line belongs to | NOT NULL, foreign key to orders; part of primary key |
| line_no | smallint | Position of the line within the order: 1, 2, 3… | NOT NULL, greater than 0; part of primary key |
| menu_item_id | bigint | Dish ordered | NOT NULL, foreign key to menu_items |
| quantity | integer | How many of this dish | NOT NULL, greater than 0 |
| unit_price | numeric(8,2) | Price of one unit at the moment of ordering, copied from menu_items | NOT NULL, greater than 0 |

Table rules: primary key (order_id, line_no); each dish appears at most once per order, so (order_id, menu_item_id) is UNIQUE.

## food_delivery.menu_price_history

**Grain:** one row per period during which a dish had one price.
**Built by:** `sql/food_delivery/01_schema.sql`, filled by the price trigger in `02_history_triggers.sql`.

| Column | Type | Meaning | Rule or source |
| --- | --- | --- | --- |
| price_history_id | bigint | Unique number for each price period | primary key, generated identity |
| menu_item_id | bigint | Dish this price belongs to | NOT NULL, foreign key to menu_items |
| price | numeric(8,2) | Price during this period | NOT NULL, greater than 0 |
| valid_from | timestamptz | When this price started | NOT NULL |
| valid_to | timestamptz | When this price ended; NULL while still current | later than valid_from |
| is_current | boolean | Whether this is today's price | NOT NULL; true if and only if valid_to is NULL |

Table rule: at most one row with is_current = true per menu_item_id (a partial unique index).

## food_delivery.order_status_history

**Grain:** one row per status change of an order.
**Built by:** `sql/food_delivery/01_schema.sql`, filled by the status trigger in `02_history_triggers.sql`.

| Column | Type | Meaning | Rule or source |
| --- | --- | --- | --- |
| status_change_id | bigint | Unique number for each change | primary key, generated identity |
| order_id | bigint | Order whose status changed | NOT NULL, foreign key to orders |
| old_status | text | Status before the change; NULL for the first row, when the order is created | same allowed values as orders.status |
| new_status | text | Status after the change | NOT NULL; same allowed values as orders.status |
| changed_at | timestamptz | When the change happened | NOT NULL, default now() |

