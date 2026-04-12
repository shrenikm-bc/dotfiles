#!/bin/bash

# Setup script for Claude Code dotfiles
# Symlinks directories and individual files into ~/.claude
# ------------------------------------------------

# Defining colors
# ------------------------------------------------
RED='\033[0;31m'
CYAN='\033[1;36m'
NO_COLOR='\033[0m'

# Resolve the directory this script lives in
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Target directory
TARGET_DIR=~/.claude

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

echo 'Setting up Claude Code dotfiles ...'

for item in "$SCRIPT_DIR"/*; do
    item="$(basename "$item")"

    # Skip this setup script itself
    [ "$item" = "setup_claude.sh" ] && continue

    SOURCE="$SCRIPT_DIR/$item"
    DEST="$TARGET_DIR/$item"

    if [ -L "$DEST" ]; then
        echo "Symlink already exists for $item. Replacement must be done manually."
    elif [ -e "$DEST" ]; then
        echo -e "${RED}$DEST already exists and is not a symlink. Skipping.${NO_COLOR}"
    else
        echo "Creating symlink for $item ..."
        ln -s "$SOURCE" "$DEST"
        echo -e "${CYAN}Linked $item -> $DEST${NO_COLOR}"
    fi
done

echo -e '\nClaude Code dotfiles setup complete.'
