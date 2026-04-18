#!/bin/bash

# Setup script for tmux dotfiles.
# Installs tmux and TPM (plugin manager), symlinks .tmux.conf.
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

# Install tmux
# ------------------------------------------------
if command -v tmux &> /dev/null; then
    echo 'tmux is already installed.'
else
    echo 'tmux is not installed. Installing ...'
    sudo apt update
    sudo apt install -y tmux
fi

# Install TPM (tmux plugin manager)
# ------------------------------------------------
TPM_DIR=~/.tmux/plugins/tpm
if [ -d "$TPM_DIR" ]; then
    echo 'TPM is already installed.'
else
    echo 'TPM is not installed. Installing ...'
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Symlink .tmux.conf
# ------------------------------------------------
echo 'Setting up tmux config ...'
link_if_missing "$SCRIPT_DIR/.tmux.conf" ~/.tmux.conf ".tmux.conf"

echo -e "\nTmux dotfiles setup complete."
echo -e "${CYAN}Launch tmux and press prefix + I to install plugins.${NO_COLOR}"
