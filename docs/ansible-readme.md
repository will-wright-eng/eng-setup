# developemnt macbook pro setup

I've found setting up a new macbook for software development using ansible is a great way to automate the configuration process and ensure consistency across any future setups

### Step 1: Install Homebrew

homebrew is a package manager for macos that you'll use to install ansible and other software. to install homebrew, open the terminal and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the on-screen instructions. After installation, add Homebrew to your path if it's not automatically done:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Step 2: Install Ansible

With Homebrew installed, you can now install Ansible:

```bash
brew install ansible
```

### test playbook

```bash
ansible-playbook main.yml -i "localhost," --check --diff
ansible-playbook macos.yml -i "localhost," --check --diff
```

### run playbook

```bash
ansible-playbook main.yml -i "localhost,"
ansible-playbook macos.yml -i "localhost,"
```

### run playbook section

```bash
ansible-playbook main.yml -i "localhost," --tags "zsh-config"
```

### `~/.secrets` file

```bash
export OPENAI_API_KEY=sk-...
```

## secrets method

Automating credential setup for GitHub, Google Cloud Platform (GCP), and other services can be sensitive and should be approached with care to ensure security. Here’s how you can handle it using Ansible and `.env` files.

### Automating Credential Setup

1. **GitHub**: For GitHub, you might want to configure a personal access token (PAT) which is used instead of a password for operations like Git push. Automating the setup involves storing the token securely and configuring Git to use this token.

2. **Google Cloud Platform (GCP)**: For GCP, you'll typically need to manage the credentials JSON file that allows you to authenticate and interact with GCP services.

### Using `.env` Files

`.env` files are often used in development environments to store environment variables. These files can be loaded by your application at runtime to configure itself. Here’s what you might include:

- `GITHUB_TOKEN`: Your GitHub personal access token.
- `GOOGLE_APPLICATION_CREDENTIALS`: Path to your GCP credentials file.
- Other service-specific keys or secrets.

### Managing Secrets with Ansible

When using Ansible, you should manage these secrets securely using Ansible Vault, which encrypts the data, allowing you to safely store sensitive information in your version control system.

#### Steps to Automate Credential Setup Using Ansible

**Step 1: Encrypt the Credentials**
Use Ansible Vault to encrypt your credentials. You’ll need to create a vault file for each set of credentials or a single vault file with all credentials.

```bash
ansible-vault create secrets.yml
```

You can add variables like:

```yaml
github_token: your_github_token_here
gcp_credentials_file: path_to_your_gcp_credentials.json
```

**Step 2: Write the Playbook**
Create a playbook that configures the necessary environment variables or configuration files using the encrypted secrets.

```yaml
---
- hosts: localhost
  connection: local
  gather_facts: no
  become: no
  vars_files:
    - secrets.yml

  tasks:
    - name: Set up GitHub token
      lineinfile:
        path: ~/.bash_profile
        line: 'export GITHUB_TOKEN="{{ github_token }}"'
        create: yes

    - name: Set up GCP credentials file environment variable
      lineinfile:
        path: ~/.bash_profile
        line: 'export GOOGLE_APPLICATION_CREDENTIALS="{{ gcp_credentials_file }}"'
        create: yes

    - name: Ensure .env file exists
      copy:
        dest: "/path/to/your/project/.env"
        content: |
          GITHUB_TOKEN={{ github_token }}
          GOOGLE_APPLICATION_CREDENTIALS={{ gcp_credentials_file }}
        force: no
```

**Step 3: Running the Playbook**
To run the playbook and decrypt the secrets at runtime, use:

```bash
ansible-playbook playbook.yml --ask-vault-pass
```

### Security Considerations

- **Never hard-code sensitive credentials** in your Ansible playbooks or scripts.
- **Use Ansible Vault** to encrypt sensitive data.
- Consider **access controls** for the `.env` file and other configuration files to prevent unauthorized access.

This approach lets you automate the setup of your development environment, including sensitive configurations, while maintaining good security practices.
