#!/bin/bash

# Setup script for Yazi dotfiles.
# Installs 7zip (for archive browsing), yazi flavors via `ya`, and symlinks
# the config files into ~/.config/yazi.
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
TARGET_DIR=~/.config/yazi

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

# Install 7zip (for archive browsing)
# ------------------------------------------------
if command -v 7z &> /dev/null || command -v 7zz &> /dev/null; then
    echo '7zip is already installed.'
else
    echo '7zip is not installed. Installing ...'
    sudo apt update
    sudo apt install -y 7zip
fi

# Install yazi flavors via `ya`
# ------------------------------------------------
# `ya` may not be on PATH for snap installs; fall back to locating it under /snap.
if command -v ya &> /dev/null; then
    YA_CMD="ya"
else
    YA_CMD="$(find /snap/yazi -name "ya" -type f -executable 2>/dev/null | head -1)"
fi

if [ -n "$YA_CMD" ]; then
    mkdir -p "$TARGET_DIR/plugins"
    echo 'Installing yazi flavors ...'
    "$YA_CMD" pkg add matt-dong-123/gruvbox-material
    "$YA_CMD" pkg install
else
    echo -e "${YELLOW}ya command not found. Install yazi, then re-run.${NO_COLOR}"
fi

# Symlink the yazi config files into ~/.config/yazi
# ------------------------------------------------
echo 'Setting up yazi config ...'
mkdir -p "$TARGET_DIR"

for item in "$SCRIPT_DIR"/*; do
    name="$(basename "$item")"

    # Skip this setup script itself
    [ "$name" = "setup_yazi.sh" ] && continue

    link_if_missing "$item" "$TARGET_DIR/$name" "$name"
done

echo -e "\nYazi dotfiles setup complete."
