-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Save
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
-- Save all
map("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save All" })
-- Quit
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
-- Quit all
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit All" })
