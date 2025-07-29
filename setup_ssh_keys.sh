#!/bin/sh

# Usage:
#   sh setup_ssh_keys.sh [github|gitlab] your_email@example.com
#   If no key type is given, both will be generated.

KEY_TYPE="$1"
EMAIL="$2"

# If only email is given, shift the parameters
if [ -z "$EMAIL" ]; then
  EMAIL="$KEY_TYPE"
  KEY_TYPE="both"
fi

# Validate email
if [ -z "$EMAIL" ]; then
  printf "%s\n" "❌ Usage: sh setup_ssh_keys.sh [github|gitlab] your_email@example.com"
  exit 1
fi

# Paths
SSH_DIR="$HOME/.ssh"
GITHUB_KEY="id_github"
GITLAB_KEY="id_gitlab"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
cd "$SSH_DIR" || exit 1

# GitHub key
if [ "$KEY_TYPE" = "github" ] || [ "$KEY_TYPE" = "both" ]; then
  printf "%s\n" "🔑 Generating SSH key for GitHub..."
  ssh-keygen -t ed25519 -f "$GITHUB_KEY" -C "$EMAIL" -N ""
  cp "$GITHUB_KEY.pub" "$GITHUB_KEY.pub.txt"
fi

# GitLab key
if [ "$KEY_TYPE" = "gitlab" ] || [ "$KEY_TYPE" = "both" ]; then
  printf "%s\n" "🔑 Generating SSH key for GitLab..."
  ssh-keygen -t ed25519 -f "$GITLAB_KEY" -C "$EMAIL" -N ""
  cp "$GITLAB_KEY.pub" "$GITLAB_KEY.pub.txt"
fi

# Write SSH config
printf "%s\n" "⚙️ Writing SSH config..."
: >"$SSH_DIR/config" # empty the config file

if [ -f "$GITHUB_KEY" ]; then
  {
    printf "%s\n" "Host github.com"
    printf "%s\n" "  HostName github.com"
    printf "%s\n" "  User git"
    printf "  IdentityFile %s/%s\n" "$SSH_DIR" "$GITHUB_KEY"
    printf "%s\n" "  IdentitiesOnly yes"
    printf "\n"
  } >>"$SSH_DIR/config"
fi

if [ -f "$GITLAB_KEY" ]; then
  {
    printf "%s\n" "Host gitlab.com"
    printf "%s\n" "  HostName gitlab.com"
    printf "%s\n" "  User git"
    printf "  IdentityFile %s/%s\n" "$SSH_DIR" "$GITLAB_KEY"
    printf "%s\n" "  IdentitiesOnly yes"
  } >>"$SSH_DIR/config"
fi

chmod 600 "$SSH_DIR/config"

# Summary
printf "\n%s\n" "✅ SSH keys generated and config created."
if [ -f "$GITHUB_KEY.pub.txt" ]; then
  printf "📎 %s\n" "$SSH_DIR/$GITHUB_KEY.pub.txt (GitHub)"
fi
if [ -f "$GITLAB_KEY.pub.txt" ]; then
  printf "📎 %s\n" "$SSH_DIR/$GITLAB_KEY.pub.txt (GitLab)"
fi
