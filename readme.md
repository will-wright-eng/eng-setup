# repo rework

I converting this mess of bash scripts into an ansible install

## setup

### make run commmands

use xcode command to install `make`

```bash
xcode-select --install
```

make commmands:

```bash
make install
make run
make gitssh
```

### manual run commands

1. install homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

2. install ansible

```bash
brew install ansible
```

3. run the playbooks

```bash
ansible-playbook ansible/main.yml -i "localhost,"
ansible-playbook ansible/macos.yml -i "localhost,"
```

4. set global git configs

```bash
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```

- [create a public ssh key & add it to ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- log in to github, and [add the newly created key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

## other

- install iterm2 profile
- import rectangle configs
- run `cursor` Makefile commands

### TODO

- install browser extensions

```bash
python -m pip install selenium requests
python configs/browser-extensions.py
```

## references

- [Using Ansible to automate software installation on my Mac | Opensource.com](https://opensource.com/article/22/6/install-software-macos-ansible-homebrew)
- [How to export iTerm2 Profiles](https://stackoverflow.com/a/69724735/14343465)
- [macos - How to turn off all animations on OS X - Ask Different](https://apple.stackexchange.com/questions/14001/how-to-turn-off-all-animations-on-os-x)
- [install iterm2 profile](https://stackoverflow.com/a/66923620/14343465)
