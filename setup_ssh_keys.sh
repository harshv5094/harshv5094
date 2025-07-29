#!/bin/sh

# Usage:
#   sh setup_ssh_keys.sh [github|gitlab] your_email@example.com
#   If no key type is given, both will be generated.

KEY_TYPE="$1"
EMAIL="$2"

# Shift args if only email is passed
if [ -z "$EMAIL" ]; then
  EMAIL="$KEY_TYPE"
  KEY_TYPE="both"
fi

# Validate
if [ -z "$EMAIL" ]; then
  printf "%s\n" "❌ Usage: sh setup_ssh_keys.sh [github|gitlab] your_email@example.com"
  exit 1
fi

# Setup
SSH_DIR="$HOME/.ssh"
GITHUB_KEY="id_github"
GITLAB_KEY="id_gitlab"
CONFIG_FILE="$SSH_DIR/config"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
cd "$SSH_DIR" || exit 1

# --- GitHub Key ---
if [ "$KEY_TYPE" = "github" ] || [ "$KEY_TYPE" = "both" ]; then
  if [ ! -f "$GITHUB_KEY" ]; then
    printf "%s\n" "🔑 Generating SSH key for GitHub..."
    ssh-keygen -t ed25519 -f "$GITHUB_KEY" -C "$EMAIL" -N ""
  else
    printf "⚠️  GitHub key already exists at %s — skipping.\n" "$SSH_DIR/$GITHUB_KEY"
  fi
fi

# --- GitLab Key ---
if [ "$KEY_TYPE" = "gitlab" ] || [ "$KEY_TYPE" = "both" ]; then
  if [ ! -f "$GITLAB_KEY" ]; then
    printf "%s\n" "🔑 Generating SSH key for GitLab..."
    ssh-keygen -t ed25519 -f "$GITLAB_KEY" -C "$EMAIL" -N ""
  else
    printf "⚠️  GitLab key already exists at %s — skipping.\n" "$SSH_DIR/$GITLAB_KEY"
  fi
fi

# --- SSH Config Updates ---
touch "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"

# Add GitHub config if missing
if [ -f "$GITHUB_KEY" ] && ! grep -q "Host github.com" "$CONFIG_FILE"; then
  printf "%s\n" "🔧 Adding GitHub SSH config..."
  {
    printf "%s\n" "Host github.com"
    printf "%s\n" "  HostName github.com"
    printf "%s\n" "  User git"
    printf "  IdentityFile %s/%s\n" "$SSH_DIR" "$GITHUB_KEY"
    printf "%s\n" "  IdentitiesOnly yes"
    printf "\n"
  } >>"$CONFIG_FILE"
fi

# Add GitLab config if missing
if [ -f "$GITLAB_KEY" ] && ! grep -q "Host gitlab.com" "$CONFIG_FILE"; then
  printf "%s\n" "🔧 Adding GitLab SSH config..."
  {
    printf "%s\n" "Host gitlab.com"
    printf "%s\n" "  HostName gitlab.com"
    printf "%s\n" "  User git"
    printf "  IdentityFile %s/%s\n" "$SSH_DIR" "$GITLAB_KEY"
    printf "%s\n" "  IdentitiesOnly yes"
    printf "\n"
  } >>"$CONFIG_FILE"
fi

# --- Summary ---
printf "\n✅ SSH setup complete.\n"
printf "📎 To copy your public key(s), run:\n"
[ -f "$GITHUB_KEY.pub" ] && printf "   • cat %s/%s.pub (GitHub)\n" "$SSH_DIR" "$GITHUB_KEY"
[ -f "$GITLAB_KEY.pub" ] && printf "   • cat %s/%s.pub (GitLab)\n" "$SSH_DIR" "$GITLAB_KEY"
