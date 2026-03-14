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

----------------------------------------------------------------------
-- Python Sandbox Runner & Debugger
----------------------------------------------------------------------

local function get_sandbox_cmd(is_debug)
  local absolute_file_path = vim.fn.expand("%:p")
  local start_idx, end_idx = string.find(absolute_file_path, "/src/")

  local clean_container_path = end_idx and string.sub(absolute_file_path, end_idx + 1) or vim.fn.expand("%:t")
  local container_project_path = "/opt/shining_software"

  local inner_cmd = ""
  if is_debug then
    inner_cmd = string.format("cd %s && PYTHONPATH=/usr/local/local/lib/python3.12/dist-packages:\\$PYTHONPATH python3 -m debugpy --listen 0.0.0.0:5678 --wait-for-client %s", container_project_path, clean_container_path)
  else
    inner_cmd = string.format("cd %s && python3 %s", container_project_path, clean_container_path)
  end

  return string.format("ssh -Y -t sandbox '/bin/bash -lc \"%s\"'", inner_cmd)
end

-- Shared floating style for EVERYTHING
local float_opts = {
  win = { style = "float", border = "rounded", width = 0.8, height = 0.8 },
}

-- 1. Override the default LazyVim Ctrl+/ terminal to be a floating window
map({ "n", "t" }, "<c-/>", function()
  Snacks.terminal(nil, float_opts)
end, { desc = "Toggle Terminal (Float)" })

map({ "n", "t" }, "<c-_>", function()
  Snacks.terminal(nil, float_opts)
end, { desc = "which_key_ignore" })


-- 2. <leader>rp opens a floating run terminal. If it exists, it toggles it back instead of running again!
map("n", "<leader>rp", function()
  -- If we just call toggle with our specific ID, it will create it if it doesn't exist,
  -- and bring it back if it is hidden!
  local cmd = get_sandbox_cmd(false) .. "; echo \"\\n[Process Exited]\"; read"
  Snacks.terminal.toggle(cmd, vim.tbl_extend("force", float_opts, { id = "sandbox_python_runner" }))
end, { desc = "Run Python Script inside nspawn sandbox" })

-- DEBUG
map("n", "<leader>rd", function()
  local cmd = get_sandbox_cmd(true)
  Snacks.terminal.toggle(cmd, vim.tbl_extend("force", float_opts, { id = "sandbox_python_debugger" }))
end, { desc = "Debug Python Script inside nspawn sandbox" })

