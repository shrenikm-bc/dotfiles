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

    -- Scope file/grep pickers to the directory currently shown in the oil buffer.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function(args)
        local function oil_dir()
          return require("oil").get_current_dir(args.buf)
        end
        local function pick(cmd, desc)
          return function()
            local dir = oil_dir()
            if not dir then
              return
            end
            LazyVim.pick(cmd, { cwd = dir })()
          end
        end
        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set(
          "n",
          "<leader>ff",
          pick("files", "Find Files"),
          vim.tbl_extend("force", opts, { desc = "Find Files (oil dir)" })
        )
        vim.keymap.set(
          "n",
          "<leader>fF",
          pick("files", "Find Files"),
          vim.tbl_extend("force", opts, { desc = "Find Files (oil dir)" })
        )
        vim.keymap.set(
          "n",
          "<leader>gs",
          pick("live_grep", "Grep"),
          vim.tbl_extend("force", opts, { desc = "Grep (oil dir)" })
        )
        vim.keymap.set(
          "n",
          "<leader>gS",
          pick("live_grep", "Grep"),
          vim.tbl_extend("force", opts, { desc = "Grep (oil dir)" })
        )
      end,
    })
  end,
}
