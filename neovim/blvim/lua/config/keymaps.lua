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
-- Unified Floating Terminal System
----------------------------------------------------------------------

-- The global style for every terminal we open
local float_opts = {
  win = {
    style = "float",
    border = "rounded",
    width = 0.8,
    height = 0.8,
  },
  id = "unified_float",
}

-- Overwrite the default LazyVim Ctrl+/ to strictly use our unified floating ID
map({ "n", "t" }, "<c-/>", function()
  Snacks.terminal.toggle(nil, float_opts)
end, { desc = "Toggle Terminal (Float)" })

map({ "n", "t" }, "<c-_>", function() -- which_key / terminal fallback
  Snacks.terminal.toggle(nil, float_opts)
end, { desc = "which_key_ignore" })


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

-- RUN
map("n", "<leader>rp", function()
  -- Kill the unified float if it exists so we can hijack it cleanly for a new run
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == "snacks_terminal" then
      if vim.b[buf].snacks_terminal_id == "unified_float" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
  
  local cmd = get_sandbox_cmd(false) .. "; echo \"\\n[Process Exited]\"; read"
  Snacks.terminal.open(cmd, float_opts)
end, { desc = "Run Python Script (Sandbox)" })

-- DEBUG
map("n", "<leader>rd", function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == "snacks_terminal" then
      if vim.b[buf].snacks_terminal_id == "unified_float" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
  
  local cmd = get_sandbox_cmd(true)
  Snacks.terminal.open(cmd, float_opts)
end, { desc = "Debug Python Script (Sandbox)" })

