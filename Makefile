default: check

.PHONY: tasks
tasks: ## Print available tasks
	@printf "\nUsage: make [target]\n\n"
	@grep -E '^[a-z][^:]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: format
format: ## Format code
	dart format lib --line-length 100 --set-exit-if-changed

.PHONY: test
test: ## Run tests
	flutter test

.PHONY: check-cycles
check-cycles: ## Test cyclic dependencies
	dart scripts/check_import_cycles.dart

.PHONY: check
check: format check-cycles test ## Check formatting, cycles and run tests
