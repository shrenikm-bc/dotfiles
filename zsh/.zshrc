# Oh my zsh config
# -----------------------------------------------------------
# Path to your oh-my-zsh installation.
export ZSH="/home/shrenikm/.oh-my-zsh"

ZSH_THEME="af-magic"

plugins=(
  zsh-autosuggestions
  colored-man-pages
  command-not-found
  tmux
  jump
  python
  pip
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
# -----------------------------------------------------------

# Options
# -----------------------------------------------------------
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt correct
setopt multios
setopt globdots
setopt nullglob
# -----------------------------------------------------------

# Keybindings
# -----------------------------------------------------------
# For zsh-autosuggestions
bindkey '^ ' autosuggest-accept
bindkey '^g' autosuggest-toggle
# -----------------------------------------------------------

# Autocomplete
# -----------------------------------------------------------
autoload -Uz compinit
# -----------------------------------------------------------

# Aliases
# -----------------------------------------------------------
# Unalias git-gui so that we can use grip-grab
unalias gg 2>/dev/null

alias gl='git log --oneline --graph --decorate --all'
alias gs='git status'
alias gd='git diff'
alias ga='git add -u'
alias gaa='git add .'
alias gcm='git commit -m'
alias gpo='git push origin'
# -----------------------------------------------------------

# Neovim config
# -----------------------------------------------------------
# The `nvim` and `lvim` commands are provided by shims in ~/.local/bin
# (symlinked from dotfiles/bin/). The shims read the pinned version from
# dotfiles/neovim/version and set NVIM_APPNAME appropriately.
export EDITOR="lvim"
# -----------------------------------------------------------

# Set path variables
# -----------------------------------------------------------
path+=$HOME/.local/bin
path+=$HOME/.cargo/bin
# -----------------------------------------------------------



# Conda
# -----------------------------------------------------------
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# Custom default conda environment
conda activate ai
# -----------------------------------------------------------

# Node config
# -----------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# -----------------------------------------------------------


# Yazi config
# -----------------------------------------------------------
# Resume from the last working directory when calling yazi through 'y'
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
# -----------------------------------------------------------
