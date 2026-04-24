return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    local actions = require("telescope.actions")
    opts.defaults = opts.defaults or {}
    opts.defaults.mappings = opts.defaults.mappings or {}
    opts.defaults.mappings.i = opts.defaults.mappings.i or {}
    opts.defaults.mappings.n = opts.defaults.mappings.n or {}

    -- c-h/j/k/l preview scrolling. Overrides Telescope's defaults for `<C-j>`
    -- (nop), `<C-k>` (preview_scrolling_right), and `<C-l>` (complete_tag,
    -- which errors "No tag pre-filtering set for this picker" on pickers
    -- without a tag sorter).
    local scroll = {
      ["<C-h>"] = actions.preview_scrolling_left,
      ["<C-j>"] = actions.preview_scrolling_down,
      ["<C-k>"] = actions.preview_scrolling_up,
      ["<C-l>"] = actions.preview_scrolling_right,
    }
    for key, action in pairs(scroll) do
      opts.defaults.mappings.i[key] = action
      opts.defaults.mappings.n[key] = action
    end
  end,
}
