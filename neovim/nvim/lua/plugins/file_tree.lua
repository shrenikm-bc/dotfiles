-- Uses nvim-tree
local KEYMAP_OPTS = { noremap = true, unique = false, silent = true }

return {
	"nvim-tree/nvim-tree.lua",
	name = "nvim-tree",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function()
		require("nvim-tree").setup({
			auto_reload_on_write = true,
			disable_netrw = true,
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
			},
			renderer = {
				group_empty = true,
				icons = {
					web_devicons = {
						file = {
							enable = true,
							color = true,
						},
						folder = {
							enable = true,
							color = true,
						},
					},
				},
			},
			filters = {
				dotfiles = false,
				git_ignored = true,
				exclude = {},
			},
		})

		local api = require("nvim-tree.api")
		-- Change horizontal split to Ctrl-h from the default Ctrl-x
		vim.keymap.set("n", "<C-h>", api.node.open.horizontal, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>nt", api.tree.toggle, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>nr", api.tree.reload, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>nf", api.tree.find_file, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>nc", api.tree.collapse_all, KEYMAP_OPTS)
	end,
}
