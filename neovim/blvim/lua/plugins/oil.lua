return {
  "stevearc/oil.nvim",
  opts = {},
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function()
    require("oil").setup({
      keymaps = {
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["q"] = { "actions.close", mode = "n" },
        -- Search inside the directory Oil is currently showing
        ["sg"] = function()
          local dir = require("oil").get_current_dir()
          if dir then
            require("telescope.builtin").live_grep({ cwd = dir })
          end
        end,
        -- Search and Replace inside the directory Oil is currently showing using grug-far
        ["sr"] = function()
          local dir = require("oil").get_current_dir()
          if dir then
            require("grug-far").open({ prefills = { paths = dir } })
          end
        end,
      },
      view_options = {
        show_hidden = true,
      },
      -- Floating window configuration
      float = {
        padding = 0,
      },
      -- There isn't an open_float action, so we use a separate binding outside keymaps.
      vim.keymap.set("n", "-", require("oil").open_float, { noremap = true, unique = false, silent = true }),
    })
  end,
}
