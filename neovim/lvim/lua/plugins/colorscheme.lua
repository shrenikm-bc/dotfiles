return {
  {
    "sainnhe/sonokai",
    name = "sonokai",
    priority = 1000,
    config = function()
      -- atlantis, andromeda, shusia, maia, espresso
      vim.g.sonokai_style = "maia"
      vim.g.sonokai_better_performance = true
    end,
  },

  -- Configure LazyVim to load the required colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "sonokai",
    },
  },
}
