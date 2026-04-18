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

# Install yazi if missing
# ------------------------------------------------
# The pinned version is only consulted for fresh installs; if yazi is already
# on PATH (e.g. from snap or a system package), we leave it alone to avoid
# shuffling an existing working install onto a different version.
if command -v yazi &> /dev/null; then
    echo "yazi is already installed ($(command -v yazi))."
else
    YAZI_VERSION_FILE="$SCRIPT_DIR/version"
    if [ ! -f "$YAZI_VERSION_FILE" ]; then
        echo -e "${RED}Missing version file at $YAZI_VERSION_FILE${NO_COLOR}"
        exit 1
    fi
    YAZI_VERSION="$(cat "$YAZI_VERSION_FILE" | tr -d '[:space:]')"
    YAZI_INSTALL_DIR="$HOME/.local/bin"
    YAZI_RELEASE="yazi-x86_64-unknown-linux-gnu"
    YAZI_ZIP_URL="https://github.com/sxyazi/yazi/releases/download/v${YAZI_VERSION}/${YAZI_RELEASE}.zip"

    echo "yazi is not installed. Downloading $YAZI_VERSION ..."
    mkdir -p "$YAZI_INSTALL_DIR"
    TMP_ZIP=$(mktemp --suffix=.zip)
    if ! curl -fL "$YAZI_ZIP_URL" -o "$TMP_ZIP"; then
        echo -e "${RED}Failed to download yazi from $YAZI_ZIP_URL${NO_COLOR}"
        rm -f "$TMP_ZIP"
        exit 1
    fi
    TMP_EXTRACT=$(mktemp -d)
    if ! unzip -q "$TMP_ZIP" -d "$TMP_EXTRACT"; then
        echo -e "${RED}Failed to extract yazi zip.${NO_COLOR}"
        rm -rf "$TMP_ZIP" "$TMP_EXTRACT"
        exit 1
    fi
    mv "$TMP_EXTRACT/$YAZI_RELEASE/yazi" "$YAZI_INSTALL_DIR/yazi"
    mv "$TMP_EXTRACT/$YAZI_RELEASE/ya"   "$YAZI_INSTALL_DIR/ya"
    chmod +x "$YAZI_INSTALL_DIR/yazi" "$YAZI_INSTALL_DIR/ya"
    rm -rf "$TMP_ZIP" "$TMP_EXTRACT"
    echo -e "${CYAN}yazi $YAZI_VERSION installed.${NO_COLOR}"
fi

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

    # Skip files that belong to the repo, not to yazi's runtime config.
    case "$name" in
        setup_yazi.sh|version) continue ;;
    esac

    link_if_missing "$item" "$TARGET_DIR/$name" "$name"
done

echo -e "\nYazi dotfiles setup complete."
