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

-- -- Run current python file
-- --map("n", "<leader>rp", "<cmd>vsplit term://python %<cr>", { desc = "Run Python Script (Regular term)" })
-- map("n", "<leader>rp", function()
--   Snacks.terminal("python " .. vim.fn.expand("%") .. "; zsh", {
--     win = {
--       style = "float",
--       border = "rounded",
--       width = 0.8,
--       height = 0.8,
--     },
--     id = "python_runner",
--     kill = true,
--   })
-- end, { desc = "Run Python Script (Snacks terminal)" })

-- Run the python file in sandbox.
vim.keymap.set("n", "<leader>rp", function()
  -- Get the absolute path of the current file
  local absolute_file_path = vim.fn.expand("%:p")

  -- Find where "/src/" is in that absolute path and strip it away
  local start_idx, end_idx = string.find(absolute_file_path, "/src/")

  local clean_container_path = ""
  if end_idx then
    -- Grab everything AFTER "/src/"
    clean_container_path = string.sub(absolute_file_path, end_idx + 1)
  else
    -- Fallback just in case you run this on a file outside of src
    clean_container_path = vim.fn.expand("%:t")
  end

  local container_project_path = "/opt/shining_software"

  local full_cmd = string.format(
    'ssh -Y -t sandbox "/bin/bash -lc \\"cd %s && python3 %s\\""',
    container_project_path,
    clean_container_path
  )

  -- 5. Execute via Snacks
  Snacks.terminal(full_cmd .. "; zsh", {
    win = {
      style = "float",
      border = "rounded",
      width = 0.8,
      height = 0.8,
    },
    id = "python_runner",
    kill = true,
  })
end, { desc = "Run Python Script inside nspawn sandbox" })
