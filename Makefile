#* Variables
SHELL := /usr/bin/env bash

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
	ansible-playbook ansible/main.yml -i "localhost,"
	ansible-playbook ansible/macos.yml -i "localhost,"

gitssh: ## setup git ssh
	bash scripts/setup-github-ssh.sh

cursor-export-extensions: ## export cursor extensions
	cursor --list-extensions > configs/cursor-extensions.txt

cursor-import-extensions: ## import cursor extensions
	cat configs/cursor-extensions.txt -p | xargs -n 1 cursor --install-extension

cursor-show-keybindings: ## show cursor keybindings
	cat "/Users/$(USER)/Library/Application Support/Cursor/User/keybindings.json"

cursor-export-keybindings: ## export cursor keybindings
	cat "/Users/$(USER)/Library/Application Support/Cursor/User/keybindings.json" > configs/cursor-keybindings.json

cursor-import-keybindings: ## import cursor keybindings
	cp configs/cursor-keybindings.json "/Users/$(USER)/Library/Application Support/Cursor/User/keybindings.json"

cursor: cursor-import-extensions cursor-import-keybindings ## setup cursor
