## Setup Instructions

- `nvim/`: Custom from scratch configuration
- `lvim/`: LazyVim configuration (submodule)

Create symbolic links to the desired configuration locations.

```bash
ln -s $(pwd)/nvim ~/.config/nvim
```

```bash
ln -s $(pwd)/lvim ~/.config/lvim
```

The required configuration can then be loaded by:

```bash
alias nvim=NVIM_APPNAME=nvim nvim
```
```bash
alias lvim=NVIM_APPNAME=lvim nvim
```

