-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Prevent copilot/completion ghost text from causing horizontal scroll.
-- Save the horizontal scroll offset before each insert-mode change and
-- restore it if only virtual text (not the cursor) moved the viewport.
local scroll_group = vim.api.nvim_create_augroup("prevent_virt_text_scroll", { clear = true })
local saved_leftcol = 0

vim.api.nvim_create_autocmd("CursorMovedI", {
  group = scroll_group,
  callback = function()
    local current = vim.fn.winsaveview()
    -- Only restore if the cursor column hasn't actually moved past the viewport edge.
    -- col is 0-indexed cursor byte position; leftcol is the first visible column.
    local win_width = vim.api.nvim_win_get_width(0) - vim.fn.getwininfo(vim.fn.win_getid())[1].textoff
    if current.leftcol > saved_leftcol and current.col < saved_leftcol + win_width then
      current.leftcol = saved_leftcol
      vim.fn.winrestview(current)
    end
    saved_leftcol = vim.fn.winsaveview().leftcol
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = scroll_group,
  callback = function()
    saved_leftcol = vim.fn.winsaveview().leftcol
  end,
})

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
