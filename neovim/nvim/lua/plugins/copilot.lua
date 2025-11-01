local KEYMAP_OPTS = { noremap = true, unique = false, silent = true }

return {
	"zbirenbaum/copilot.lua",
	name = "copilot",
	lazy = false,
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = "<M-k>",
					jump_next = "<M-j>",
					accept = "<Tab>",
					refresh = "<leader>gcr",
					open = "<M-CR>",
				},
				layout = {
					-- top | left | right | bottom
					position = "right",
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 75,
				keymap = {
					accept = false,
					accept_word = false,
					accept_line = false,
					next = "<M-j>",
					prev = "<M-k>",
					dismiss = "<M-;>",
				},
			},
			-- Override some of the defaults
			filetypes = {
				yaml = true,
				markdown = true,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = "node", -- Node.js version must be > 18.x
			server_opts_overrides = {},
		})

		-- Explicitly setting the <Tab> mapping to complete suggestions to get super-tab like behavior.
		-- If we don't do this, the plugin will hijack the <Tab> key in insert mode and we won't be able to use it for regular tabbing.
		-- See: https://github.com/zbirenbaum/copilot.lua/discussions/153
		local copilot_suggestion = require("copilot.suggestion")
		local function smart_tab()
			if copilot_suggestion.is_visible() then
				copilot_suggestion.accept()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
			end
		end
		vim.keymap.set("i", "<Tab>", smart_tab, KEYMAP_OPTS)
	end,
}
