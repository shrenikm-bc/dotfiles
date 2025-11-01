local KEYMAP_OPTS = { noremap = true, unique = false, silent = true }

return {
	"karb94/neoscroll.nvim",
	name = "neoscroll",
	config = function()
		local neoscroll = require("neoscroll")
		neoscroll.setup({
			hide_cursor = true, -- Hide cursor while scrolling
			stop_eof = true, -- Stop at <EOF> when scrolling downwards
			respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
			cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further

			-- linear, quadratic, cubic, quartic, quintic, circular or sine
			easing = "sine", -- Default easing function
			pre_hook = nil, -- Function to run before the scrolling animation starts
			post_hook = nil, -- Function to run after the scrolling animation ends
			performance_mode = false, -- Disable "Performance Mode" on all buffers.
		})

		-- Keymaps
		local window_scrolling_easing = "circular"
		local line_scrolling_easing = "linear"
		local keymap = {
			["<C-u>"] = function()
				neoscroll.ctrl_u({ duration = 100, easing = window_scrolling_easing })
			end,
			["<C-d>"] = function()
				neoscroll.ctrl_d({ duration = 100, easing = window_scrolling_easing })
			end,
			["<C-k>"] = function()
				neoscroll.scroll(-0.01, { move_cursor = false, duration = 10, easing = line_scrolling_easing })
			end,
			["<C-j>"] = function()
				neoscroll.scroll(0.01, { move_cursor = false, duration = 10, easing = line_scrolling_easing })
			end,
		}
		local modes = { "n", "v", "x" }
		for key, func in pairs(keymap) do
			vim.keymap.set(modes, key, func, KEYMAP_OPTS)
		end
	end,
}
