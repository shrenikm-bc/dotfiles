-- Toggle keymaps for Diffview
vim.keymap.set("n", "<leader>gd", function()
  if next(require("diffview.lib").views) == nil then
    vim.cmd("DiffviewOpen")
  else
    vim.cmd("DiffviewClose")
  end
end, { noremap = true, silent = true, desc = "Toggle Diffview" })

vim.keymap.set("n", "<leader>gR", function()
  vim.cmd("DiffviewRefresh")
end, { noremap = true, silent = true, desc = "Diffview Refresh" })

vim.keymap.set("n", "<leader>gD", function()
  if next(require("diffview.lib").views) == nil then
    vim.cmd("DiffviewFileHistory")
  else
    vim.cmd("DiffviewClose")
  end
end, { noremap = true, silent = true, desc = "Toggle File History" })

return {
  "sindrets/diffview.nvim",
  name = "diffview",
  dependencies = {
    { "nvim-tree/nvim-web-devicons", enabled = true },
  },
  config = function()
    local actions = require("diffview.actions")
    require("diffview").setup({
      -- NOTE: Requires git version > 2.25.1 as Diffview doesn't detect older versions.
      git_cmd = { "git" },
      view = {
        -- Configure the layout and behavior of different types of views.
        -- Available layouts:
        --'diff1_plain'
        --'diff2_horizontal'
        --'diff2_vertical'
        --'diff3_horizontal'
        --'diff3_vertical'
        --'diff3_mixed'
        --'diff4_mixed'
        default = {
          -- Config for changed files, and staged files in diff views.
          layout = "diff2_horizontal",
        },
        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase.
          layout = "diff3_horizontal",
        },
        file_history = {
          -- Config for changed files in file history views.
          layout = "diff2_horizontal",
        },
      },
      keymaps = {
        -- Overriding only the necessary keymaps.
        -- Note: Use g? in any view/split to see all available keymaps for that view.
        view = {
          {
            "n",
            "<leader>cx",
            actions.conflict_choose("none"),
            { desc = "Delete the conflict region" },
          },
          {
            "n",
            "<leader>cX",
            actions.conflict_choose_all("none"),
            { desc = "Delete the conflict region for the whole file" },
          },
        },
      },
    })
  end,
}
