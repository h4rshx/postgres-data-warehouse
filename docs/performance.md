# Performance report

**Setup:** <!-- laptop CPU and RAM --> · Postgres 17 in Docker · `fact_order_items`: <!-- row count --> rows
**Method:** each time is the median of 3 runs of `EXPLAIN (ANALYZE, BUFFERS)`.

## Q1: <!-- business question -->

- **File:** `queries/olist/...`
- **Before:** ___ ms · key plan line: <!-- e.g. Seq Scan on fact_order_items -->
- **Change:** <!-- index, rewrite or partition -->
- **After:** ___ ms · key plan line: <!-- e.g. Index Scan using ... -->
- **Why it helped:** <!-- one sentence -->

<!-- Repeat for Q2 and Q3. -->

## Partition pruning

<!-- A query filtered to one year: which partitions the plan reads, with and without the filter.
At about 100k rows the speed gain is small; say so, and explain why pruning matters at 100 million. -->
