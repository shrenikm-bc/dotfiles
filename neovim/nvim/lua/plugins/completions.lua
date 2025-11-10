return {
	{
		"L3MON4D3/LuaSnip",
		name = "luasnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		name = "nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local luasnip = require("luasnip")
			local cmp = require("cmp")

			-- Function to select the next completion.
			local function select_next_completion(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.locally_jumpable(1) then
					luasnip.jump(1)
				else
					fallback()
				end
			end

			-- Function to select the previous completion.
			local function select_prev_completion(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end

			cmp.setup({
				snippet = {
					-- Snippet engine
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					--completion = cmp.config.window.bordered(),
					--documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-x>"] = cmp.mapping.abort(),

					-- NOTE: The following mappings are luasnip specific.
					-- See the nvim-cmp GitHub wiki for more mapping details.
					-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = true,
								})
							end
						else
							fallback()
						end
					end),

					-- Mapping Ctrl-j to be able to go down the completions list.
					["<C-j>"] = cmp.mapping(select_next_completion, { "i", "s" }),

					-- Mapping Ctrl-k to be able to go up the completions list.
					["<C-k>"] = cmp.mapping(select_prev_completion, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
