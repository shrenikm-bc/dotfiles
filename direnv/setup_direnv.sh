#!/bin/bash

# Setup script for direnv.
# Installs direnv via apt and symlinks direnvrc into ~/.config/direnv/.
# The zsh hook (`eval "$(direnv hook zsh)"`) lives in zsh/.zshrc.
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

# Install direnv
# ------------------------------------------------
if command -v direnv &> /dev/null; then
    echo "direnv is already installed ($(direnv --version))."
else
    echo "direnv is not installed. Installing ..."
    sudo apt update
    sudo apt install -y direnv
fi

# Symlink direnvrc
# ------------------------------------------------
DIRENV_CONFIG_DIR="$HOME/.config/direnv"
mkdir -p "$DIRENV_CONFIG_DIR"
link_if_missing "$SCRIPT_DIR/direnvrc" "$DIRENV_CONFIG_DIR/direnvrc" "direnvrc"

echo -e "\nDirenv dotfiles setup complete."
echo -e "${CYAN}Add 'layout conda <env-name>' to a project's .envrc, then run 'direnv allow' inside it.${NO_COLOR}"
