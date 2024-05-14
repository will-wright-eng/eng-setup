# repo rework

converting this mess of bash scripts (see archive) into an ansible install

- [Using Ansible to automate software installation on my Mac | Opensource.com](https://opensource.com/article/22/6/install-software-macos-ansible-homebrew)
- [How to export iTerm2 Profiles](https://stackoverflow.com/a/69724735/14343465)

## setup

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
ansible-playbook ansible-mac-setup/main.yml -i "localhost,"
ansible-playbook ansible-mac-setup/macos.yml -i "localhost,"
```

4. install browser extensions

```bash
conda create -n ansible-mac-setup python=3.12 -y
conda activate ansible-mac-setup
python -m pip install selenium
python browser-extensions.py
```

5. [install iterm2 profile](https://stackoverflow.com/a/66923620/14343465)

6. set global git configs

```bash
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```
