-- Give Node.js 8GB of memory to handle heavy third-party packages
vim.env.NODE_OPTIONS = "--max-old-space-size=8192"

-- These are from running sys.path in the sandbox.
container_paths = {
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/opt/catkin/lib/python3/dist-packages"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/opt/ros/noetic/lib/python3/dist-packages"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/opt/shining_software"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/local/lib/python3.12"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/lib/python312.zip"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/lib/python3.12"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/lib/python3.12/lib-dynload"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/local/lib/python3.12/shining-packages"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/local/lib/python3.12/dist-packages"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/lib/python3/dist-packages"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/local/lib/python3.12/shining-packages/rerun_sdk"),
  vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/lib/python3.12"),
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          before_init = function(params, config)
            config.settings.python.pythonPath =
              vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/bin/python3")
          end,
          settings = {
            basedpyright = {
              analysis = {
                -- Ensure that it uses the libraries from the container
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                extraPaths = container_paths,
                exclude = {
                  "**/node_modules",
                  "**/__pycache__",
                  "**/.pytest_tmp",
                  "**/.pytest_cache",
                  "**/.mypy_cache",
                  "**/build",
                  "**/dist",
                  "**/bazel-*",
                  "**/.git",
                },
                ignore = {
                  "**/node_modules",
                  "**/__pycache__",
                  "**/.pytest_tmp",
                  "**/.pytest_cache",
                  "**/.mypy_cache",
                  "**/build",
                  "**/dist",
                },
              },
            },
            python = {},
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
