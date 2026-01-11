# GnuPG Setup and Git Commit Signing on M4 macOS

## Step 1: Install GnuPG

Install GnuPG using Homebrew:

```bash
brew install gnupg
```

If you don't have Homebrew installed, first install it:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Step 2: Generate a GPG Key

1. Generate a new GPG key:

```bash
gpg --full-generate-key
```

1. When prompted:
   - Select `(1) RSA and RSA` (default)
   - Key size: `4096` bits (recommended)
   - Expiration: Choose based on your preference (0 = no expiration, or set a date)
   - Enter your name and email (use the same email as your Git config)
   - Set a strong passphrase

## Step 3: List and Export Your GPG Key

1. List your GPG keys:

```bash
gpg --list-secret-keys --keyid-format=long
```

You'll see output like:

```
sec   rsa4096/ABCD1234EFGH5678 2024-01-10 [SC]
uid                 [ultimate] Your Name <your.email@example.com>
ssb   rsa4096/1234567890ABCDEF 2024-01-10 [E]
```

The key ID is `ABCD1234EFGH5678` (the part after `rsa4096/`)

1. Export your public key (for GitHub/GitLab/etc.):

```bash
gpg --armor --export ABCD1234EFGH5678
```

Copy the entire output including `-----BEGIN PGP PUBLIC KEY BLOCK-----` and `-----END PGP PUBLIC KEY BLOCK-----`

## Step 4: Configure Git to Use GPG

1. Set your GPG key in Git (replace with your key ID):

```bash
git config --global user.signingkey ABCD1234EFGH5678
```

1. Enable commit signing by default:

```bash
git config --global commit.gpgsign true
```

1. Configure Git to use GPG program:

```bash
git config --global gpg.program gpg
```

1. (Optional) Enable tag signing:

```bash
git config --global tag.gpgsign true
```

## Step 5: Configure GPG Agent (for passphrase caching)

1. Create or edit the GPG agent configuration:

```bash
mkdir -p ~/.gnupg
echo "default-cache-ttl 34560000" >> ~/.gnupg/gpg-agent.conf
echo "max-cache-ttl 34560000" >> ~/.gnupg/gpg-agent.conf
```

This caches your passphrase for 400 days. Adjust values as needed (in seconds).

1. Restart the GPG agent:

```bash
gpgconf --kill gpg-agent
gpg-agent --daemon
```

1. Add to your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
export GPG_TTY=$(tty)
```

Then reload your shell:

```bash
source ~/.zshrc
```

## Step 6: Add Your GPG Key to GitHub/GitLab

### GitHub

1. Go to Settings → SSH and GPG keys → New GPG key
2. Paste your public key from Step 3
3. Click "Add GPG key"

### GitLab

1. Go to Preferences → GPG Keys
2. Paste your public key
3. Click "Add key"

## Step 7: Test Your Setup

1. Make a test commit:

```bash
git commit --allow-empty -m "Test signed commit"
```

1. Verify the signature:

```bash
git log --show-signature -1
```

You should see "Good signature from" in the output.

1. Push to GitHub/GitLab and verify the "Verified" badge appears on your commit.

## Troubleshooting

### "gpg failed to sign the data"

- Make sure GPG_TTY is set: `export GPG_TTY=$(tty)`
- Restart GPG agent: `gpgconf --kill gpg-agent`
- Check if pinentry is installed: `brew install pinentry-mac`
- Add to `~/.gnupg/gpg-agent.conf`: `pinentry-program /opt/homebrew/bin/pinentry-mac`

### "No secret key"

- Verify your key exists: `gpg --list-secret-keys --keyid-format=long`
- Make sure the key ID in Git config matches your GPG key

### Passphrase prompt not appearing

- Install pinentry-mac: `brew install pinentry-mac`
- Configure it in `~/.gnupg/gpg-agent.conf`

## Additional Commands

- List all GPG keys: `gpg --list-keys`
- Delete a key: `gpg --delete-secret-key KEY_ID` then `gpg --delete-key KEY_ID`
- Edit a key: `gpg --edit-key KEY_ID`
- Backup your key: `gpg --export-secret-keys --armor KEY_ID > private-key-backup.asc`

## Security Notes

- Keep your private key secure and backed up
- Use a strong passphrase
- Consider setting an expiration date for your keys
- Never share your private key
- Store backup in a secure location (password manager, encrypted drive, etc.)
