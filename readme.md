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
make install  # Installs Homebrew, then everything in the Brewfile (including Ansible)
make run      # Runs Ansible playbooks
```

Optional:

```bash
make gitssh  # Creates new SSH keys and adds them to GitHub
make gitgpg  # Creates new GPG keys and adds them to GitHub
```

### When `make run` Stops

`make run` never deletes or overwrites a file that has local changes. Before writing anything, it compares these against the repo:

| Tag | Local file | Repo source |
| --- | --- | --- |
| `zsh-config` | managed block in `~/.zshrc` | `zshrc_block` in `ansible/main.yml` |
| `git-config` | `~/.gitconfig` | `configs/.gitconfig` |
| `zed-config` | `~/.config/zed/settings.json`, `keymap.json` | `configs/zed/` |
| `ghostty-config` | `~/Library/Application Support/com.mitchellh.ghostty/config` | `configs/ghostty/config` |

If any differ, it prints the diff, changes nothing, and fails with the commands to resolve each one:

```bash
# take the repo version for one tag (the current file is backed up first)
ansible-playbook ansible/main.yml -i "localhost," --tags zed-config -e allow_overwrite=true

# or keep the local version by copying it into the repo
cp ~/.config/zed/settings.json configs/zed/settings.json
```

Files that don't exist yet are created normally. LazyVim is cloned from the upstream starter into `~/.config/lazyvim` only when that directory is missing.

### Manual Setup (Alternative)

If you prefer to run commands manually:

1. Install Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

1. Install the Brewfile packages (taps, formulae, casks, and Ansible):

```bash
brew bundle install --file=Brewfile --no-upgrade
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

1. Set up SSH keys for GitHub:

- [Create a public SSH key & add it to SSH agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- Log in to GitHub and [add the newly created key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

Or use the Makefile command:

```bash
make gitssh
```

## Post-Installation Steps

After running the Ansible playbooks, complete these manual steps:

- Import Rectangle configs: Import `configs/RectangleConfig.json`
- Open LazyVim once with `lv` to install its plugins

## Makefile Commands

Run `make help` to see all available commands, or refer to the list below:

```bash
help                           list make commands
install                        install homebrew and Brewfile packages
setup-homebrew                 install homebrew
brew                           install taps, formulae, and casks from Brewfile
brew-check                     report Brewfile entries not yet installed
brew-cleanup                   list installed packages not in Brewfile
check                          run playbooks in check mode
run                            run playbooks, stopping before overwriting local changes
gitsetup                       [git] setup git global configs
gitssh                         [git] setup git ssh
gitgpg                         [git] setup git gpg
```

## Repository Structure

- `Brewfile` - Homebrew taps, formulae, and casks installed by `make brew`
- `ansible/` - Ansible playbooks for automated setup
    - `main.yml` - Main playbook (shell, git, Zed, Ghostty, LazyVim)
    - `macos.yml` - macOS-specific system settings
- `configs/` - Configuration files for various applications
    - `.gitconfig` - Git configuration
    - `zed/` - Zed settings (including extensions to auto-install) and keymap
    - `ghostty/config` - Ghostty terminal config
    - `lazyvim/lazyvim.json` - LazyVim extras seeded on first install
    - `RectangleConfig.json` - Rectangle window manager config
- `scripts/` - Helper scripts
    - `setup-github-ssh.sh` - SSH key setup script
    - `setup-github-gpg.sh` - GPG setup script
    - `loc.sh` - Lines of code by file extension
- `docs/` - Documentation and notes

## References

- [Using Ansible to automate software installation on my Mac | Opensource.com](https://opensource.com/article/22/6/install-software-macos-ansible-homebrew)
- [macos - How to turn off all animations on OS X - Ask Different](https://apple.stackexchange.com/questions/14001/how-to-turn-off-all-animations-on-os-x)
- [Configuring Zed](https://zed.dev/docs/configuring-zed)
- [Ghostty configuration](https://ghostty.org/docs/config)
- [uv installation](https://docs.astral.sh/uv/getting-started/installation/)
