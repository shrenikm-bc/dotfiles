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
