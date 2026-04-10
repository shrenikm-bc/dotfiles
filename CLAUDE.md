# Project: Dotfiles

The project holds personal dotfile configurations for various things like editors, terminal emulators, etc.

## Stack
Editor: Neovim (specifically LazyVim)
Interpreter: Zsh
Terminal Emulator: Kitty
Terminal Multiplexer: Tmux
Miscellaneous:
  - Ranger (Not used)
  - Yazi (No configuration yet)

## Architecture

The dotfiles are symlinked to the respective paths in the home directory.


## Neovim

We have multiple neovim configurations (directories nvim, lvim, etc).
nvim - Previous from scratch neovim configuration (This has been deprecated)
lvim - LazyVim configuration which is currently being used. This is used for most regular python projects.
blvim - LazyVim configuration which is also being used. This one is used for the "shining_software" project which has some configurations for working with nspawn containers.

These are symlinked to separate config directories and have separate aliases that point to them.
Please check .zshrc for details here.
