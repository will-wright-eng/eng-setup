# Ansible Refactor

For a simple Ansible project to set up a macOS software development computer, you can use a streamlined directory structure. Here's an example:

## Directory Structure

```
ansible-macos-setup/
├── ansible.cfg
├── inventory
├── playbook.yml
├── roles/
│   ├── common/
│   │   ├── tasks/
│   │   │   └── main.yml
│   ├── homebrew/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   └── vars/
│   │       └── main.yml
├── group_vars/
│   └── all.yml
└── README.md
```

### Example Files

### `ansible.cfg`

```ini
[defaults]
inventory = inventory
host_key_checking = False
retry_files_enabled = False
```

### `inventory`

```ini
localhost ansible_connection=local
```

### `group_vars/all.yml`

```yaml
# Global variables can be defined here
homebrew_packages:
  - git
  - python
  - node
  - docker
  - visual-studio-code
  - google-chrome
```

### `roles/common/tasks/main.yml`

```yaml
---
- name: Ensure Xcode Command Line Tools are installed
  xcode_select:
    state: present
```

### `roles/homebrew/tasks/main.yml`

```yaml
---
- name: Install Homebrew
  command: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  args:
    creates: /usr/local/bin/brew

- name: Install Homebrew packages
  homebrew:
    name: "{{ item }}"
    state: present
  loop: "{{ homebrew_packages }}"
```

### `roles/homebrew/vars/main.yml`

```yaml
# This file can include any specific variables for the homebrew role
```

### `playbook.yml`

```yaml
---
- hosts: localhost
  roles:
    - common
    - homebrew
```

### `README.md`

```markdown
# macOS Development Environment Setup

This Ansible playbook sets up a macOS development environment with essential tools and applications.

## Usage

1. Install Ansible:

    ```sh
    pip install ansible
    ```

2. Clone this repository:

    ```sh
    git clone <repository_url>
    cd ansible-macos-setup
    ```

3. Run the playbook:

    ```sh
    ansible-playbook playbook.yml
    ```

This playbook will install Xcode Command Line Tools and Homebrew, and then use Homebrew to install various packages and applications specified in `group_vars/all.yml`.

### Running the Playbook

To run the playbook, navigate to the `ansible-macos-setup` directory and execute:

```sh
ansible-playbook playbook.yml
```

This simple setup will ensure that essential tools and applications are installed on your macOS development computer. Adjust the `homebrew_packages` variable in `group_vars/all.yml` to include any additional packages or applications you need.
