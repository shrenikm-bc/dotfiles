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
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# -----------------------------------------------------------

# Prompt: show active conda env
# -----------------------------------------------------------
# Conda's own PS1 mutation is disabled via `conda config --set changeps1 false`
# because it doesn't survive direnv's subshell activation. We render
# $CONDA_DEFAULT_ENV into PROMPT ourselves.
#
# The precmd hook + _ORIGINAL_PROMPT snapshot is specifically to appease
# af-magic: its afmagic_dashes function greps $PS1 for the literal string
# `(envname)` so it can subtract that width from the top dashes line. With
# a PROMPT_SUBST one-liner, PS1 stores the unexpanded template, the grep
# misses, dashes run full-width, and the `(envname)` prefix wraps to a new
# line. Rebuilding PROMPT with the literal env name pre-substituted avoids
# the wrap.
#
# If you switch themes: drop this entire block and use a plain one-liner
#     PROMPT='%F{yellow}${CONDA_DEFAULT_ENV:+($CONDA_DEFAULT_ENV) }%f'$PROMPT
# — or, if the new theme has a built-in conda segment, use that.
_ORIGINAL_PROMPT=$PROMPT
_conda_prompt_update() {
    PROMPT="${CONDA_DEFAULT_ENV:+%F{yellow\}($CONDA_DEFAULT_ENV)%f }${_ORIGINAL_PROMPT}"
}
precmd_functions+=(_conda_prompt_update)
# -----------------------------------------------------------

# Node config
# -----------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# -----------------------------------------------------------


# Direnv
# -----------------------------------------------------------
# Must come AFTER conda init so direnvrc layouts can source conda.sh.
# Empty DIRENV_LOG_FORMAT silences the "loading .envrc / exporting ..." chatter
# (and the trailing blank line) on every cd.
export DIRENV_LOG_FORMAT=
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi
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
