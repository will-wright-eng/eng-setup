#!/bin/bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[x]${NC} $1"
}

# Check if gpg is installed
check_dependencies() {
    print_status "Checking dependencies..."
    if ! command -v gpg &> /dev/null; then
        print_error "GPG is not installed. Please install it first."
        exit 1
    fi
}

# Function to get user input with default values
get_input() {
    local prompt="$1"
    local default="$2"
    local input

    read -p "$prompt [$default]: " input
    echo "${input:-$default}"
}

# Configure GPG and Git
setup_gpg() {
    print_status "Starting GPG key generation and Git configuration..."

    # Get user information
    local name=$(get_input "Enter your full name" "$(git config --global user.name)")
    local email=$(get_input "Enter your email" "$(git config --global user.email)")

    # Create GPG key configuration
    cat > /tmp/gpg-key-config <<EOF
%echo Generating GPG key
Key-Type: RSA
Key-Length: 4096
Name-Real: $name
Name-Email: $email
Expire-Date: 0
%no-protection
%commit
%echo Done
EOF

    print_status "Generating GPG key (this may take a while)..."
    gpg --batch --generate-key /tmp/gpg-key-config

    # Get the key ID
    local key_id=$(gpg --list-secret-keys --keyid-format=long "$email" | grep sec | awk '{print $2}' | cut -d'/' -f2)

    if [ -z "$key_id" ]; then
        print_error "Failed to get GPG key ID"
        exit 1
    fi

    print_status "GPG key generated successfully with ID: $key_id"

    # Configure Git to use the new key
    git config --global user.signingkey "$key_id"
    git config --global commit.gpgsign true

    # Configure GPG agent
    mkdir -p ~/.gnupg
    echo "use-agent" > ~/.gnupg/gpg.conf
    echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf

    # Set GPG_TTY in shell config
    local shell_config="$HOME/.$(basename $SHELL)rc"
    if [ ! -f "$shell_config" ]; then
        shell_config="$HOME/.profile"
    fi

    if ! grep -q "GPG_TTY" "$shell_config"; then
        echo -e "\n# GPG configuration" >> "$shell_config"
        echo 'export GPG_TTY=$(tty)' >> "$shell_config"
    fi

    # Export public key
    print_status "Exporting public key..."
    gpg --armor --export "$email" > ~/.gnupg/public-key.asc

    print_status "Setup complete! Your public GPG key is saved in ~/.gnupg/public-key.asc"
    print_warning "Don't forget to add this public key to your GitHub/GitLab account"
    print_status "You may need to run 'source $shell_config' or restart your terminal"

    # Print instructions for adding key to GitHub
    cat << EOF

Next steps:
1. Copy your public key:
   cat ~/.gnupg/public-key.asc

2. Add it to your GitHub account:
   - Go to GitHub Settings -> SSH and GPG keys
   - Click "New GPG key"
   - Paste your public key and save

Your Git commits will now be automatically signed!
EOF

    # Cleanup
    rm -f /tmp/gpg-key-config
}

# Main execution
main() {
    check_dependencies
    setup_gpg
}

main "$@"
