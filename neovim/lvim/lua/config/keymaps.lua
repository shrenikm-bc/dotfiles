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

-- After toggling a terminal on, send <CR> to nudge the cursor back to the prompt.
local function focus_terminal(term)
  if term and term:valid() then
    vim.schedule(function()
      if term:valid() then
        vim.api.nvim_chan_send(vim.bo[term.buf].channel, "\n")
        vim.cmd("startinsert")
      end
    end)
  end
end

-- Python runner terminal reference
local _python_term = nil

-- Run current python file in a floating terminal (kills previous run, starts fresh)
map("n", "<leader>rp", function()
  if _python_term and _python_term:buf_valid() then
    _python_term:close()
  end
  _python_term = Snacks.terminal.open("python " .. vim.fn.expand("%") .. "; zsh", {
    win = float_win,
  })
end, { desc = "Run Python Script" })

-- Toggle python runner float visibility (preserves process and scrollback)
map({ "n", "t" }, "<leader>rt", function()
  if _python_term and _python_term:buf_valid() then
    _python_term:toggle()
    focus_terminal(_python_term)
  end
end, { desc = "Toggle Python Terminal" })

-- Delete LazyVim default terminal keymaps so we can rebind them
vim.keymap.del({ "n", "t" }, "<c-/>")
vim.keymap.del({ "n", "t" }, "<c-_>")

-- Toggle persistent bottom-split terminal (independent from the python runner float)
local function toggle_split_terminal()
  local term = Snacks.terminal(nil, { cwd = LazyVim.root() })
  focus_terminal(term)
end

map({ "n", "t" }, "<C-/>", toggle_split_terminal, { desc = "Toggle Terminal" })
map({ "n", "t" }, "<C-_>", toggle_split_terminal, { desc = "Toggle Terminal" })
