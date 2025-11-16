-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable tmux statusline when entering Neovim and re-enable it when leaving
local group = vim.api.nvim_create_augroup("tmux_status_toggle", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function()
    vim.fn.system("tmux set status off")
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    vim.fn.system("tmux set status on")
  end,
})
