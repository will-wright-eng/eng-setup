#!/bin/bash

# Function to print a divider for better readability
divider() {
  echo "=============================================="
}

# Step 1: Check if an email address is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <email_address> [user_name]"
  exit 1
fi

EMAIL="$1"
USER_NAME="${2:-GitHub User}"  # Default name if not provided
SSH_DIR="$HOME/.ssh"
SSH_KEY_FILE="$SSH_DIR/id_ed25519"

divider
echo "Configuring Git with your details..."

# Configure Git global username and email
git config --global user.name "$USER_NAME"
git config --global user.email "$EMAIL"
echo "Git global username set to: $USER_NAME"
echo "Git global email set to: $EMAIL"

divider
echo "Generating a new SSH key for email: $EMAIL"

# Step 2: Generate the SSH key
if [ -f "$SSH_KEY_FILE" ]; then
  echo "SSH key already exists at $SSH_KEY_FILE. Skipping generation."
else
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_KEY_FILE" -N ""
  echo "SSH key generated successfully."
fi

divider
echo "Ensuring the SSH agent is running..."

# Step 3: Start the SSH agent
eval "$(ssh-agent -s)"

divider
echo "Adding the SSH key to the SSH agent..."

# Step 4: Add the SSH private key to the SSH agent
ssh-add "$SSH_KEY_FILE"

divider
echo "Adding the following public key to your GitHub account:"
cat "${SSH_KEY_FILE}.pub"

divider
echo "Follow these steps to complete the process:"
echo "1. Copy the above key to your clipboard."
echo "  \`pbcopy < $SSH_KEY_FILE.pub\`"
echo "2. Go to GitHub > Settings > SSH and GPG keys > New SSH key."
echo "3. Paste the key and save."
echo
echo "Your GitHub SSH key setup and Git configuration are complete!"

divider
echo "Creating SSH config file..."
CONFIG_FILE="$SSH_DIR/config"

if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" <<EOF
Host github.com
    IgnoreUnknown UseKeychain
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519
EOF
    echo "SSH config file created at $CONFIG_FILE"
else
    echo "SSH config file already exists at $CONFIG_FILE, appending github.com config"
    cat >> "$CONFIG_FILE" <<EOF
Host github.com
    IgnoreUnknown UseKeychain
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519
EOF
fi
