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

divider
echo "Checking GPG installation..."

if ! command -v gpg &>/dev/null; then
  echo "GPG is not installed. Install it with: brew install gnupg"
  exit 1
fi

GPG_VERSION=$(gpg --version | head -1 | awk '{print $3}')
echo "GPG version: $GPG_VERSION"

divider
echo "Generating a new GPG key for email: $EMAIL"
echo "You will be prompted to create a passphrase — use a strong one."

# Generate key non-interactively using batch mode
GPG_BATCH=$(cat <<EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Name-Real: $USER_NAME
Name-Email: $EMAIL
Expire-Date: 0
EOF
)

# Check if a key already exists for this email
EXISTING_KEY=$(gpg --list-secret-keys --keyid-format=long "$EMAIL" 2>/dev/null | grep sec | awk '{print $2}' | cut -d'/' -f2)

if [ -n "$EXISTING_KEY" ]; then
  echo "GPG key already exists for $EMAIL (Key ID: $EXISTING_KEY). Skipping generation."
  KEY_ID="$EXISTING_KEY"
else
  echo "$GPG_BATCH" | gpg --batch --gen-key
  echo "GPG key generated successfully."
  KEY_ID=$(gpg --list-secret-keys --keyid-format=long "$EMAIL" 2>/dev/null | grep sec | awk '{print $2}' | cut -d'/' -f2)
fi

divider
echo "Configuring Git to use your GPG key..."

git config --global user.name "$USER_NAME"
git config --global user.email "$EMAIL"
git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true
git config --global tag.gpgSign true

echo "Git global username set to: $USER_NAME"
echo "Git global email set to: $EMAIL"
echo "Git signing key set to: $KEY_ID"
echo "Commit auto-signing enabled."

divider
echo "Adding the following public key to your GitHub account:"
gpg --armor --export "$KEY_ID"

divider
echo "Follow these steps to complete the process:"
echo "1. Copy the above key to your clipboard:"
echo "   \`gpg --armor --export $KEY_ID | pbcopy\`"
echo "2. Go to GitHub > Settings > SSH and GPG keys > New GPG key."
echo "3. Paste the key and save."
echo
echo "Your GitHub GPG key setup and Git configuration are complete!"
