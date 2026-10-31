# Postgres Data Warehouse

<!-- TEMPLATE: replace every comment and placeholder, then delete this line. -->

> One line on what this is and what it proves. Example: *A food-delivery OLTP database and a star-schema warehouse over 100k real e-commerce orders, built, loaded and tested with one command.*

<!-- After the CI stretch item, add the badge:
![CI](https://github.com/<you>/postgres-data-warehouse/actions/workflows/ci.yml/badge.svg) -->

## Architecture

![Architecture](docs/architecture.png)

<!-- 2 to 3 sentences: the two sources, the layers, and the test gate. -->

## Quick start

```bash
cp .env.example .env    # then set a password in .env
# put the Olist CSVs in data/ (see data/README.md)
make all                # start Postgres, build, load, test
```

Connect with DBeaver or psql at `localhost:5433` using the user and database from `.env`. `make` lists every command.

## Part A: food-delivery database

![Food-delivery ERD](docs/erd_food_delivery.png)

<!-- One line each:
- why order_items copies the price (and the Type 2 price history)
- the status audit trail trigger
- row-level security for restaurant owners -->

Queries: [queries/food_delivery](queries/food_delivery) · catalog: [docs/query_catalog.md](docs/query_catalog.md)

## Part B: Olist warehouse

![Olist star schema](docs/erd_olist_star.png)

| Layer | What it holds |
| --- | --- |
| `raw` | <!-- one line --> |
| `staging` | <!-- one line --> |
| `dw` | <!-- facts and dims, with grain --> |
| `mart` | <!-- the business views --> |

**Data issues found:** <!-- 3 to 5 bullets: the issue, how staging handles it -->

## Results

<!-- 3 findings with real numbers from your queries, each linking its .sql file. -->

## Tests

<!-- How many tests, what they check, and the summary line from `make test`. -->

## Performance

<!-- One before/after example in one line; link docs/performance.md. -->

## What I would change at 100x the data

<!-- 3 to 5 bullets, e.g. incremental loads with a watermark, monthly partitions,
a columnar warehouse, an orchestrator, dbt for the staging and mart layers. -->

## Docs

- [Data dictionary](docs/data_dictionary.md)
- [Design decisions](docs/decisions.md)
- [Query catalog](docs/query_catalog.md)
- [Performance report](docs/performance.md)
