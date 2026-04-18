#!/bin/bash

# Setup script for ranger dotfiles.
# Note: ranger is not actively used (see CLAUDE.md) but the rc.conf is kept.
# Idempotent: safe to re-run on an already-configured system.
# ------------------------------------------------

RED='\033[0;31m'
CYAN='\033[1;36m'
NO_COLOR='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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

# Install ranger
# ------------------------------------------------
if command -v ranger &> /dev/null; then
    echo 'ranger is already installed.'
else
    echo 'ranger is not installed. Installing ...'
    sudo apt update
    sudo apt install -y ranger
fi

# Symlink rc.conf
# ------------------------------------------------
TARGET_DIR=~/.config/ranger
mkdir -p "$TARGET_DIR"
echo 'Setting up ranger config ...'

for item in "$SCRIPT_DIR"/*; do
    item="$(basename "$item")"

    # Skip this setup script itself
    [ "$item" = "setup_ranger.sh" ] && continue

    link_if_missing "$SCRIPT_DIR/$item" "$TARGET_DIR/$item" "$item"
done

echo -e '\nRanger dotfiles setup complete.'
