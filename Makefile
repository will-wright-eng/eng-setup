#* Variables
SHELL := /usr/bin/env bash
CURSOR_CLI := code

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

extensions: ## install browser extensions
	python3 scripts/browser-extensions.py

#* Cursor
cursor-export-extensions: ## [cursor] export extensions
	$(CURSOR_CLI) --list-extensions > configs/cursor-extensions.txt

cursor-import-extensions: ## [cursor] import extensions
	cat configs/cursor-extensions.txt -p | xargs -n 1 $(CURSOR_CLI) --install-extension

cursor-show-keybindings: ## [cursor] show keybindings
	cat "/Users/$(USER)/Library/Application Support/Cursor/User/keybindings.json"

cursor-export-keybindings: ## [cursor] export keybindings
	cat "/Users/$(USER)/Library/Application Support/Cursor/User/keybindings.json" > configs/cursor-keybindings.json

cursor-import-keybindings: ## [cursor] import keybindings
	cp configs/cursor-keybindings.json "/Users/$(USER)/Library/Application Support/Cursor/User/keybindings.json"

cursor: cursor-import-extensions cursor-import-keybindings ## [cursor] run import commands
