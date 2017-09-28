
.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

Gemfile.lock: ## Install required dependecies
	@which -s bundle || (echo 'bundler is required. "gem install bundler"' && false)
	bundle install

public/screen.css: sass/screen.scss ## compile stylesheeets
	npm install
	./node_modules/.bin/node-sass \
		--output-style compressed \
		--include-path node_modules/govuk-elements-sass/public/sass \
		--include-path node_modules/govuk_frontend_toolkit/stylesheets \
		$< > $@
	

.PHONY: test
test: Gemfile.lock ## Run tests
	bundle exec rspec --format doc

.PHONY: dev
dev: Gemfile.lock public/screen.css ## Run the application locally in development mode
	RESTCLIENT_LOG=stdout bundle exec rackup

.PHONY: clean
clean: ## Clean up
	rm Gemfile.lock
