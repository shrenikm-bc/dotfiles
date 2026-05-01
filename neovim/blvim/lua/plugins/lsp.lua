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
        pyright = {
          before_init = function(params, config)
            config.settings.python.pythonPath =
              vim.fn.expand("~/shining_software/build/rootfs.shining.generic/usr/bin/python3")
          end,
          settings = {
            python = {
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
        -- pyright remains the primary Python LSP. pylsp is attached purely
        -- for rope-backed refactoring code actions (move symbol, extract,
        -- inline) that pyright does not expose. It runs from a dedicated
        -- venv installed by setup_neovim.sh, so it does not depend on the
        -- active project's conda env.
        pylsp = {
          cmd = { vim.fn.expand("~/.local/share/pylsp-venv/bin/pylsp") },
          settings = {
            pylsp = {
              plugins = {
                -- Disable every provider that would compete with pyright/ruff.
                jedi_completion = { enabled = false },
                jedi_definition = { enabled = false },
                jedi_hover = { enabled = false },
                jedi_references = { enabled = false },
                jedi_signature_help = { enabled = false },
                jedi_symbols = { enabled = false },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                mccabe = { enabled = false },
                flake8 = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                pylsp_mypy = { enabled = false },
                pylsp_black = { enabled = false },
                pylsp_isort = { enabled = false },
                rope_autoimport = { enabled = false },
                rope_completion = { enabled = false },
                -- Leave pylsp-rope (the code-action provider) on its
                -- defaults so refactor actions show up via <leader>ca.
              },
            },
          },
          -- Strip pyright-overlapping capabilities at attach time so this
          -- client only contributes code actions. Belt-and-suspenders on top
          -- of the plugin disables above.
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.completionProvider = nil
            client.server_capabilities.definitionProvider = false
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.documentSymbolProvider = false
            client.server_capabilities.signatureHelpProvider = nil
            client.server_capabilities.renameProvider = false
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.diagnosticProvider = nil
          end,
        },
        harper_ls = {
          filetypes = { "vim", "lua", "cmake", "c", "cpp", "python", "sh", "yaml", "xml", "markdown", "text", "toml" },
          settings = {
            ["harper-ls"] = {
              linters = {
                LongSentences = false,
              },
            },
          },
        },
        -- copilot.lua only works with its own copilot lsp server
        copilot = { enabled = false },
      },
    },
  },
}
