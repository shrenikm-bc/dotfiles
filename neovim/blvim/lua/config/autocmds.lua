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

-- Because of how LazyVim loads, plugin configs and autocmds are loaded after VimEnter is triggered, so we can't really use this to set up an autocmd for VimEnter.
-- Instead, to disable the tmux statusline when Neovim starts, we schedule a function.
vim.schedule(function()
  if vim.fn.executable("tmux") == 1 then
    vim.fn.system("tmux set status off")
  end
end)

-- Re-enabling is business as usual.
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    vim.fn.system("tmux set-option status on")
  end,
})
