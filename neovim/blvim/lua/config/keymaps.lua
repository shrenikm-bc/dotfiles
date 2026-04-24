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

-- Global Organize Imports. Set globally (not buffer-local per-LSP) so diffview's
-- buffer-local `<leader>co` (conflict_choose("ours")) wins inside diffview tabs.
map("n", "<leader>co", function()
  LazyVim.lsp.action["source.organizeImports"]()
end, { desc = "Organize Imports" })

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
    -- Dynamically find the path to debugpy on the host machine
    local handle = io.popen('python3 -c "import debugpy; print(debugpy.__path__[0])" 2>/dev/null')
    if not handle then
      return nil, "Failed to execute python3 command to find debugpy"
    end
    local debugpy_host_path = handle:read("*a"):gsub("%s+", "")
    handle:close()

    if debugpy_host_path == "" then
      return nil, "debugpy is not installed in the host's active Python environment! (pip install debugpy)"
    end

    -- Scping `debugpy_host_path` to `/tmp/debugpy_inject/debugpy`.

    local scp_cmd = string.format(
      'echo "Injecting debugpy..." && ssh sandbox "mkdir -p /tmp/debugpy_inject" && scp -q -r %s sandbox:/tmp/debugpy_inject/debugpy',
      debugpy_host_path
    )

    inner_cmd = string.format(
      "cd %s && PYTHONPATH=/tmp/debugpy_inject:\\$PYTHONPATH python3 -m debugpy --listen 0.0.0.0:5678 --wait-for-client %s",
      container_project_path,
      clean_container_path
    )

    return string.format("%s && ssh -Y -t sandbox '/bin/bash -lc \"%s\"'", scp_cmd, inner_cmd), nil
  else
    inner_cmd = string.format("cd %s && python3 %s", container_project_path, clean_container_path)
    return string.format("ssh -Y -t sandbox '/bin/bash -lc \"%s\"'", inner_cmd), nil
  end
end

-- Shared floating style for EVERYTHING
local float_opts = {
  win = { style = "float", border = "rounded", width = 0.8, height = 0.8 },
}

-- 1. Override the default LazyVim Ctrl+/ terminal to open a shell inside the sandbox container
local container_shell_cmd = "ssh sandbox"
map({ "n", "t" }, "<c-/>", function()
  Snacks.terminal.toggle(container_shell_cmd, vim.tbl_extend("force", float_opts, { id = "sandbox_shell" }))
end, { desc = "Toggle Terminal (Sandbox)" })

map({ "n", "t" }, "<c-_>", function()
  Snacks.terminal.toggle(container_shell_cmd, vim.tbl_extend("force", float_opts, { id = "sandbox_shell" }))
end, { desc = "which_key_ignore" })

-- 2. <leader>rp opens a floating run terminal.
map("n", "<leader>rp", function()
  local cmd, err = get_sandbox_cmd(false)
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  cmd = cmd .. '; echo "\\n[Process Exited]"; read'
  Snacks.terminal.toggle(
    cmd,
    vim.tbl_extend("force", float_opts, { id = "sandbox_python_runner", interactive = false })
  )
end, { desc = "Run Python Script inside nspawn sandbox" })

-- DEBUG
map("n", "<leader>rd", function()
  local cmd, err = get_sandbox_cmd(true)
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  Snacks.terminal.toggle(
    cmd,
    vim.tbl_extend("force", float_opts, { id = "sandbox_python_debugger", interactive = false })
  )
end, { desc = "Debug Python Script inside nspawn sandbox" })
