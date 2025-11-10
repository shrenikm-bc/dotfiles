-- Shortcuts to open/close Diffview and file history.
local KEYMAP_OPTS = { noremap = true, unique = false, silent = true }
vim.api.nvim_set_keymap("n", "<leader>do", "<cmd>DiffviewOpen<CR>", KEYMAP_OPTS)
vim.api.nvim_set_keymap("n", "<leader>dk", "<cmd>DiffviewClose<CR>", KEYMAP_OPTS)
vim.api.nvim_set_keymap("n", "<leader>dr", "<cmd>DiffviewRefresh<CR>", KEYMAP_OPTS)
vim.api.nvim_set_keymap("n", "<leader>df", "<cmd>DiffviewFileHistory<CR>", KEYMAP_OPTS)

return {
	"sindrets/diffview.nvim",
	name = "diffview",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", enabled = true },
	},
	config = function()
		local actions = require("diffview.actions")

		require("diffview").setup({
			diff_binaries = false,
			use_icons = true,
			-- NOTE: Requires git version > 2.25.1 as Diffview doesn't seem to detect older versions.
			git_cmd = { "git" },
			view = {
				-- Configure the layout and behavior of different types of views.
				-- Available layouts:
				--    'diff1_plain'
				--    |'diff2_horizontal'
				--    |'diff2_vertical'
				--    |'diff3_horizontal'
				--    |'diff3_vertical'
				--    |'diff3_mixed'
				--    |'diff4_mixed'
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
