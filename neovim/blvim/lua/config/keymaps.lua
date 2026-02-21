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
  -- 1. Get the relative path of the current file (e.g., "src/main.py")
  local relative_path = vim.fn.expand("%")

  -- 2. Define where this project lives INSIDE the container
  -- Make sure this matches the actual path in the sandbox!
  local container_project_path = "/opt/shining_software"

  -- 3. Build the inner command: CD into the project, then run the file
  local inner_cmd = string.format("cd %s && python3 %s", container_project_path, relative_path)

  -- 4. Wrap it in our flawless sudo machinectl command
  local full_cmd = string.format('sudo machinectl shell brain@sandbox /bin/bash -lc "%s"', inner_cmd)

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
