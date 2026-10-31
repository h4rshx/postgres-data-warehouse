#!/usr/bin/env bash
# load_olist.sh: load the 9 Olist CSVs from data/ into the raw schema.
# You write this on Thu 19 Nov (M1 Daily Tracker). Until then, load by hand in psql (`make psql`).
#
# Requirements
#   [ ] stop on the first error: set -euo pipefail
#   [ ] read POSTGRES_USER and POSTGRES_DB from .env, the way scripts/run_tests.sh does
#   [ ] for each CSV, work out its raw table name from the file name
#   [ ] truncate the raw table before loading, so a rerun gives the same row count
#   [ ] load with \copy ... CSV HEADER; psql runs inside the container, where data/ is /data
#   [ ] count rows loaded and time each table
#   [ ] insert one row per table into meta.etl_run_log: table, rows, start, finish, status
#   [ ] if a table fails, still log it with status 'failed', then exit non-zero
#       (look up `trap ... ERR` in bash)
#   [ ] print one summary line per table
#
# The 9 files: olist_*_dataset.csv (8 files) and product_category_name_translation.csv.

echo "load_olist.sh is not written yet (planned for 19 Nov); load the CSVs by hand for now." >&2
exit 0
