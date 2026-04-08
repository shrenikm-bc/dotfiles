-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Save all
map({ "i", "x", "n", "s" }, "<A-s>", "<cmd>wa<cr><esc>", { desc = "Save All Files" })
-- Quit window
map("n", "<leader>qf", "<cmd>q<cr>", { desc = "Quit Window" })
-- Quit window without saving
map("n", "<leader>qx", "<cmd>q!<cr>", { desc = "Quit Window" })

local float_win = { style = "float", border = "rounded", width = 0.8, height = 0.8 }

-- Python runner terminal reference
local _python_term = nil

-- Run current python file (always kills previous run and starts fresh)
map("n", "<leader>rp", function()
  -- Kill previous python terminal if it exists
  if _python_term and _python_term:buf_valid() then
    _python_term:close()
  end
  _python_term = Snacks.terminal.open("python " .. vim.fn.expand("%") .. "; zsh", {
    win = float_win,
  })
end, { desc = "Run Python Script" })

-- Toggle python runner terminal
map({ "n", "t" }, "<leader>rt", function()
  if _python_term and _python_term:buf_valid() then
    _python_term:toggle()
  end
end, { desc = "Toggle Python Terminal" })

-- Delete LazyVim default terminal keymaps (they open a bottom split)
vim.keymap.del({ "n", "t" }, "<c-/>")
vim.keymap.del({ "n", "t" }, "<c-_>")

-- Toggle general floating terminal (completely independent from python runner)
local function toggle_float_terminal()
  Snacks.terminal(nil, { cwd = LazyVim.root(), win = float_win })
end

map({ "n", "t" }, "<C-/>", toggle_float_terminal, { desc = "Toggle Floating Terminal" })
map({ "n", "t" }, "<C-_>", toggle_float_terminal, { desc = "Toggle Floating Terminal" })
