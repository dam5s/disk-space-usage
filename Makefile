default: check

.PHONY: tasks
tasks: ## Print available tasks
	@printf "\nUsage: make [target]\n\n"
	@grep -E '^[a-z][^:]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: cyclic_dependency_checks/install
cyclic_dependency_checks/install: ## Fetch dependencies for cyclic_dependency_checks
	cd cyclic_dependency_checks; dart pub get

.PHONY: cyclic_dependency_checks/format
cyclic_dependency_checks/format: ## Format cyclic_dependency_checks code
	cd cyclic_dependency_checks; dart format lib --line-length 100 --set-exit-if-changed

.PHONY: cyclic_dependency_checks/test
cyclic_dependency_checks/test: ## Run cyclic_dependency_checks tests
	cd cyclic_dependency_checks; dart scripts/generate_big_codebase.dart; dart test

.PHONY: disk_space_usage/install
disk_space_usage/install: ## Fetch dependencies for disk_space_usage
	cd disk_space_usage; flutter pub get

.PHONY: disk_space_usage/format
disk_space_usage/format: ## Format disk_space_usage code
	cd disk_space_usage; dart format lib --line-length 100 --set-exit-if-changed

.PHONY: disk_space_usage/test
disk_space_usage/test: ## Run disk_space_usage tests
	cd disk_space_usage; flutter test

.PHONY: install
install: disk_space_usage/install cyclic_dependency_checks/install ## Fetch dependencies for all projects

.PHONY: format
format: disk_space_usage/format cyclic_dependency_checks/format ## Format all code

.PHONY: test
test: disk_space_usage/test cyclic_dependency_checks/test ## Run all tests

.PHONY: check-cycles
check-cycles: ## Test cyclic dependencies
	cd cyclic_dependency_checks; dart lib/main.dart ../disk_space_usage

.PHONY: check
check: format check-cycles test ## Check formatting, cycles and run tests
