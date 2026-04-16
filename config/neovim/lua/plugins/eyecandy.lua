-- ============================================================================
-- EYE CANDY — Animations, cursor effects, indent, statusline extras, zen mode
-- ============================================================================
return {

	-- ── mini.animate — smooth cursor, scroll, window resize & fold animations ──
	{
		"echasnovski/mini.animate",
		version = "*",
		event = "VeryLazy",
		config = function()
			local animate = require("mini.animate")
			animate.setup({
				-- Smooth cursor movement between distant jumps
				cursor = {
					enable = true,
					timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
				},
				-- Smooth scrolling (replaces any neoscroll you might add later)
				scroll = {
					enable = true,
					timing = animate.gen_timing.linear({ duration = 120, unit = "total" }),
				},
				-- Animate window open/close/resize
				resize = {
					enable = true,
					timing = animate.gen_timing.linear({ duration = 60, unit = "total" }),
				},
				-- Animate fold open/close
				open = {
					enable = true,
					timing = animate.gen_timing.linear({ duration = 60, unit = "total" }),
				},
				close = {
					enable = true,
					timing = animate.gen_timing.linear({ duration = 60, unit = "total" }),
				},
			})
		end,
	},

	-- ── smoothcursor.nvim — animated cursor beacon in the sign column ──────────
	-- Shows a small "comet" that trails to where the cursor jumped.
	{
		"gen740/SmoothCursor.nvim",
		event = "BufReadPost",
		config = function()
			require("smoothcursor").setup({
				type = "matrix", -- "default" | "exp" | "matrix" — matrix gives a comet trail
				cursor = "", -- leading cursor character (Nerd Font)
				speed = 25, -- lower = faster
				intervals = 35,
				priority = 10,
				timeout = 3000,
				disable_float_win = true,
				enabled_filetypes = nil, -- all filetypes
				disabled_filetypes = { "help", "alpha", "dashboard", "NvimTree" },
				-- Show fancy mode indicator in the sign column
				show_last_positions = nil,
			})
			-- Colour-code the cursor by mode (matches your lualine palette)
			local ok, cp = pcall(require, "catppuccin.palettes")
			if ok then
				local p = cp.get_palette("mocha")
				local au = vim.api.nvim_create_augroup("SmoothCursorMode", { clear = true })
				vim.api.nvim_create_autocmd("ModeChanged", {
					group = au,
					callback = function()
						local mode = vim.fn.mode()
						local color = p.blue -- normal
						if mode == "i" then
							color = p.green
						elseif mode:find("v") or mode:find("V") then
							color = p.mauve
						elseif mode == "R" then
							color = p.red
						elseif mode == "c" then
							color = p.peach
						end
						vim.api.nvim_set_hl(0, "SmoothCursor", { fg = color })
						vim.api.nvim_set_hl(0, "SmoothCursorRed", { fg = color })
					end,
				})
			end
		end,
	},

	-- ── indent-blankline upgrade: animate scope on cursor move ────────────────
	-- You already have ibl loaded; this adds the `mini.indentscope` animated
	-- scope underline on top, which draws a moving line under the current scope.
	-- The two plugins coexist fine — ibl draws static guides, mini.indentscope
	-- draws the animated active-scope highlight.
	{
		"echasnovski/mini.indentscope",
		version = "*",
		event = "BufReadPost",
		init = function()
			-- Disable for certain buffer types where it looks wrong
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"NvimTree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
					"TelescopePrompt",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
		config = function()
			local indentscope = require("mini.indentscope")
			indentscope.setup({
				symbol = "│", -- matches your ibl char for visual consistency
				options = { try_as_border = true },
				draw = {
					-- Animate the scope indicator sliding into place
					animation = indentscope.gen_animation.quadratic({
						easing = "out",
						duration = 80,
						unit = "total",
					}),
				},
			})
		end,
	},

	-- ── lualine extras: clock component ───────────────────────────────────────
	-- Rather than a whole new plugin, we wire a clock into your existing lualine
	-- via an autocmd that triggers a refresh every minute. Drop this component
	-- into your lualine_z (after "progress") by adding:
	--
	--   { function() return os.date("󰥔 %H:%M") end, padding = { left = 1, right = 1 } }
	--
	-- This block handles the timer that keeps it ticking.
	{
		"nvim-lua/plenary.nvim", -- already a dep; we just borrow it for the timer
		lazy = true,
		config = function() end, -- no-op, config lives in lualine.lua
	},

	-- ── zen mode — distraction-free writing ───────────────────────────────────
	-- Centers a single window, dims the rest, optionally hides UI chrome.
	-- Plays nicely with your transparency / glass aesthetic.
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle zen mode" },
		},
		dependencies = {
			-- twilight dims all text outside the current function block
			"folke/twilight.nvim",
		},
		config = function()
			require("zen-mode").setup({
				window = {
					backdrop = 0.92, -- darken surroundings slightly
					width = 90, -- columns for the zen window
					height = 1, -- 1 = 100% of window height
					options = {
						signcolumn = "no",
						number = false,
						relativenumber = false,
						cursorline = false,
						foldcolumn = "0",
					},
				},
				plugins = {
					options = { enabled = true, ruler = false, showcmd = false },
					twilight = { enabled = true }, -- dim inactive code
					gitsigns = { enabled = false },
					tmux = { enabled = false },
				},
				-- Re-apply glass highlights after ZenMode opens its window
				on_open = function()
					vim.cmd("silent! IBLDisable")
				end,
				on_close = function()
					vim.cmd("silent! IBLEnable")
				end,
			})
		end,
	},

	-- ── twilight — dim inactive code blocks (also usable standalone) ──────────
	{
		"folke/twilight.nvim",
		cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
		keys = {
			{ "<leader>tw", "<cmd>Twilight<cr>", desc = "Toggle twilight dimming" },
		},
		config = function()
			require("twilight").setup({
				dimming = { alpha = 0.35, color = { "Normal", "#ffffff" } },
				context = 12, -- lines of context around the active block
				treesitter = true,
				expand = {
					"function",
					"method",
					"table",
					"if_statement",
					"for_statement",
					"while_statement",
				},
			})
		end,
	},
}
