-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Hide tmux status bar only when the active window is running Neovim.
-- Uses tmux hooks so switching to another window restores the status bar,
-- and switching back hides it again (session-wide toggle is unavoidable,
-- but the hooks keep it in sync with whichever window is focused).
local group = vim.api.nvim_create_augroup("tmux_status_toggle", { clear = true })

vim.schedule(function()
  if vim.fn.executable("tmux") == 1 then
    vim.fn.system("tmux set status off")
    -- Session-level hook: fires every time the active window changes.
    -- Checks if the newly focused pane is running nvim and toggles accordingly.
    vim.fn.system([[tmux set-hook session-window-changed 'if -F "#{m:*nvim*,#{pane_current_command}}" "set status off" "set status on"']])
  end
end)

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    vim.fn.system("tmux set status on")
    vim.fn.system("tmux set-hook -u session-window-changed")
  end,
})
