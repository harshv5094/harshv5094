#!/bin/sh -e

GITHUB_USER="harshv5094"
GITHUB_REPO="dotfiles"
FOLDER_DIR=".local/bin"

# Fetch list of scripts (cached for performance)
scripts=$(curl -fsSL "https://api.github.com/repos/$GITHUB_USER/$GITHUB_REPO/contents/$FOLDER_DIR" |
  jq -r '.[].name' | grep '\.sh$')

if [ -z "$scripts" ]; then
  echo "No scripts found in $GITHUB_USER/$GITHUB_REPO/$FOLDER_DIR"
  exit 1
fi

# Use fzf to pick a script
selected=$(printf '%s\n' $scripts | fzf \
  --style full --layout=reverse \
  --border --padding 1,2 \
  --border-label '** Script Picker **' \
  --preview "curl -fsSL https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/$FOLDER_DIR/{} | bat --style=plain --color=always || curl -fsSL https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/$FOLDER_DIR/{} | cat" \
  --preview-window=right:60%:wrap \
  --color "bg:#282828,fg:#ebdbb2,hl:#fabd2f" \
  --color "border:#fabd2f,label:#fabd2f" \
  --color "preview-border:#d79921,preview-label:#fabd2f" \
  --ansi)

# Exit if nothing was selected
[ -z "$selected" ] && exit 0

# Execute the chosen script
curl -fsSL "https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/$FOLDER_DIR/$selected" | sh
