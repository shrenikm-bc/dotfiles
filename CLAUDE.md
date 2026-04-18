# Project: Dotfiles

Personal dotfile configurations for editors, terminal emulators, shells, etc.

## Stack
Editor: Neovim (specifically LazyVim)
Interpreter: Zsh
Terminal Emulator: Kitty
Terminal Multiplexer: Tmux
Miscellaneous:
  - Yazi

## Architecture

Config files are symlinked into their canonical locations under `~` by
per-tool setup scripts.

## Setup scripts

Each tool owns an idempotent setup script: `<tool>/setup_<tool>.sh`
(e.g. `zsh/setup_zsh.sh`, `neovim/setup_neovim.sh`). The root `setup.sh`
is a thin dispatcher that prompts y/n for each tool and delegates to the
per-tool script. Every script is runnable standalone and from any cwd.

All setup scripts share a common skeleton — match it when adding a new tool:
- `set -u`, RED/CYAN/YELLOW/NO_COLOR palette, `# ---` section dividers
- A `link_if_missing` helper for symlinks (skips existing links, refuses to
  clobber a real file at the destination)
- Self-locate via `SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"`
- Dependency installs gated on `command -v` / `dpkg -s` / `-d` checks so
  re-runs are no-ops
- End with `"<Name> dotfiles setup complete."` plus an optional CYAN hint

## Neovim

Two configs coexist: `neovim/nvim/` (legacy, from-scratch) and
`neovim/lvim/` (LazyVim, actively used). Only the lvim flow is maintained
by `setup_neovim.sh`.

`nvim` and `lvim` are launched via real executable shims in `bin/`,
symlinked into `~/.local/bin/`. The shims set `NVIM_APPNAME` and exec the
pinned neovim binary. They are NOT zsh aliases — being on PATH means
they resolve from any shell context (yazi, git, cron, `$EDITOR`, sh -c).

Pinned versions for all download-managed tools (neovim, lazygit, yazi)
live in the root-level `versions` file as shell assignments
(`NVIM_VERSION=…`, `LAZYGIT_VERSION=…`, `YAZI_VERSION=…`). Setup scripts
and shims source this file directly. The shims locate the repo at launch
via `readlink -f "$0"`. Upgrade flow: bump the value in `versions`,
re-run the matching `setup_<tool>.sh`.
