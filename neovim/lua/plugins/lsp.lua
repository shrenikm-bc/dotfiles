-- Plugins for everything LSP

local function on_attach_ruff(client, bufnr)
	-- Disable hover in favor of Pyright.
	client.server_capabilities.hoverProvider = false
end

-- List of all required language servers and their options.
LS_CONFIG = {
	-- For Vim
	vimls = {},
	-- For CMake
	cmake = {},
	-- For C/C++
	clangd = {},
	-- For Python
	ruff = {
		on_attach = on_attach_ruff,
	},
	pyright = {
		settings = {
			pyright = {
				-- Using Ruff's import organizer instead of Pyright's
				disableOrganizeImports = true,
			},
			python = {
				analysis = {
					-- Ignore all files for analysis to exclusively use Ruff for linting
					ignore = { "*" },
				},
			},
		},
	},
	-- For Shell
	bashls = {},
	-- For Lua
	lua_ls = {},
	-- For YAML
	yamlls = {},
	-- For XML
	lemminx = {},
	-- For TOML
	taplo = {},
	-- For Grammar
	harper_ls = {
		filetypes = { "vim", "lua", "cmake", "c", "cpp", "python", "sh", "yaml", "xml", "markdown", "text", "toml" },
	},
}

-- Extract the list of required language servers to be added to ensure_installed.

REQUIRED_LS = {}
for ls, _ in pairs(LS_CONFIG) do
	table.insert(REQUIRED_LS, ls)
end

return {
	{
		"williamboman/mason.nvim",
		name = "mason",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		name = "mason-lspconfig",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = REQUIRED_LS,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		name = "nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("on-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func)
						vim.keymap.set(
							"n",
							keys,
							func,
							{ buffer = event.buf, noremap = true, unique = false, silent = true }
						)
					end

					--  Jump to where the variable/function was first declared/defined. <C-t> to jump back.
					map("gd", require("telescope.builtin").lsp_definitions)

					-- Jump to declaration (In C++, this points to the header).
					map("gD", vim.lsp.buf.declaration)

					-- Find references for the word under the cursor
					map("gr", require("telescope.builtin").lsp_references)

					--  Jump to implementation of the variable/function. Useful for languages that can declare types without implementations.
					map("gi", require("telescope.builtin").lsp_implementations)

					--  Jump to the type of the variable (Definition of its type not where it was defined).
					map("gt", require("telescope.builtin").lsp_type_definitions)

					--  Finds list of all symbols (variables, functions, etc) in the current document.
					map("<space>ds", require("telescope.builtin").lsp_document_symbols)

					--  Finds list of all symbols in the current workspace.
					map("<space>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols)

					--  Rename variable.
					map("<space>rn", vim.lsp.buf.rename)

					-- Execute code action.
					map("<space>ca", vim.lsp.buf.code_action)

					--  Popup that displays documentation.
					map("K", vim.lsp.buf.hover)
				end,
			})

			-- Setup for each language server.
			local lspconfig = require("lspconfig")

			-- Cross dependency with completions. Not really avoidable.
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			for ls, config in pairs(LS_CONFIG) do
				config.capabilities = capabilities
				lspconfig[ls].setup({
					config,
				})
			end
		end,
	},
}
