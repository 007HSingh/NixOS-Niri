return {
	{
		"echasnovski/mini.animate",
		version = "*",
		event = "VeryLazy",
		config = function()
			local animate = require("mini.animate")
			animate.setup({
				cursor = {
					enable = true,
					timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
				},
				scroll = {
					enable = true,
					timing = animate.gen_timing.linear({ duration = 120, unit = "total" }),
				},
				resize = {
					enable = true,
					timing = animate.gen_timing.linear({ duration = 60, unit = "total" }),
				},
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

	{
		"echasnovski/mini.indentscope",
		version = "*",
		event = "BufReadPost",
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help", "alpha", "dashboard", "NvimTree", "Trouble",
					"trouble", "lazy", "mason", "notify", "toggleterm",
					"lazyterm", "TelescopePrompt",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
		config = function()
			local indentscope = require("mini.indentscope")
			indentscope.setup({
				symbol = "│",
				options = { try_as_border = true },
				draw = {
					animation = indentscope.gen_animation.quadratic({
						easing = "out",
						duration = 80,
						unit = "total",
					}),
				},
			})
		end,
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		dependencies = { "folke/twilight.nvim" },
		config = function()
			require("zen-mode").setup({
				window = {
					backdrop = 0.92,
					width = 90,
					height = 1,
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
					twilight = { enabled = true },
					gitsigns = { enabled = false },
					tmux = { enabled = false },
				},
				on_open = function() vim.cmd("silent! IBLDisable") end,
				on_close = function() vim.cmd("silent! IBLEnable") end,
			})
		end,
	},

	{
		"folke/twilight.nvim",
		cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
		config = function()
			require("twilight").setup({
				dimming = { alpha = 0.35, color = { "Normal", "#ffffff" } },
				context = 12,
				treesitter = true,
				expand = { "function", "method", "table", "if_statement", "for_statement", "while_statement" },
			})
		end,
	},
}
