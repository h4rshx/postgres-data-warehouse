#!/usr/bin/env bash
# Runs every .sql file under tests/ (or the folders you pass) as a data test.
#
# A test is one SELECT that returns the rows breaking a rule:
#   zero rows -> PASS     any rows -> FAIL     SQL error -> ERROR
# Exits 1 if anything fails or errors, so `make test` and CI go red.
#
# Usage:
#   scripts/run_tests.sh                       all tests, through the Docker container
#   scripts/run_tests.sh tests/food_delivery   one folder
#   PSQL=psql scripts/run_tests.sh ...         use a local psql instead (CI does this)
set -euo pipefail
cd "$(dirname "$0")/.."

if [ -f .env ]; then set -a; . ./.env; set +a; fi
PSQL=${PSQL:-"docker compose exec -T db psql -U ${POSTGRES_USER:-de} -d ${POSTGRES_DB:-warehouse}"}

# find + sort instead of bash 4's globstar, so this also runs on macOS's built-in bash 3.2
dirs=("${@:-tests}")
files=()
for d in "${dirs[@]}"; do
  while IFS= read -r f; do files+=("$f"); done < <(find "$d" -type f -name '*.sql' 2>/dev/null | sort)
done

if [ ${#files[@]} -eq 0 ]; then
  echo "No tests found in: ${dirs[*]} (rename an .sql.example file to .sql to start)"
  exit 0
fi

pass=0
fail=0
for t in "${files[@]}"; do
  # Wrap the test so psql prints only the number of offending rows.
  sql="SELECT count(*) FROM (
$(sed -e 's/;[[:space:]]*$//' "$t")
) AS bad_rows;"
  if out=$(printf '%s\n' "$sql" | $PSQL -X -q -A -t -v ON_ERROR_STOP=1 2>&1); then
    if [ "$out" = "0" ]; then
      echo "PASS   $t"
      pass=$((pass + 1))
    else
      echo "FAIL   $t  ($out bad rows)"
      fail=$((fail + 1))
    fi
  else
    echo "ERROR  $t"
    printf '%s\n' "$out" | sed 's/^/       /'
    fail=$((fail + 1))
  fi
done

echo
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
