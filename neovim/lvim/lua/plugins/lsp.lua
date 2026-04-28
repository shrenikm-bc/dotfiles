return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
          -- `<leader>co` is bound globally in keymaps.lua so diffview's
          -- buffer-local `<leader>co` (conflict_choose("ours")) wins inside
          -- a diffview tab without a per-LSP buffer-local binding racing it.
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
