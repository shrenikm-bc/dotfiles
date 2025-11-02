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

  -- Linters/formatters
  "ruff",
}

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
