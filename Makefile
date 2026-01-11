#* Variables
SHELL := /usr/bin/env bash
CURSOR_CLI := cursor

include .env

#* Setup
.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))
.DEFAULT_GOAL := help

help: ## list make commands
	@echo ${MAKEFILE_LIST}
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

#* Commands
install: setup-homebrew setup-apps ## install homebrew and apps

setup-homebrew: ## install homebrew
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval "$$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
	eval "$$(/opt/homebrew/bin/brew shellenv)"

setup-apps: ## install apps
	brew install ansible

#* Ansible
check: ## run playbooks in check mode
	ansible-playbook ansible/main.yml -i "localhost," --check --diff
	ansible-playbook ansible/macos.yml -i "localhost," --check --diff

run: ## run playbooks normally
	ansible-playbook ansible/main.yml -i "localhost," || true
	ansible-playbook ansible/macos.yml -i "localhost," || true

#* Scripts
gitssh: ## setup git ssh
	bash scripts/setup-github-ssh.sh

extensions-download: ## download browser extension CRX files
	bash scripts/download-extensions.sh

extensions-extract: ## extract CRX files to unpacked extensions
	@REPO_ROOT=$$(git rev-parse --show-toplevel); \
	EXT_DIR="$$REPO_ROOT/extensions"; \
	echo "Extracting CRX files..."; \
	for crx in $$EXT_DIR/*.crx; do \
		if [ -f "$$crx" ]; then \
			base=$$(basename "$$crx" .crx); \
			extract_dir="$$EXT_DIR/$$base"; \
			echo "Extracting $$(basename $$crx) to $$base/..."; \
			mkdir -p "$$extract_dir"; \
			bash scripts/extract-crx.sh "$$crx" "$$extract_dir" && \
			echo "✓ Extracted to $$extract_dir/" || \
			echo "✗ Failed to extract $$(basename $$crx)"; \
		fi; \
	done; \
	echo ""; \
	echo "✓ All extensions extracted successfully!"; \
	echo ""; \
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
	echo "📦 Instructions for adding unpacked extensions to Ungoogled Chromium:"; \
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
	echo ""; \
	echo "1. Open Ungoogled Chromium"; \
	echo "2. Navigate to: chrome://extensions/"; \
	echo "3. Enable 'Developer mode' (toggle in top-right corner)"; \
	echo "4. Click 'Load unpacked' button"; \
	echo "5. Select one of the following directories:"; \
	echo ""; \
	for crx in $$EXT_DIR/*.crx; do \
		if [ -f "$$crx" ]; then \
			base=$$(basename "$$crx" .crx); \
			echo "   • $$EXT_DIR/$$base"; \
		fi; \
	done; \
	echo ""; \
	echo "6. Repeat steps 4-5 for each extension you want to install"; \
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

extensions: extensions-download extensions-extract ## download and extract browser extensions

#* Cursor
cursor-export-extensions: ## [cursor] export extensions
	$(CURSOR_CLI) --list-extensions > configs/cursor-extensions.txt

cursor-import-extensions: ## [cursor] import extensions
	/bin/cat configs/cursor-extensions.txt | xargs -n 1 $(CURSOR_CLI) --install-extension

cursor-show-keybindings: ## [cursor] show keybindings
	cat "/Users/$(USER)/Library/Application Support/Cursor/User/keybindings.json"

cursor-export-keybindings: ## [cursor] export keybindings
	cat "/Users/$(USER)/Library/Application Support/Cursor/User/keybindings.json" > configs/cursor-keybindings.json

cursor-import-keybindings: ## [cursor] import keybindings
	cp configs/cursor-keybindings.json "/Users/$(USER)/Library/Application Support/Cursor/User/keybindings.json"

cursor: cursor-import-extensions cursor-import-keybindings ## [cursor] run import commands

#* Git
gitsetup: ## [git] setup git global configs
	git config --global user.name "$(GITHUB_USERNAME)"
	git config --global user.email "$(GITHUB_EMAIL)"
