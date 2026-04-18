#!/bin/bash

# Setup script for Zsh dotfiles.
# Installs zsh, oh-my-zsh, required custom plugins, and symlinks .zshrc.
# Idempotent: safe to re-run on an already-configured system.
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

# Install zsh
# ------------------------------------------------
if command -v zsh &> /dev/null; then
    echo 'zsh is already installed.'
else
    echo 'zsh is not installed. Installing ...'
    sudo apt update
    sudo apt install -y zsh
fi

# Install oh-my-zsh
# ------------------------------------------------
OH_MY_ZSH_DIR=~/.oh-my-zsh
if [ -d "$OH_MY_ZSH_DIR" ]; then
    echo 'oh-my-zsh is already installed.'
else
    echo 'oh-my-zsh is not installed. Installing ...'
    # Unattended: do not chsh or launch zsh at end of install.
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install custom plugins
# ------------------------------------------------
ZSH_CUSTOM_PLUGINS="${OH_MY_ZSH_DIR}/custom/plugins"
mkdir -p "$ZSH_CUSTOM_PLUGINS"

clone_plugin_if_missing() {
    local name="$1"
    local url="$2"
    local dest="$ZSH_CUSTOM_PLUGINS/$name"
    if [ -d "$dest" ]; then
        echo "$name plugin is already installed."
    else
        echo "Installing $name plugin ..."
        git clone "$url" "$dest"
    fi
}

clone_plugin_if_missing zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
clone_plugin_if_missing zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

# Symlink .zshrc
# ------------------------------------------------
echo 'Setting up zsh config ...'
link_if_missing "$SCRIPT_DIR/.zshrc" ~/.zshrc ".zshrc"

# Nudge the user to switch login shells if they haven't already.
if [ "$(basename "$SHELL")" != "zsh" ]; then
    echo -e "${YELLOW}Current login shell is $SHELL. Run 'chsh -s $(command -v zsh)' to switch to zsh.${NO_COLOR}"
fi

echo -e '\nZsh dotfiles setup complete.'
