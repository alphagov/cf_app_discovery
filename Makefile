.DEFAULT_GOAL := help
SHELL := /bin/bash

.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: update-service-broker-staging
update-service-broker-staging:
	# Note: you need to be a cloud foundry admin to run this task
	scripts/update-service-broker.sh \
		prometheus-staging \
		prometheus-service-broker-staging \
		prometheus-service-broker-staging

.PHONY: update-service-broker-production
update-service-broker-production:
	# Note: you need to be a cloud foundry admin to run this task
	scripts/update-service-broker.sh \
		prometheus-production \
		prometheus-service-broker \
		prometheus-alpha

.PHONY: test
test: ## Run rspec tests
	rake
