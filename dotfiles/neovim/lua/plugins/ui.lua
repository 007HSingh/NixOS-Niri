-- UI PLUGINS
return {
	-- ── Icons ─────────────────────────────────────────────────────────────────
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- ── Bufferline ────────────────────────────────────────────────────────────
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "BufReadPost",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					separator_style = "slant",
					diagnostics = "nvim_lsp",
					diagnostics_update_in_insert = false, -- avoid flicker while typing
					diagnostics_indicator = function(count, level)
						local icons = { error = " ", warning = " ", info = " " }
						return (icons[level] or " ") .. count
					end,
					show_buffer_close_icons = true,
					show_close_icon = false,
					offsets = {
						{ filetype = "neo-tree", text = "File Explorer", padding = 1 },
					},
				},
			})
		end,
	},

	-- ── NvimTree ──────────────────────────────────────────────────────────────
	-- ── File Explorer (neo-tree) ─────────────────────────────────────────────
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File explorer" },
			{ "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal in explorer" },
		},
		opts = {
			close_if_last_window = false,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			window = {
				position = "left",
				width = 38,
				mappings = {
					["<space>"] = "none",
					["Y"] = function(state)
						local node = state.tree:get_node()
						vim.fn.setreg("+", node.path)
					end,
				},
			},
			default_component_configs = {
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					with_expanders = true,
				},
				icon = { folder_closed = "", folder_open = "", folder_empty = "󰜌" },
				modified = { symbol = "●" },
				git_status = {
					symbols = {
						added = "✚",
						modified = "",
						deleted = "✖",
						renamed = "󰁕",
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
				file_size = { enabled = true, required_width = 50 },
				last_modified = { enabled = true, required_width = 70 },
				type = { enabled = false },
				created = { enabled = false },
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
				follow_current_file = { enabled = true },
				group_empty_dirs = true,
				use_libuv_file_watcher = true,
			},
			renderers = {
				file = {
					{ "indent" },
					{ "icon" },
					{
						"container",
						content = {
							{ "name", zindex = 10 },
							{ "symlink_target", zindex = 10, highlight = "NeoTreeSymbolicLinkTarget" },
							{ "clipboard", zindex = 10 },
							{ "diagnostics", zindex = 20, align = "right" },
							{ "git_status", zindex = 20, align = "right" },
							{ "modified", zindex = 20, align = "right" },
							{ "file_size", zindex = 10, align = "right" },
							{ "last_modified", zindex = 10, align = "right" },
						},
					},
				},
				directory = {
					{ "indent" },
					{ "icon" },
					{
						"container",
						content = {
							{ "name", zindex = 10 },
							{ "clipboard", zindex = 10 },
							{ "diagnostics", zindex = 20, align = "right" },
							{ "git_status", zindex = 20, align = "right" },
							{ "modified", zindex = 20, align = "right" },
						},
					},
				},
			},
		},
	},

	-- ── Notify ────────────────────────────────────────────────────────────────
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			local notify = require("notify")
			notify.setup({
				stages = "fade",
				timeout = 3000,
				render = "compact",
				-- nvim-notify requires a hex color for its animations/transparency calculations.
				-- Using #000000 to maintain compatibility with the transparent/glass aesthetic.
				background_colour = "#000000",
			})
			vim.notify = notify
		end,
	},

	-- ── Noice ─────────────────────────────────────────────────────────────────
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

	-- ── Dressing (better select/input UI) ────────────────────────────────────
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

	-- NOTE: nvim-navic is intentionally NOT declared here. It's already a
	-- dependency of lualine.nvim, which owns the single setup() call (see
	-- plugins/lualine.lua). Having a second spec here with its own config()
	-- caused navic.setup() to be called multiple times, each resetting its
	-- internal state, plus lsp.auto_attach=true double-attaching navic on top
	-- of the manual navic.attach() calls in lsp.lua/jdtls.lua's on_attach.

	-- ── Indent blankline ──────────────────────────────────────────────────────
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "BufReadPost",
		config = function()
			require("ibl").setup({
				indent = { char = "│" },
				scope = { enabled = true },
			})
		end,
	},

	-- ── Colorizer ─────────────────────────────────────────────────────────────
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

	-- ── Rainbow delimiters ────────────────────────────────────────────────────
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "BufReadPost",
		config = function()
			local rainbow = require("rainbow-delimiters")
			require("rainbow-delimiters.setup").setup({
				strategy = { [""] = rainbow.strategy["global"] },
				query = { [""] = "rainbow-delimiters" },
			})
		end,
	},

	-- ── Illuminate (highlight word under cursor) ──────────────────────────────
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

	-- ── Render Markdown (in-editor rendering) ─────────────────────────────────
	{
		"MeanderingProgrammer/render-markdown.nvim",
		event = "VeryLazy",
		opts = {
			heading = { icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
			code = { sign = false, width = "block", right_pad = 1 },
			checkbox = { enabled = true },
		},
	},

	-- ── Trouble (diagnostics list) ────────────────────────────────────────────
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({ use_diagnostic_signs = true })
		end,
	},
	-- ── helpview.nvim — rendered :help pages (same author as render-markdown) ───
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

	-- ── Fidget (LSP progress) ────────────────────────────────────────────────
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

	-- ── HLChunk (highlight current indent chunk) ───────────────────────────────
	{
		"shellRaining/hlchunk.nvim",
		event = "BufReadPost",
		config = function()
			local ok, p = pcall(function()
				return require("catppuccin.palettes").get_palette("mocha")
			end)
			if not ok then
				p = {}
			end
			require("hlchunk").setup({
				chunk = {
					enable = true,
					style = {
						{ fg = p.mauve or "#cba6f7" }, -- active chunk
						{ fg = p.red or "#f38ba8" }, -- error
					},
					use_treesitter = true,
				},
				indent = { enable = false }, -- ibl already handles this
				line_num = {
					enable = true,
					style = p.mauve or "#cba6f7",
				},
			})
		end,
	},

	-- ── Incline (floating filename per split) ─────────────────────────────────
	{
		"b0o/incline.nvim",
		event = "BufReadPost",
		config = function()
			local ok, p = pcall(function()
				return require("catppuccin.palettes").get_palette("mocha")
			end)
			if not ok then
				p = {}
			end
			require("incline").setup({
				window = { margin = { vertical = 0, horizontal = 1 } },
				-- Hide on the focused/single window — bufferline already shows the
				-- current filename there, so incline only adds value on inactive splits.
				hide = { cursorline = false, focused_win = true, only_win = true },
				render = function(props)
					local fname = vim.api.nvim_buf_get_name(props.buf)
					if fname == "" then
						return "[No Name]"
					end
					local name = vim.fn.fnamemodify(fname, ":t")
					local ext = vim.fn.fnamemodify(fname, ":e")
					local icon, hl = "", "Normal"
					local dv_ok, devicons = pcall(require, "nvim-web-devicons")
					if dv_ok then
						local i, h = devicons.get_icon(name, ext, { default = true })
						icon, hl = (i or "") .. " ", h or "Normal"
					end
					local modified = vim.bo[props.buf].modified
					return {
						{ icon, group = hl },
						{ name, gui = "bold" },
						modified and { " ●", guifg = p.peach } or "",
					}
				end,
			})
		end,
	},
}
