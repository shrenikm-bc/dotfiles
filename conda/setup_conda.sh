#!/bin/bash

# Setup script for Miniconda.
# Installs Miniconda to $HOME/miniconda3 (user-local, no sudo, works on WSL).
# Does NOT run `conda init` — the zsh hook block lives in zsh/.zshrc.
# Idempotent: safe to re-run on an already-configured system.
# ------------------------------------------------

set -u

# Defining colors
# ------------------------------------------------
RED='\033[0;31m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

MINICONDA_PREFIX="$HOME/miniconda3"
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

# Install miniconda
# ------------------------------------------------
if [ -d "$MINICONDA_PREFIX" ]; then
    echo "Miniconda is already installed at $MINICONDA_PREFIX."
else
    if [ -d "/opt/miniconda3" ]; then
        echo -e "${YELLOW}A legacy Miniconda install exists at /opt/miniconda3.${NO_COLOR}"
        echo -e "${YELLOW}Installing a fresh copy to $MINICONDA_PREFIX. See the README for migration steps.${NO_COLOR}"
    fi
    echo "Downloading Miniconda installer ..."
    TMP_INSTALLER=$(mktemp --suffix=.sh)
    if ! curl -fL "$MINICONDA_URL" -o "$TMP_INSTALLER"; then
        echo -e "${RED}Failed to download Miniconda installer from $MINICONDA_URL${NO_COLOR}"
        rm -f "$TMP_INSTALLER"
        exit 1
    fi
    # -b: batch (no prompts, auto-accept license). -p: install prefix.
    if ! bash "$TMP_INSTALLER" -b -p "$MINICONDA_PREFIX"; then
        echo -e "${RED}Miniconda installer failed.${NO_COLOR}"
        rm -f "$TMP_INSTALLER"
        exit 1
    fi
    rm -f "$TMP_INSTALLER"
    echo -e "${CYAN}Miniconda installed at $MINICONDA_PREFIX.${NO_COLOR}"
fi

echo -e "\nConda dotfiles setup complete."
echo -e "${CYAN}The zsh conda init block in zsh/.zshrc sources $MINICONDA_PREFIX on shell startup.${NO_COLOR}"
