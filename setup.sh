#!/bin/bash

# Main setup entry point for the dotfiles repo.
# Interactively prompts for each tool and delegates to the per-tool setup
# script (zsh/setup_zsh.sh, neovim/setup_neovim.sh, etc).
# Each per-tool script is idempotent and runnable standalone.
# ------------------------------------------------

set -u

# Defining colors
# ------------------------------------------------
RED='\033[0;31m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Prompt for a yes/no answer; re-asks on unrecognized input.
prompt_yes_no() {
    local question="$1"
    local answer
    while true; do
        read -r -p "$(echo -e "${CYAN}${question} (y/n): ${NO_COLOR}")" answer
        case "$answer" in
            [yY]|[yY][eE][sS]) return 0 ;;
            [nN]|[nN][oO]) return 1 ;;
            *) echo "Please answer y or n." ;;
        esac
    done
}

# Run a per-tool setup script gated on a y/n prompt.
configure_if_wanted() {
    local name="$1"
    local script="$2"

    echo
    echo '------------------------------------------------'
    if prompt_yes_no "Do you want to configure $name?"; then
        bash "$script"
    else
        echo "Skipping $name."
    fi
}

# Header
# ------------------------------------------------
echo '------------------------------------------------'
bash "$SCRIPT_DIR/details.sh"
echo '------------------------------------------------'

# Update git submodules (harmless no-op when there are none)
# ------------------------------------------------
git -C "$SCRIPT_DIR" submodule update --init --recursive

# Per-tool prompts
# ------------------------------------------------
configure_if_wanted "zsh"     "$SCRIPT_DIR/zsh/setup_zsh.sh"
configure_if_wanted "neovim"  "$SCRIPT_DIR/neovim/setup_neovim.sh"
configure_if_wanted "tmux"    "$SCRIPT_DIR/tmux/setup_tmux.sh"
configure_if_wanted "kitty"   "$SCRIPT_DIR/kitty/setup_kitty.sh"
configure_if_wanted "yazi"    "$SCRIPT_DIR/yazi/setup_yazi.sh"
configure_if_wanted "lazygit" "$SCRIPT_DIR/lazygit/setup_lazygit.sh"
configure_if_wanted "claude"  "$SCRIPT_DIR/claude/setup_claude.sh"

echo
echo '------------------------------------------------'
echo -e "${CYAN}All done.${NO_COLOR}"
