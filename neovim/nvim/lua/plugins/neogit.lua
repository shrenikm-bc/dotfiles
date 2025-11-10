return {
	"NeogitOrg/neogit",
	name = "neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		-- TODO: Full config
		require("neogit").setup({
			integrations = {
				telescope = true,
				diffview = true,
			},
		})
	end,
}
