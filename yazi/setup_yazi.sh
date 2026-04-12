#!/bin/bash

# Setup script for Yazi dotfiles
# Symlinks individual config files into ~/.config/yazi
# ------------------------------------------------

# Defining colors
# ------------------------------------------------
RED='\033[0;31m'
CYAN='\033[1;36m'
NO_COLOR='\033[0m'

# Resolve the directory this script lives in
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Target directory
TARGET_DIR=~/.config/yazi

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

# Install 7zip for archive browsing
if command -v 7z &> /dev/null || command -v 7zz &> /dev/null; then
    echo '7zip is already installed.'
else
    echo '7zip is not installed. Installing ...'
    sudo apt install -y 7zip
fi

echo 'Setting up Yazi dotfiles ...'

for item in "$SCRIPT_DIR"/*; do
    item="$(basename "$item")"

    # Skip setup scripts
    [ "$item" = "setup_yazi.sh" ] && continue

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

echo -e '\nYazi dotfiles setup complete.'
