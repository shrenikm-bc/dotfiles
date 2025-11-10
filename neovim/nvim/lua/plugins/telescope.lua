local KEYMAP_OPTS = { noremap = true, unique = false, silent = true }

return {
	"nvim-telescope/telescope.nvim",
	name = "telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		build = "make",
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-tree/nvim-web-devicons", enabled = true },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<C-h>"] = "which_key",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
					},
				},
			},
			pickers = {},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})
		require("telescope").load_extension("ui-select")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>fs", builtin.grep_string, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>fl", builtin.live_grep, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>fb", builtin.buffers, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>fc", builtin.command_history, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>fr", builtin.resume, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>fg", builtin.git_status, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, KEYMAP_OPTS)
	end,
}
