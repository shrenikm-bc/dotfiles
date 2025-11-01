local KEYMAP_OPTS = { noremap = true, unique = false, silent = true }

return {
	"stevearc/oil.nvim",
	name = "oil",
	dependencies = {
		"echasnovski/mini.icons",
	},
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			columns = {
				"icon",
				-- Uncomment to see size and date.
				--"size",
				--"mtime",
			},
			delete_to_trash = true,
			skip_confirm_for_simple_edits = false,
			prompt_save_on_select_new_entry = true,
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-v>"] = {
					"actions.select",
					opts = { vertical = true },
					desc = "Open the entry in a vertical split",
				},
				["<C-h>"] = {
					"actions.select",
					opts = { horizontal = true },
					desc = "Open the entry in a horizontal split",
				},
				["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
				["<C-p>"] = "actions.preview",
				["q"] = "actions.close",
				["<C-l>"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
			view_options = {
				show_hidden = true,
			},
			-- Floating window config
			float = {
				-- Padding around the floating window
				padding = 2,
				max_width = 0,
				max_height = 0,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
				-- preview_split: Split direction: "auto", "left", "right", "above", "below".
				preview_split = "auto",
				-- This is the config that will be passed to nvim_open_win.
				-- Change values here to customize the layout
				override = function(conf)
					return conf
				end,
			},
		})

		-- Open parent directory in current window
		--vim.keymap.set("n", "-", "<CMD>Oil<CR>", KEYMAP_OPTS)
		vim.keymap.set("n", "-", require("oil").open_float, KEYMAP_OPTS)

		-- Open parent directory in current window
		--vim.keymap.set("n", "<space>-", "<CMD>Oil<CR>", KEYMAP_OPTS)
	end,
}
