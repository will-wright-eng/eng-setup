#* Variables
SHELL := /usr/bin/env bash

include .env

#* Setup
.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))
.DEFAULT_GOAL := help

help: ## list make commands
	@echo ${MAKEFILE_LIST}
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

#* Commands
install: setup-homebrew brew ## install homebrew and Brewfile packages

setup-homebrew: ## install homebrew
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval "$$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
	eval "$$(/opt/homebrew/bin/brew shellenv)"

#* Homebrew
brew: ## install taps, formulae, and casks from Brewfile
	brew bundle install --file=Brewfile --no-upgrade

brew-check: ## report Brewfile entries not yet installed
	brew bundle check --file=Brewfile --verbose

brew-cleanup: ## list installed packages not in Brewfile
	brew bundle cleanup --file=Brewfile

#* Ansible
check: ## run playbooks in check mode
	ansible-playbook ansible/main.yml -i "localhost," --check --diff
	ansible-playbook ansible/macos.yml -i "localhost," --check --diff

run: ## run playbooks, stopping before overwriting local changes
	ansible-playbook ansible/main.yml -i "localhost,"
	ansible-playbook ansible/macos.yml -i "localhost,"

#* Git
gitsetup: ## [git] setup git global configs
	git config --global user.name "$(GITHUB_USERNAME)"
	git config --global user.email "$(GITHUB_EMAIL)"

gitssh: ## [git] setup git ssh
	bash scripts/setup-github-ssh.sh "$(GITHUB_EMAIL)" "$(GITHUB_USERNAME)"

gitgpg: ## [git] setup git gpg
	bash scripts/setup-github-gpg.sh "$(GITHUB_EMAIL)" "$(GITHUB_USERNAME)"
