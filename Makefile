.PHONY: help init apply diff update status check install test clean backup restore

# Default target
.DEFAULT_GOAL := help

# Variables
CHEZMOI := chezmoi
SOURCE_DIR := $(HOME)/.local/share/chezmoi
CONFIG_DIR := $(HOME)/.config/chezmoi

help: ## Show this help message
	@echo "Dotfiles Management - Makefile Commands"
	@echo "========================================"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Initialize chezmoi (clone dotfiles repo)
	@echo "Initializing chezmoi..."
	@if [ -d "$(SOURCE_DIR)/.git" ]; then \
		echo "Dotfiles already initialized."; \
	else \
		echo "Enter your dotfiles repo URL:"; \
		read repo_url; \
		$(CHEZMOI) init $$repo_url; \
	fi

apply: ## Apply dotfiles changes to the system
	@echo "Applying dotfiles..."
	$(CHEZMOI) apply -v

apply-force: ## Force apply all dotfiles (overwrite changes)
	@echo "WARNING: This will overwrite any local changes!"
	@echo "Press Ctrl+C to cancel, or Enter to continue..."
	@read confirm
	$(CHEZMOI) apply --force

diff: ## Show differences between current state and dotfiles
	$(CHEZMOI) diff

update: ## Pull latest changes and apply
	@echo "Updating dotfiles from remote..."
	cd $(SOURCE_DIR) && git pull
	$(CHEZMOI) apply -v

status: ## Show chezmoi status
	$(CHEZMOI) status

check: ## Verify dotfiles without applying changes
	$(CHEZMOI) apply --dry-run --verbose

install: ## Install dependencies (Homebrew, packages)
	@echo "Installing dependencies..."
	@if [ "$$(uname)" = "Darwin" ]; then \
		if ! command -v brew >/dev/null 2>&1; then \
			echo "Installing Homebrew..."; \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		fi; \
		echo "Running package installation script..."; \
		$(CHEZMOI) apply --include scripts; \
	elif [ -f /etc/arch-release ]; then \
		echo "Running Arch Linux package installation..."; \
		$(CHEZMOI) apply --include scripts; \
	else \
		echo "Running Linux package installation..."; \
		$(CHEZMOI) apply --include scripts; \
	fi

test: ## Test dotfiles in dry-run mode
	@echo "Testing dotfiles (dry-run)..."
	$(CHEZMOI) apply --dry-run --verbose

edit: ## Edit a dotfile with chezmoi
	@echo "Enter filename to edit (e.g., .zshrc):"
	@read filename; \
	$(CHEZMOI) edit ~/$$filename

add: ## Add a file to chezmoi
	@echo "Enter file path to add (absolute or relative to ~):"
	@read filepath; \
	$(CHEZMOI) add ~/$$filepath

remove: ## Remove a file from chezmoi management
	@echo "Enter file to remove from chezmoi:"
	@read filename; \
	$(CHEZMOI) forget ~/$$filename

data: ## Show template data available to dotfiles
	$(CHEZMOI) data

verify: ## Verify all dotfiles are correctly applied
	$(CHEZMOI) verify

execute-template: ## Execute a template expression
	@echo "Enter template expression (e.g., {{ .chezmoi.os }}):"
	@read expr; \
	$(CHEZMOI) execute-template "$$expr"

cd: ## Change to chezmoi source directory
	@echo "Opening source directory..."
	cd $(SOURCE_DIR) && $$SHELL

git-status: ## Show git status in source directory
	@cd $(SOURCE_DIR) && git status

git-log: ## Show git log in source directory
	@cd $(SOURCE_DIR) && git log --oneline --graph --decorate -10

commit: ## Commit changes to dotfiles repo
	@echo "Enter commit message:"
	@read msg; \
	cd $(SOURCE_DIR) && git add -A && git commit -m "$$msg"

push: ## Push dotfiles changes to remote
	@cd $(SOURCE_DIR) && git push

pull: ## Pull latest dotfiles from remote
	@cd $(SOURCE_DIR) && git pull

backup: ## Backup current system configuration
	@echo "Creating backup..."
	@mkdir -p ~/dotfiles-backup-$$(date +%Y%m%d-%H%M%S)
	@cp -r ~/.config ~/dotfiles-backup-$$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
	@cp -r ~/.ssh ~/dotfiles-backup-$$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
	@echo "Backup created in ~/dotfiles-backup-$$(date +%Y%m%d-%H%M%S)"

clean: ## Clean chezmoi cache and temporary files
	@echo "Cleaning chezmoi cache..."
	rm -rf ~/.cache/chezmoi
	@echo "Cache cleaned."

doctor: ## Run chezmoi doctor to diagnose issues
	$(CHEZMOI) doctor

lint: ## Lint shell scripts in dotfiles
	@echo "Linting shell scripts..."
	@find $(SOURCE_DIR) -name "*.sh" -type f -exec shellcheck {} \; || echo "shellcheck not installed"

packages-darwin: ## Install macOS packages only
	@bash $(SOURCE_DIR)/run_onchange_before_install-packages-darwin.sh.tmpl

packages-linux: ## Install Linux packages only
	@bash $(SOURCE_DIR)/run_onchange_before_install-packages-linux.sh.tmpl

setup-ssh: ## Generate SSH keys
	@bash $(SOURCE_DIR)/run_once_after_02-generate-ssh-keys.sh.tmpl

setup-ohmyzsh: ## Install Oh My Zsh and Powerlevel10k
	@bash $(SOURCE_DIR)/run_once_after_01-install-ohmyzsh.sh.tmpl

docs: ## Open documentation
	@if [ -f "$(SOURCE_DIR)/README.md" ]; then \
		cat $(SOURCE_DIR)/README.md; \
	else \
		echo "No README found"; \
	fi

version: ## Show chezmoi and tool versions
	@echo "Chezmoi version:"
	$(CHEZMOI) --version
	@echo "\nGit version:"
	git --version
	@if command -v brew >/dev/null 2>&1; then \
		echo "\nHomebrew version:"; \
		brew --version; \
	fi
