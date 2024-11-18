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
