#!/bin/sh

# Usage: sh setup_ssh_keys.sh your_email@example.com

EMAIL="$1"

# Validate input
if [ -z "$EMAIL" ]; then
  printf "%s\n" "❌ Usage: sh setup_ssh_keys.sh your_email@example.com"
  exit 1
fi

# Variables
GITHUB_KEY="id_github"
GITLAB_KEY="id_gitlab"
SSH_DIR="$HOME/.ssh"

# Prepare .ssh directory
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

cd "$SSH_DIR" || exit 1

# Generate GitHub SSH key
printf "%s\n" "🔑 Generating SSH key for GitHub..."
ssh-keygen -t ed25519 -f "$GITHUB_KEY" -C "$EMAIL (GitHub)" -N ""

# Generate GitLab SSH key
printf "%s\n" "🔑 Generating SSH key for GitLab..."
ssh-keygen -t ed25519 -f "$GITLAB_KEY" -C "$EMAIL (GitLab)" -N ""

# Save public keys for copy-paste
cp "$GITHUB_KEY.pub" "$GITHUB_KEY.pub.txt"
cp "$GITLAB_KEY.pub" "$GITLAB_KEY.pub.txt"

# Write SSH config
printf "%s\n" "⚙️ Writing SSH config..."

{
  printf "%s\n" "Host github.com"
  printf "%s\n" "  HostName github.com"
  printf "%s\n" "  User git"
  printf "  IdentityFile %s/%s\n" "$SSH_DIR" "$GITHUB_KEY"
  printf "%s\n" "  IdentitiesOnly yes"
  printf "\n"
  printf "%s\n" "Host gitlab.com"
  printf "%s\n" "  HostName gitlab.com"
  printf "%s\n" "  User git"
  printf "  IdentityFile %s/%s\n" "$SSH_DIR" "$GITLAB_KEY"
  printf "%s\n" "  IdentitiesOnly yes"
} >"$SSH_DIR/config"

chmod 600 "$SSH_DIR/config"

# Completion message
printf "\n%s\n" "✅ SSH keys generated and SSH config updated."
printf "%s\n" "📎 Public key files ready for upload:"
printf "   • %s/%s.pub.txt\n" "$SSH_DIR" "$GITHUB_KEY"
printf "   • %s/%s.pub.txt\n" "$SSH_DIR" "$GITLAB_KEY"
