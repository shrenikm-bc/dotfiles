-- Required parsers
REQUIRED_PARSERS =
	{ "vim", "vimdoc", "markdown", "cmake", "c", "cpp", "python", "bash", "lua", "luadoc", "regex", "yaml", "xml" }

return {
	"nvim-treesitter/nvim-treesitter",
	name = "nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = REQUIRED_PARSERS,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
		})
	end,
}
