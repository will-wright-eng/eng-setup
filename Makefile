.PHONY: install check run setup-homebrew setup-ansible setup-secrets help

# Default target when just running 'make'
help:
	@echo "Available targets:"
	@echo "  install         - Install Homebrew and Ansible"
	@echo "  check          - Run playbooks in check mode"
	@echo "  run            - Run playbooks in normal mode"
	@echo "  setup-homebrew - Install Homebrew only"
	@echo "  setup-ansible  - Install Ansible only"

# Install both Homebrew and Ansible
install: setup-homebrew setup-ansible

# Setup Homebrew
setup-homebrew:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval "$$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
	eval "$$(/opt/homebrew/bin/brew shellenv)"

# Setup Ansible
setup-ansible:
	brew install ansible make

# Run playbooks in check mode
check:
	ansible-playbook main.yml -i "localhost," --check --diff
	ansible-playbook macos.yml -i "localhost," --check --diff

# Run playbooks normally
run:
	ansible-playbook ansible-mac-setup/main.yml -i "localhost,"
	ansible-playbook ansible-mac-setup/macos.yml -i "localhost,"
