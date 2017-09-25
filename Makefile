
.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

Gemfile.lock: ## Install required dependecies
	@which -s bundle || (echo 'bundler is required. "gem install bundler"' && false)
	bundle install

.PHONY: test
test: Gemfile.lock ## Run tests
	bundle exec rspec --format doc

.PHONY: dev
dev: Gemfile.lock ## Run the application locally in development mode
	RESTCLIENT_LOG=stdout bundle exec rackup

.PHONY: clean
clean: ## Clean up
	rm Gemfile.lock
