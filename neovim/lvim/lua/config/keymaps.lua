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

-- Run current python file
map("n", "<leader>rp", "<cmd>vsplit term://python %<cr>", { desc = "Run Python Script" })
