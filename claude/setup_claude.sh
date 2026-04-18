#!/bin/bash

# Setup script for Claude Code dotfiles.
# Symlinks directories and individual files into ~/.claude.
# Idempotent: safe to re-run on an already-configured system.
# ------------------------------------------------

set -u

# Defining colors
# ------------------------------------------------
RED='\033[0;31m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR=~/.claude

link_if_missing() {
    local source="$1"
    local dest="$2"
    local label="$3"

    if [ -L "$dest" ]; then
        echo "Symlink already exists for $label. Replacement must be done manually."
    elif [ -e "$dest" ]; then
        echo -e "${RED}$dest already exists and is not a symlink. Skipping.${NO_COLOR}"
    else
        echo "Creating symlink for $label ..."
        ln -s "$source" "$dest"
        echo -e "${CYAN}Linked $label -> $dest${NO_COLOR}"
    fi
}

# Symlink the claude config into ~/.claude
# ------------------------------------------------
echo 'Setting up claude config ...'
mkdir -p "$TARGET_DIR"

for item in "$SCRIPT_DIR"/*; do
    name="$(basename "$item")"

    # Skip this setup script itself
    [ "$name" = "setup_claude.sh" ] && continue

    link_if_missing "$item" "$TARGET_DIR/$name" "$name"
done

echo -e "\nClaude Code dotfiles setup complete."
