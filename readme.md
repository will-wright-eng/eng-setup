# repo rework

I converting this mess of bash scripts into an ansible install

## setup

after starting up my new/reformatted mac, I will airdrop my zipped ~/.ssh directory and api keys file to my new machine. this method is "acceptable" but creating new ssh keys and adding them to github and cloud services is the preferred method.

```bash
xcode-select --install
```

*opens dialog to install command line tools (including `make` and `git`)*

### make commands

```bash
make install # installs homebrew and ansible
make run # runs ansible playbooks
make extensions # opens browser extension urls in brave browser
```

optional:

```bash
make gitssh # creates new ssh keys and adds them to github
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
    - `cursor-import-extensions`
    - `cursor-import-keybindings`
- add browswer extensions to brave browser

### makefile commands

```bash
help                           list make commands
install                        install homebrew and apps
setup-homebrew                 install homebrew
setup-apps                     install apps
check                          run playbooks in check mode
run                            run playbooks normally
gitssh                         setup git ssh
extensions                     install browser extensions
cursor-export-extensions       [cursor] export extensions
cursor-import-extensions       [cursor] import extensions
cursor-show-keybindings        [cursor] show keybindings
cursor-export-keybindings      [cursor] export keybindings
cursor-import-keybindings      [cursor] import keybindings
cursor                         [cursor] run import commands
```

## todo

- fix rye setup
- add global rye to zshrc ([eg](https://github.com/astral-sh/rye/discussions/998#discussioncomment-10385800))
- fix `make install` bug

## references

- [Using Ansible to automate software installation on my Mac | Opensource.com](https://opensource.com/article/22/6/install-software-macos-ansible-homebrew)
- [How to export iTerm2 Profiles](https://stackoverflow.com/a/69724735/14343465)
- [macos - How to turn off all animations on OS X - Ask Different](https://apple.stackexchange.com/questions/14001/how-to-turn-off-all-animations-on-os-x)
- [install iterm2 profile](https://stackoverflow.com/a/66923620/14343465)
