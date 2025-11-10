-- TODO: Maybe a way to set available colorschemes as a global variable and run the
-- colorscheme command automatically

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
      -- vim.cmd([[colorscheme catppuccin-mocha]])
    end,
  },
  {
    "sainnhe/sonokai",
    name = "sonokai",
    priority = 1000,
    config = function()
      -- atlantis, andromeda, shusia, maia, espresso
      vim.g.sonokai_style = "maia"
      vim.g.sonokai_better_performance = true
      vim.cmd([[colorscheme sonokai]])
    end,
  },
}
