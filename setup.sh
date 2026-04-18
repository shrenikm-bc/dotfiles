#!/bin/bash

# Initial checks and setup
# ------------------------------------------------

# Defining colors
# ------------------------------------------------
RED='\033[0;31m'
CYAN='\033[1;36m'
LIGHT_PURPLE='\033[1;35m'
NO_COLOR='\033[0m'

# Checking if this script is run from the repo
VERSION_FILE=details.sh
if ! [ -f "$VERSION_FILE" ]; then
    echo -e "${RED}This executable must be run from the main repo directory.${NO_COLOR}"
    exit 0
fi

# Printing the details
echo '------------------------------------------------'
./details.sh
echo '------------------------------------------------'
echo -e '\n'

# Update submodules
# ------------------------------------------------
git submodule update --init --recursive


# Zsh setup
# ------------------------------------------------

echo 'Setting up zsh ...'
if ! [ -x "$(command -v zsh)" ]; then
    echo 'Zshell is not installed. Installing ...'
    sudp apt install zsh
else
    echo 'Zshell is installed'
fi

# Path for zshrc symlink
ZSHRC_SYSTEM=~/.zshrc
# Path for the actual zshrc in the repo
ZSHRC_REPO=$(pwd)/zsh/.zshrc

# Checking if the symlink exists and creating one if it doesn't
if [ -L "$ZSHRC_SYSTEM" ]; then
    echo 'Zshrc symlink already exists. Replacement must be done manually.'
else
    echo 'Zshrc symlink does not exist. Creating one ...'
    # As the shell keep creating an rc file, we need a hard link
    ln $ZSHRC_REPO $ZSHRC_SYSTEM
    echo -e "${CYAN}Zsh has been setup. Restart the terminal or source the .zshrc file.${NO_COLOR}"
fi

# oh-my-zsh
OH_MY_ZSH_DIR=~/.oh-my-zsh
if [ -d "$OH_MY_ZSH_DIR" ]; then
    echo 'Oh-my-zsh is already installed.'
else
    echo 'Oh-my-zsh is not installed. Installing ...'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "${CYAN}Oh-my-zsh has been installed.${NO_COLOR}"
fi

echo -e '\n'

# Neovim setup
# ------------------------------------------------

echo 'Setting up neovim ...'
if ! [ -x "$(command -v nvim)" ]; then
    echo 'Neovim is not installed. Installing ...'
    sudo apt install neovim
    sudo apt install python-neovim
    sudo apt install python3-neovim
else
    echo 'Neovim is installed'
    nvim --version | head  -n 1
fi

# Directory to house the nvim config files
mkdir -p ~/.config/nvim
# Sessions directory so that mksession sessions may be stored (Else the mappings throw an error)
mkdir -p ~/.config/nvim/sessions

# Path for vimrc (init.vim) symlink
VIMRC_SYSTEM=~/.config/nvim/init.vim
# Path for the actual vimrc (init.vim) in the repo
VIMRC_REPO=$(pwd)/neovim/init.vim

# Checking if the symlink exists and creating one if it doesn't
if [ -L "$VIMRC_SYSTEM" ]; then
    echo 'Neovim config file symlink already exists. Replacement must be done manually.'
else
    echo 'Neovim config symlink does not exist. Creating one ...'
    ln -s $VIMRC_REPO $VIMRC_SYSTEM
    echo -e "${CYAN}Neovim has been setup. Run :PlugInstall to install the plugins${NO_COLOR}"
fi

# nvim / lvim shims so $EDITOR resolves in non-zsh contexts (yazi, git, cron).
mkdir -p ~/.local/bin
for shim in nvim lvim; do
    SHIM_SYSTEM=~/.local/bin/$shim
    SHIM_REPO=$(pwd)/bin/$shim
    if [ -L "$SHIM_SYSTEM" ]; then
        echo "$shim shim symlink already exists. Replacement must be done manually."
    else
        echo "$shim shim symlink does not exist. Creating one ..."
        ln -s $SHIM_REPO $SHIM_SYSTEM
    fi
done

echo -e '\n'

# Tmux setup
# ------------------------------------------------

echo 'Setting up tmux ...'
if ! [ -x "$(command -v tmux)" ]; then
    echo 'Tmux is not installed. Installing ...'
    sudo apt install tmux
else
    echo 'Tmux is installed'
    tmux -V | head -n 1
fi

# Directory to house the tmux config files and plugins
mkdir -p ~/.tmux
mkdir -p ~/.tmux/plugins

# Path for the tmux config symlinks
TMUX_SYSTEM_CONF=~/.tmux.conf
TMUX_SYSTEM_CONF_LOCAL=~/.tmux.conf.local
# Path for the actual tmux config files in the repo
TMUX_REPO_CONF=$(pwd)/tmux/.tmux.conf
TMUX_REPO_CONF_LOCAL=$(pwd)/tmux/.tmux.conf.local
TMUX_SETUP=false

# Checking if the symlinks exist and creating them if they don't
if [ -L "$TMUX_SYSTEM_CONF" ]; then
    echo 'Tmux main config file symlink already exists. Replacement must be done manually.'
else
    echo 'Tmux main config symlink does not exist. Creating one ...'
    ln -s $TMUX_REPO_CONF $TMUX_SYSTEM_CONF
    TMUX_SETUP=true
fi

if [ -L "$TMUX_SYSTEM_CONF_LOCAL" ]; then
    echo 'Tmux main config file symlink already exists. Replacement must be done manually.'
else
    echo 'Tmux main config symlink does not exist. Creating one ...'
    ln -s $TMUX_REPO_CONF_LOCAL $TMUX_SYSTEM_CONF_LOCAL
    TMUX_SETUP=true
fi

TMUX_TPM_DIR=~/.tmux/plugins/tpm
# Installing TPM for tmux plugin management. Cloning the repo if it doesn't exist
if [ -d "$TMUX_TPM_DIR" ]; then
    echo 'Tmux plugin manager has already been installed.'
else
    echo 'Installing the tmux plugin manager.'
    git clone https://github.com/tmux-plugins/tpm $TMUX_TPM_DIR
    echo -e "${CYAN}TPM has been setup. Source the tmux.conf file to install the plugins.${NO_COLOR}"
fi

if [ "$TMUX_SETUP" = true ]; then
    echo -e "${CYAN}Tmux has been setup.${NO_COLOR}"
fi
