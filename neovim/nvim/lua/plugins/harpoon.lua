local KEYMAP_OPTS = { noremap = true, unique = false, silent = true }

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		-- Not configuring with Telescope as marker management becomes more difficult.

		-- Add mark.
		vim.keymap.set("n", "<leader>hx", function()
			harpoon:list():add()
		end, KEYMAP_OPTS)
		-- Open list of marks.
		vim.keymap.set("n", "<leader>hm", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, KEYMAP_OPTS)

		-- Goto marks 1-4.
		vim.keymap.set("n", "<leader>h1", function()
			harpoon:list():select(1)
		end, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>h2", function()
			harpoon:list():select(2)
		end, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>h3", function()
			harpoon:list():select(3)
		end, KEYMAP_OPTS)
		vim.keymap.set("n", "<leader>h4", function()
			harpoon:list():select(4)
		end, KEYMAP_OPTS)

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-p>", function()
			harpoon:list():prev()
		end, KEYMAP_OPTS)
		vim.keymap.set("n", "<C-S-n>", function()
			harpoon:list():next()
		end, KEYMAP_OPTS)
	end,
}
