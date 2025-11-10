local KEYMAP_OPTS = { noremap = true, unique = false, silent = true }

return {
	"lewis6991/gitsigns.nvim",
	name = "gitsigns",
	config = function()
		require("gitsigns").setup({
			signs_staged_enable = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 100,
			},

			-- Keymappings. Using only the hunk preview for now (Used to preview the git signs status on the left)
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				KEYMAP_OPTS["buffer"] = bufnr
				vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, KEYMAP_OPTS)
				vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, KEYMAP_OPTS)
				vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, KEYMAP_OPTS)
				vim.keymap.set("n", "<leader>hb", gitsigns.toggle_current_line_blame, KEYMAP_OPTS)
				vim.keymap.set("n", "<leader>hB", function()
					gitsigns.blame_line({ full = true })
				end, KEYMAP_OPTS)
				vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, KEYMAP_OPTS)
				vim.keymap.set("n", "<leader>hD", function()
					gitsigns.diffthis("~")
				end, KEYMAP_OPTS)
			end,
		})
	end,
}
