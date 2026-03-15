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
