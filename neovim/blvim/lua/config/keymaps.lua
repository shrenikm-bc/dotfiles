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

  local clean_container_path = ""
  if end_idx then
    clean_container_path = string.sub(absolute_file_path, end_idx + 1)
  else
    clean_container_path = vim.fn.expand("%:t")
  end

  local container_project_path = "/opt/shining_software"

  local full_cmd = ""
  if is_debug then
    full_cmd = string.format(
      "ssh -Y -t sandbox '/bin/bash -lc \"cd %s && PYTHONPATH=/usr/local/local/lib/python3.12/dist-packages:\\$PYTHONPATH python3 -m debugpy --listen 0.0.0.0:5678 --wait-for-client %s\"'",
      container_project_path,
      clean_container_path
    )
  else
    full_cmd = string.format(
      "ssh -Y -t sandbox '/bin/bash -lc \"cd %s && python3 %s\"'",
      container_project_path,
      clean_container_path
    )
  end
  return full_cmd
end

local term_opts = {
  win = { style = "float", border = "rounded", width = 0.8, height = 0.8 },
  id = "python_runner_debugger",
}

-- RUN
map("n", "<leader>rp", function()
  -- Force kill any existing background runner so we start fresh
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "snacks_terminal" then
      if vim.b[buf].snacks_terminal_id == "python_runner_debugger" then
         vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
  
  local cmd = get_sandbox_cmd(false) .. "; echo \"\\n[Process Exited]\"; read"
  Snacks.terminal(cmd, term_opts)
end, { desc = "Run Python Script inside nspawn sandbox" })

-- DEBUG
map("n", "<leader>rd", function()
  -- Force kill any existing background runner so we start fresh
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "snacks_terminal" then
      if vim.b[buf].snacks_terminal_id == "python_runner_debugger" then
         vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
  
  local cmd = get_sandbox_cmd(true)
  Snacks.terminal(cmd, term_opts)
end, { desc = "Debug Python Script inside nspawn sandbox" })

-- TOGGLE
map({ "n", "t" }, "<leader>rt", function()
  Snacks.terminal.toggle(nil, term_opts)
end, { desc = "Toggle Python Terminal" })

