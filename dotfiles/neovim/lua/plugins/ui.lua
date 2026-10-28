return {
	-- Icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- Notifications (replaces vim.notify)
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			local notify = require("notify")
			notify.setup({
				stages = "fade",
				timeout = 3000,
				render = "compact",
			})
			vim.notify = notify
		end,
	},

	-- Command-line and LSP popup UI
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		config = function()
			require("noice").setup({
				notify = { enabled = false },
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = true,
				},
			})
		end,
	},

	-- Better vim.ui.select / vim.ui.input
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		config = function()
			require("dressing").setup({
				input = { enabled = true },
				select = { enabled = true, backend = { "telescope", "builtin" } },
			})
		end,
	},


	-- Static indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "BufReadPost",
		config = function()
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			require("ibl").setup({
				indent = { char = "│", highlight = "IblIndent" },
				scope = { enabled = true, char = "│", highlight = "IblScope" },
			})
		end,
	},

	-- Inline hex/rgb colour preview
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPost",
		config = function()
			require("colorizer").setup({ "*" }, {
				RGB = true,
				RRGGBB = true,
				names = false,
				css = true,
			})
		end,
	},

	-- Dashboard (snacks.nvim)
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = false },
			notifier = { enabled = false },
			quickfile = { enabled = false },
			scroll = { enabled = false },
			statuscol = { enabled = false },
			words = { enabled = false },
			dashboard = {
				preset = {
					header = [[
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
					keys = {
						{ icon = "󰈞 ", key = "f", desc = "Find File", action = ":Telescope find_files" },
						{ icon = "󰋚 ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
						{ icon = "󰭎 ", key = "g", desc = "Live Grep", action = ":Telescope live_grep" },
						{
							icon = "󰦛 ",
							key = "s",
							desc = "Restore Session",
							action = function()
								require("persistence").load()
							end,
						},
						{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
						{ icon = "󰅙 ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
		},
	},

	-- Colour-coded matching brackets
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "BufReadPost",
		config = function()
			local rainbow = require("rainbow-delimiters")
			require("rainbow-delimiters.setup").setup({
				strategy = { [""] = rainbow.strategy["local"] },
				query = { [""] = "rainbow-delimiters" },
			})
		end,
	},

	-- Highlight all occurrences of word under cursor
	{
		"RRethy/vim-illuminate",
		event = "BufReadPost",
		config = function()
			require("illuminate").configure({
				providers = { "lsp", "regex" },
				delay = 200,
				under_cursor = true,
				large_file_cutoff = 2000,
			})
		end,
	},

	-- In-editor Markdown rendering
	{
		"MeanderingProgrammer/render-markdown.nvim",
		event = "VeryLazy",
		opts = {
			heading = { icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
			code = { sign = false, width = "block", right_pad = 1 },
			checkbox = { enabled = true },
		},
	},

	-- Project-wide diagnostics list
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({ use_diagnostic_signs = true })
		end,
	},
	-- Rendered :help pages
	{
		"OXY2DEV/helpview.nvim",
		ft = "help", -- only needed when viewing :help buffers; no reason to load at startup
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local ok, p = pcall(function()
				return require("catppuccin.palettes").get_palette("mocha")
			end)
			if not ok then
				p = {}
			end
			require("helpview").setup({
				highlight_groups = {
					HelpviewHeading1 = { fg = p.mauve or "#cba6f7", bold = true },
					HelpviewHeading2 = { fg = p.blue or "#89b4fa", bold = true },
					HelpviewHeading3 = { fg = p.sky or "#89dceb", bold = true },
					HelpviewCode = { bg = p.surface0 or "#313244" },
					HelpviewInlineCode = { fg = p.peach or "#fab387", bg = p.surface0 or "#313244" },
					HelpviewHyperlink = { fg = p.blue or "#89b4fa", underline = true },
					HelpviewTaglink = { fg = p.teal or "#94e2d5", underline = true },
					HelpviewOptionLink = { fg = p.yellow or "#f9e2af" },
					HelpviewNoteTag = { fg = p.green or "#a6e3a1", bold = true },
					HelpviewSeparator = { fg = p.surface1 or "#45475a" },
					HelpviewArgument = { fg = p.peach or "#fab387", italic = true },
				},
			})
		end,
	},

	-- LSP progress spinner
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {
			progress = {
				display = {
					render_limit = 4,
					done_ttl = 2,
					done_icon = "✓",
					progress_icon = { pattern = "dots", period = 1 },
				},
			},
			notification = {
				window = { winblend = 0, border = "none" },
			},
		},
	},

}
