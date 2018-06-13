.DEFAULT_GOAL := help
SHELL := /bin/bash

.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: staging
staging: ## Deploy to prometheus-staging
	cf target -s prometheus-staging
	cf push -f manifest-staging.yml

.PHONY: production
production: ## Deploy to prometheus-production
	cf target -s prometheus-production
	cf push -f manifest-production.yml
