#!/bin/bash

# Setup script for Neovim dotfiles (LazyVim / lvim).
# Installs system dependencies, the pinned nvim binary, and sets up
# all symlinks required for the `lvim` alias/shim to launch LazyVim.
#
# Idempotent: safe to re-run on a system that's already set up.
# The legacy `nvim` config is not managed here.
# ------------------------------------------------

set -u

# Defining colors
# ------------------------------------------------
RED='\033[0;31m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

# Resolve repo paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Pinned versions live in the root-level `versions` file so the shims
# (bin/lvim, bin/nvim) and this script always agree. Bump NVIM_VERSION there
# and re-run this script to upgrade.
VERSIONS_FILE="$REPO_ROOT/versions"
if [ ! -f "$VERSIONS_FILE" ]; then
    echo -e "${RED}Missing versions file at $VERSIONS_FILE${NO_COLOR}"
    exit 1
fi
# shellcheck source=../versions
. "$VERSIONS_FILE"
NVIM_INSTALL_DIR="/opt/nvim_${NVIM_VERSION}-linux64"
NVIM_BIN="${NVIM_INSTALL_DIR}/bin/nvim"
NVIM_TARBALL_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"

# Helper: create a symlink only if the destination does not already exist.
# Matches the pattern used by setup_yazi.sh / setup_claude.sh.
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

# Install apt dependencies
# ------------------------------------------------
echo 'Checking system dependencies ...'

# git, curl, make, gcc needed to fetch and build plugins / treesitter parsers.
# ripgrep and fd-find back the LazyVim file / grep pickers.
# unzip is needed by mason for some binaries.
# xclip gives nvim a clipboard provider on X11.
# python3-venv backs the dedicated pylsp venv used for refactoring (rope).
APT_PACKAGES=(git curl make gcc unzip ripgrep fd-find xclip python3-venv)
MISSING_PACKAGES=()

for pkg in "${APT_PACKAGES[@]}"; do
    if dpkg -s "$pkg" &> /dev/null; then
        echo "$pkg is already installed."
    else
        MISSING_PACKAGES+=("$pkg")
    fi
done

if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    echo "Installing missing packages: ${MISSING_PACKAGES[*]}"
    sudo apt update
    sudo apt install -y "${MISSING_PACKAGES[@]}"
fi

# Install pinned Neovim binary
# ------------------------------------------------
if [ -x "$NVIM_BIN" ]; then
    echo "Neovim $NVIM_VERSION is already installed at $NVIM_INSTALL_DIR."
else
    echo "Neovim $NVIM_VERSION is not installed. Downloading ..."
    TMP_TARBALL=$(mktemp --suffix=.tar.gz)
    # Exit the script if any of the install steps fail so we don't leave /opt half-populated.
    if ! curl -fL "$NVIM_TARBALL_URL" -o "$TMP_TARBALL"; then
        echo -e "${RED}Failed to download Neovim from $NVIM_TARBALL_URL${NO_COLOR}"
        rm -f "$TMP_TARBALL"
        exit 1
    fi
    TMP_EXTRACT=$(mktemp -d)
    if ! tar -xzf "$TMP_TARBALL" -C "$TMP_EXTRACT"; then
        echo -e "${RED}Failed to extract Neovim tarball.${NO_COLOR}"
        rm -rf "$TMP_TARBALL" "$TMP_EXTRACT"
        exit 1
    fi
    # The tarball extracts to a single top-level directory; move it to the target name.
    EXTRACTED_DIR=$(find "$TMP_EXTRACT" -maxdepth 1 -mindepth 1 -type d | head -1)
    echo "Installing Neovim to $NVIM_INSTALL_DIR (requires sudo) ..."
    sudo mv "$EXTRACTED_DIR" "$NVIM_INSTALL_DIR"
    rm -rf "$TMP_TARBALL" "$TMP_EXTRACT"
    echo -e "${CYAN}Neovim $NVIM_VERSION installed.${NO_COLOR}"
fi

# Symlink the LazyVim config into ~/.config/lvim
# ------------------------------------------------
echo 'Setting up LazyVim config ...'
mkdir -p ~/.config
link_if_missing "$SCRIPT_DIR/lvim" ~/.config/lvim "lvim config"
link_if_missing "$SCRIPT_DIR/blvim" ~/.config/blvim "blvim config"

# Symlink the lvim and blvim shim into ~/.local/bin
# ------------------------------------------------
echo 'Setting up lvim and blvim shim ...'
mkdir -p ~/.local/bin
link_if_missing "$REPO_ROOT/bin/lvim" ~/.local/bin/lvim "lvim shim"
link_if_missing "$REPO_ROOT/bin/blvim" ~/.local/bin/blvim "blvim shim"

# Symlink the lvim shim into ~/.local/bin
# ------------------------------------------------
echo 'Setting up lvim shim ...'
mkdir -p ~/.local/bin
link_if_missing "$REPO_ROOT/bin/lvim" ~/.local/bin/lvim "lvim shim"

# Install pylsp into a dedicated venv (refactoring-only LSP)
# ------------------------------------------------
# pyright stays the primary Python LSP for diagnostics / hover / go-to-def /
# completion / rename. pylsp is layered on top *only* for rope-backed
# refactoring code actions (move symbol, extract method, inline, etc.) that
# pyright doesn't expose. Every other pylsp provider is disabled in
# lvim/lua/plugins/lsp.lua so it never competes with pyright or ruff.
#
# We use a dedicated venv (rather than mason or any project conda env) so:
#   - pylsp-rope can be co-installed alongside pylsp in the same interpreter
#     (mason has no clean way to inject extras into its managed venvs).
#   - the LSP works in any project regardless of whether its conda env has
#     pylsp installed.
# Upgrade flow: `rm -rf ~/.local/share/pylsp-venv` and re-run this script.
PYLSP_VENV="$HOME/.local/share/pylsp-venv"
if [ -x "$PYLSP_VENV/bin/pylsp" ]; then
    echo "pylsp venv already set up at $PYLSP_VENV."
else
    echo "Setting up pylsp venv at $PYLSP_VENV ..."
    if ! python3 -m venv "$PYLSP_VENV"; then
        echo -e "${RED}Failed to create venv at $PYLSP_VENV.${NO_COLOR}"
        exit 1
    fi
    if ! "$PYLSP_VENV/bin/pip" install --upgrade pip python-lsp-server pylsp-rope; then
        echo -e "${RED}Failed to install python-lsp-server / pylsp-rope into $PYLSP_VENV.${NO_COLOR}"
        exit 1
    fi
    echo -e "${CYAN}pylsp + pylsp-rope installed at $PYLSP_VENV.${NO_COLOR}"
fi

# Symlink fd-find -> fd (Ubuntu ships the binary as `fdfind`)
# ------------------------------------------------
if command -v fd &> /dev/null; then
    echo 'fd is already available on PATH.'
elif command -v fdfind &> /dev/null; then
    echo 'Symlinking fdfind -> fd ...'
    link_if_missing "$(command -v fdfind)" ~/.local/bin/fd "fd"
else
    echo -e "${YELLOW}fd not found. LazyVim pickers will still work via ripgrep.${NO_COLOR}"
fi

echo -e "\nNeovim dotfiles setup complete."
echo -e "${CYAN}First launch of lvim will bootstrap lazy.nvim and install plugins.${NO_COLOR}"
