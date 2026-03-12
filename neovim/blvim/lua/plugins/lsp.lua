REQUIRED_PACKAGES = {
  -- Language servers
  "bash-language-server",
  "vim-language-server",
  "lua-language-server",
  "cmake-language-server",
  "yaml-language-server",
  "clangd",
  "basedpyright",
  "taplo", -- TOML LSP
  "lemminx", -- XML LSP
  "harper-ls", -- Grammar LSP
  -- "copilot-language-server",

  -- Linters/formatters
  "ruff",
}

-- Give Node.js 8GB of memory to handle heavy third-party packages
vim.env.NODE_OPTIONS = "--max-old-space-size=8192"

local rootfs_path = vim.fn.expand("~/shining_software/build/rootfs.shining.generic")
-- Define words we want to filter out of sys.path
local ignore_words = {
  "ros",
  "catkin",
  -- Removes duplicate scanning of the project workspace
  "opt/shining_software",
  -- Prevents scanning raw stdlib (LSP uses internal stubs instead)
  "/usr/lib/python3.12",
}

-- Function to get and dynamically filter paths
local function get_container_paths()
  local cmd =
    'sudo machinectl shell brain@sandbox /bin/bash -lc "python3 -c \\"import sys; print(\'\\n\'.join(sys.path))\\""'

  local output = vim.fn.system(cmd)
  local paths = {}

  -- Parse the output line by line
  for line in output:gmatch("[^\r\n]+") do
    -- Filter out junk: empty lines, the current dir ("."), and zip files
    if line ~= "" and line ~= "." and not line:match("%.zip$") then
      -- Ensure it's an absolute container path (starts with /)
      if line:sub(1, 1) == "/" then
        -- Check if the path contains any of our ignored words
        local keep_path = true
        for _, word in ipairs(ignore_words) do
          if string.find(line, word) then
            keep_path = false
            break
          end
        end

        -- If it passed the filter, glue it together and add it!
        if keep_path then
          table.insert(paths, rootfs_path .. line)
        end
      end
    end
  end

  return paths
end

return {
  {
    "mason.nvim",
    opts = {
      ensure_installed = REQUIRED_LS,
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                -- Ensure that it uses the libraries from the container
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                extraPaths = get_container_paths(),
              },
            },
          },
        },
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
          keys = {
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
          },
        },
        harper_ls = {
          filetypes = { "vim", "lua", "cmake", "c", "cpp", "python", "sh", "yaml", "xml", "markdown", "text", "toml" },
        },
        -- copilot.lua only works with its own copilot lsp server
        copilot = { enabled = false },
      },
      -- setup = {
      --   [ruff] = function()
      --     Snacks.util.lsp.on({ name = ruff }, function(_, client)
      --       -- Disable hover in favor of Pyright
      --       client.server_capabilities.hoverProvider = false
      --     end)
      --   end,
      -- },
    },
  },
}
