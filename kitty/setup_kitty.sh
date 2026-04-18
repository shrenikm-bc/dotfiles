#!/bin/bash

# Setup script for Kitty dotfiles.
# Installs kitty via the official installer and symlinks the config directory.
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

# Install kitty via the official installer
# ------------------------------------------------
# The official installer puts the app under ~/.local/kitty.app/ which is
# what the existing PATH symlinks already point at.
if command -v kitty &> /dev/null; then
    echo 'kitty is already installed.'
else
    echo 'kitty is not installed. Installing ...'
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    mkdir -p ~/.local/bin
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
    ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/kitten
fi

# Symlink the kitty config directory into ~/.config/kitty
# ------------------------------------------------
echo 'Setting up kitty config ...'
mkdir -p ~/.config
link_if_missing "$SCRIPT_DIR" ~/.config/kitty "kitty config"

echo -e "\nKitty dotfiles setup complete."
