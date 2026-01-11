# macOS Development Environment Setup

Ansible-based automation for setting up a macOS development environment. This repository has been converted from bash scripts to Ansible playbooks for better maintainability and idempotency.

## Setup

After starting up a new or reformatted Mac, you may want to transfer your SSH keys and API keys to the new machine. While transferring a zipped `~/.ssh` directory via AirDrop is acceptable, creating new SSH keys and adding them to GitHub and cloud services is the preferred method.

### Prerequisites

Install Xcode Command Line Tools (includes `make` and `git`):

```bash
xcode-select --install
```

This opens a dialog to install the command line tools.

### Quick Start

The easiest way to set up your environment:

```bash
make install  # Installs Homebrew and Ansible
make run      # Runs Ansible playbooks
```

Optional:

```bash
make gitssh   # Creates new SSH keys and adds them to GitHub
make extensions  # Downloads and extracts browser extensions
```

### Manual Setup (Alternative)

If you prefer to run commands manually:

1. Install Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

1. Install Ansible:

```bash
brew install ansible
```

1. Run the playbooks:

```bash
ansible-playbook ansible/main.yml -i "localhost,"
ansible-playbook ansible/macos.yml -i "localhost,"
```

1. Set global Git configs:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Or use the Makefile command (requires `.env` file with `GITHUB_USERNAME` and `GITHUB_EMAIL`):

```bash
make gitsetup
```

1. Set up SSH keys for GitHub:

- [Create a public SSH key & add it to SSH agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- Log in to GitHub and [add the newly created key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

Or use the Makefile command:

```bash
make gitssh
```

## Post-Installation Steps

After running the Ansible playbooks, complete these manual steps:

- Install iTerm2 profile: Import `configs/iterm2-profile.json`
- Import Rectangle configs: Import `configs/RectangleConfig.json`
- Run Cursor Makefile commands:
    - `make cursor-import-extensions`
    - `make cursor-import-keybindings`
- Add browser extensions to Ungoogled Chromium (use `make extensions` to download and extract extensions)

## Makefile Commands

Run `make help` to see all available commands, or refer to the list below:

```bash
help                           # List all Makefile commands
install                        # Install Homebrew and Ansible
setup-homebrew                 # Install Homebrew
setup-apps                     # Install Ansible
check                          # Run playbooks in check mode (dry run)
run                            # Run playbooks normally
gitssh                         # Setup Git SSH keys
gitsetup                       # Setup Git global configs (requires .env file)
extensions                     # Download and extract browser extensions
extensions-download            # Download browser extension CRX files
extensions-extract             # Extract CRX files to unpacked extensions
cursor-export-extensions       # [Cursor] Export extensions list
cursor-import-extensions       # [Cursor] Import extensions
cursor-show-keybindings        # [Cursor] Show keybindings
cursor-export-keybindings      # [Cursor] Export keybindings
cursor-import-keybindings      # [Cursor] Import keybindings
cursor                         # [Cursor] Run import commands
```

## Repository Structure

- `ansible/` - Ansible playbooks for automated setup
    - `main.yml` - Main playbook (packages, shell config, Python environment)
    - `macos.yml` - macOS-specific system settings
- `configs/` - Configuration files for various applications
    - `.gitconfig` - Git configuration
    - `cursor-extensions.txt` - Cursor IDE extensions list
    - `cursor-keybindings.json` - Cursor IDE keybindings
    - `iterm2-profile.json` - iTerm2 profile
    - `RectangleConfig.json` - Rectangle window manager config
- `scripts/` - Helper scripts
    - `setup-github-ssh.sh` - SSH key setup script
    - `gpg-setup.sh` - GPG setup script
    - Other utility scripts
- `archive/` - Legacy bash scripts (deprecated, kept for reference)
- `docs/` - Documentation and notes

## TODO

- Fix uv setup
- Add global uv to `.zshrc` (see [uv documentation](https://docs.astral.sh/uv/getting-started/installation/))
- Fix `make install` bug

## References

- [Using Ansible to automate software installation on my Mac | Opensource.com](https://opensource.com/article/22/6/install-software-macos-ansible-homebrew)
- [How to export iTerm2 Profiles](https://stackoverflow.com/a/69724735/14343465)
- [macos - How to turn off all animations on OS X - Ask Different](https://apple.stackexchange.com/questions/14001/how-to-turn-off-all-animations-on-os-x)
- [Install iTerm2 profile](https://stackoverflow.com/a/66923620/14343465)
