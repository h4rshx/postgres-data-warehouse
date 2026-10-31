# Project 0 commands. Run `make` or `make help` to list them.
-include .env
export

DC   := docker compose
PSQL := $(DC) exec -T db psql -X -q -v ON_ERROR_STOP=1 -U $(POSTGRES_USER) -d $(POSTGRES_DB)

.DEFAULT_GOAL := help
.PHONY: help up down reset psql food raw load olist test all

help: ## List commands
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-6s %s\n", $$1, $$2}'

up: ## Start Postgres and wait until it is healthy
	$(DC) up -d --wait

down: ## Stop Postgres (data is kept)
	$(DC) down

reset: ## Stop Postgres and DELETE all of its data
	$(DC) down -v

psql: ## Open a psql shell inside the database
	$(DC) exec db psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

food: ## Build Part A: run sql/food_delivery/*.sql in order
	@for f in sql/food_delivery/*.sql; do echo "-> $$f"; $(PSQL) < $$f || exit 1; done

raw: ## Part B step 1: create the meta and raw schemas (00_*, 01_*)
	@for f in sql/olist/0[01]_*.sql; do echo "-> $$f"; $(PSQL) < $$f || exit 1; done

load: ## Part B step 2: load the Olist CSVs into raw
	./scripts/load_olist.sh

olist: ## Part B step 3: build staging, dw and mart (02_* onward)
	@for f in sql/olist/0[2-9]_*.sql; do echo "-> $$f"; $(PSQL) < $$f || exit 1; done

test: ## Run every test in tests/
	./scripts/run_tests.sh

all: up food raw load olist test ## Rebuild everything from scratch, then test it
