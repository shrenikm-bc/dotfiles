local KEYMAP_OPTS = { noremap = true, unique = false, silent = true }

return {
	{
		"nvimtools/none-ls.nvim",
		name = "none-ls",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					-- Code actions
					-- For lua
					null_ls.builtins.formatting.stylua,
					-- For CMake
					null_ls.builtins.formatting.cmake_format,
					-- For C/C++
					null_ls.builtins.formatting.clang_format,
					-- For python imports
					null_ls.builtins.formatting.isort,
					-- For codeblocks inside markdown
					null_ls.builtins.formatting.cbfmt,
					-- For markdown linting (Could optionally use mdformat)
					null_ls.builtins.formatting.markdownlint,
					-- For bash
					null_ls.builtins.formatting.shfmt,
					-- For yaml
					null_ls.builtins.formatting.yamlfmt,
					-- For xml
					null_ls.builtins.formatting.xmllint,
				},
			})

			-- Keybindings
			vim.keymap.set("n", "<space>f", vim.lsp.buf.format, KEYMAP_OPTS)
		end,
	},
	-- Primarily used to auto install Mason linters and formatters. mason-lspconfig cannot be used for this
	-- as it can only ensure install LSPs.
	{
		"jay-babu/mason-null-ls.nvim",
		name = "mason-null_ls",
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua",
					"cmake_format",
					"clang_format",
					"isort",
					"cbfmt",
					"markdownlint",
					"shfmt",
					"yammlfmt",
					"xmllint",
				},
				-- Automatically install masons tools based on selected sources in null-ls.
				automatic_installation = true,
			})
		end,
	},
}
