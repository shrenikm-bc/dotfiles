#!/bin/bash

# Setup script for lazygit.
# Installs the pinned lazygit binary into ~/.local/bin so it's available
# without sudo and to the tmux popup binding.
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
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Pinned versions live in the root-level `versions` file. Bump LAZYGIT_VERSION
# there and re-run this script to upgrade.
VERSIONS_FILE="$REPO_ROOT/versions"
if [ ! -f "$VERSIONS_FILE" ]; then
    echo -e "${RED}Missing versions file at $VERSIONS_FILE${NO_COLOR}"
    exit 1
fi
# shellcheck source=../versions
. "$VERSIONS_FILE"
LAZYGIT_INSTALL_DIR="$HOME/.local/bin"
LAZYGIT_BIN="$LAZYGIT_INSTALL_DIR/lazygit"
LAZYGIT_TARBALL_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

# Install lazygit
# ------------------------------------------------
# Compare against the installed binary so bumping the version file triggers
# an upgrade (rather than a bare "does the binary exist" check).
INSTALLED_VERSION=""
if [ -x "$LAZYGIT_BIN" ]; then
    # lazygit --version emits: "..., version=X.Y.Z, ..., git version=A.B.C"
    # Anchor on the leading comma to avoid matching the trailing git version field.
    INSTALLED_VERSION="$("$LAZYGIT_BIN" --version 2>&1 | sed -nE 's/.*, version=([0-9.]+),.*/\1/p')"
fi

if [ "$INSTALLED_VERSION" = "$LAZYGIT_VERSION" ]; then
    echo "lazygit $LAZYGIT_VERSION is already installed at $LAZYGIT_BIN."
else
    if [ -n "$INSTALLED_VERSION" ]; then
        echo "lazygit $INSTALLED_VERSION is installed. Upgrading to $LAZYGIT_VERSION ..."
    else
        echo "lazygit is not installed. Downloading $LAZYGIT_VERSION ..."
    fi
    mkdir -p "$LAZYGIT_INSTALL_DIR"
    TMP_TARBALL=$(mktemp --suffix=.tar.gz)
    if ! curl -fL "$LAZYGIT_TARBALL_URL" -o "$TMP_TARBALL"; then
        echo -e "${RED}Failed to download lazygit from $LAZYGIT_TARBALL_URL${NO_COLOR}"
        rm -f "$TMP_TARBALL"
        exit 1
    fi
    TMP_EXTRACT=$(mktemp -d)
    if ! tar -xzf "$TMP_TARBALL" -C "$TMP_EXTRACT"; then
        echo -e "${RED}Failed to extract lazygit tarball.${NO_COLOR}"
        rm -rf "$TMP_TARBALL" "$TMP_EXTRACT"
        exit 1
    fi
    mv "$TMP_EXTRACT/lazygit" "$LAZYGIT_BIN"
    chmod +x "$LAZYGIT_BIN"
    rm -rf "$TMP_TARBALL" "$TMP_EXTRACT"
    echo -e "${CYAN}lazygit $LAZYGIT_VERSION installed.${NO_COLOR}"
fi

echo -e "\nLazygit dotfiles setup complete."
echo -e "${CYAN}In tmux, press Alt-g to open lazygit in a floating popup.${NO_COLOR}"
