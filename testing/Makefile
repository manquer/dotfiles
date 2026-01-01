.PHONY: help build up down clean test run check shell logs verify lint

# Default target
.DEFAULT_GOAL := help

# Variables
DOCKER_COMPOSE := docker-compose
ANSIBLE_CONTAINER := dotfiles-ansible-control
PLAYBOOK := playbooks/test-dotfiles.yml
INVENTORY := inventories/hosts.yml

help: ## Show this help message
	@echo "Dotfiles Testing - Makefile Commands"
	@echo "===================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build the Ansible control container
	$(DOCKER_COMPOSE) build $(ANSIBLE_CONTAINER)

up: ## Start Arch Linux test container
	$(DOCKER_COMPOSE) up -d target-arch
	@echo "Waiting for container to be ready..."
	@sleep 5

down: ## Stop and remove all containers
	$(DOCKER_COMPOSE) down

clean: ## Remove all containers, volumes, and images
	$(DOCKER_COMPOSE) down -v --rmi all
	rm -rf logs/*.log logs/ansible_facts

test: up ## Run dotfiles test playbook (dry run)
	$(DOCKER_COMPOSE) run --rm $(ANSIBLE_CONTAINER) ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --check

run: up ## Run dotfiles test playbook
	$(DOCKER_COMPOSE) run --rm $(ANSIBLE_CONTAINER) ansible-playbook $(PLAYBOOK) -i $(INVENTORY)

check: ## Check connectivity to all test hosts
	$(DOCKER_COMPOSE) run --rm $(ANSIBLE_CONTAINER) ansible all -m ping -i $(INVENTORY)

shell: ## Open interactive shell in Ansible control container
	$(DOCKER_COMPOSE) run --rm $(ANSIBLE_CONTAINER) /bin/bash

logs: ## Show logs from all containers
	$(DOCKER_COMPOSE) logs -f

verify: ## Verify test results
	@echo "Checking test reports..."
	@if [ -f /tmp/dotfiles-test-report-target-ubuntu.txt ]; then \
		echo "\n=== Ubuntu Test Report ==="; \
		cat /tmp/dotfiles-test-report-target-ubuntu.txt; \
	fi
	@if [ -f /tmp/dotfiles-test-report-target-debian.txt ]; then \
		echo "\n=== Debian Test Report ==="; \
		cat /tmp/dotfiles-test-report-target-debian.txt; \
	fi
	@if [ -f /tmp/dotfiles-test-report-target-arch.txt ]; then \
		echo "\n=== Arch Test Report ==="; \
		cat /tmp/dotfiles-test-report-target-arch.txt; \
	fi

lint: ## Lint the playbook with ansible-lint
	$(DOCKER_COMPOSE) run --rm $(ANSIBLE_CONTAINER) ansible-lint $(PLAYBOOK) || true

syntax: ## Check playbook syntax
	$(DOCKER_COMPOSE) run --rm $(ANSIBLE_CONTAINER) ansible-playbook $(PLAYBOOK) --syntax-check

facts: ## Gather facts from all hosts
	$(DOCKER_COMPOSE) run --rm $(ANSIBLE_CONTAINER) ansible all -m setup -i $(INVENTORY)

version: ## Show Ansible version
	$(DOCKER_COMPOSE) run --rm $(ANSIBLE_CONTAINER) ansible --version

# Target-specific commands
test-arch: up ## Run test on Arch Linux
	$(DOCKER_COMPOSE) run --rm $(ANSIBLE_CONTAINER) ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -l target-arch

test-linux: test-arch ## Alias for test-arch

test-macos: ## Run test on macOS (requires Tart VM running)
	@echo "Testing on macOS..."
	@if ! command -v tart &> /dev/null; then \
		echo "Error: Tart not installed. Install with: brew install cirruslabs/cli/tart"; \
		exit 1; \
	fi
	@echo "Ensure macOS VM is running (see testing/macos/README.md)"
	$(DOCKER_COMPOSE) run --rm $(ANSIBLE_CONTAINER) ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -l target-macos

# Full test workflow
full-test: build up run verify ## Build, start containers, run tests, and show results
	@echo "\n========================================"
	@echo "Full test workflow completed!"
	@echo "========================================"
