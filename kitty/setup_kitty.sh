#!/bin/bash

# Setup script for Kitty dotfiles.
# Installs kitty via the official installer and symlinks the config directory.
# Idempotent: safe to re-run on an already-configured system.
# ------------------------------------------------

RED='\033[0;31m'
CYAN='\033[1;36m'
NO_COLOR='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Install kitty via the official installer
# ------------------------------------------------
# The official installer puts the app under ~/.local/kitty.app/ which is
# what the existing PATH symlinks already point at.
if command -v kitty &> /dev/null; then
    echo 'kitty is already installed.'
else
    echo 'kitty is not installed. Installing via the official installer ...'
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    mkdir -p ~/.local/bin
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
    ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/kitten
fi

# Symlink the kitty config directory into ~/.config/kitty
# ------------------------------------------------
mkdir -p ~/.config
TARGET=~/.config/kitty

if [ -L "$TARGET" ]; then
    echo 'Symlink already exists for kitty config. Replacement must be done manually.'
elif [ -e "$TARGET" ]; then
    echo -e "${RED}$TARGET already exists and is not a symlink. Skipping.${NO_COLOR}"
else
    echo 'Creating symlink for kitty config ...'
    ln -s "$SCRIPT_DIR" "$TARGET"
    echo -e "${CYAN}Linked kitty config -> $TARGET${NO_COLOR}"
fi

echo -e '\nKitty dotfiles setup complete.'
