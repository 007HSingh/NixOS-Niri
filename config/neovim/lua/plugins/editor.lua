-- EDITOR PLUGINS
return {
	-- autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	-- comment
	{
		"numToStr/Comment.nvim",
		keys = { { "gc", mode = "v" }, { "gcc", mode = "n" } },
		config = function()
			require("Comment").setup()
		end,
	},
	-- surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	-- todo-comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		config = function()
			require("todo-comments").setup({})
		end,
	},
	-- which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				icons = { rules = false },
			})
			require("which-key").add({
				-- ── groups ──────────────────────────────────────────────────────────
				{ "<leader>f", group = "Find",           icon = { icon = "󰭎", color = "blue"   } },
				{ "<leader>g", group = "Git",            icon = { icon = "󰊢", color = "orange" } },
				{ "<leader>c", group = "Code / LSP",     icon = { icon = "󰒋", color = "cyan"   } },
				{ "<leader>d", group = "Debug",          icon = { icon = "󰃤", color = "red"    } },
				{ "<leader>h", group = "Harpoon",        icon = { icon = "󱡅", color = "purple" } },
				{ "<leader>q", group = "Session",        icon = { icon = "󰑓", color = "green"  } },
				{ "<leader>s", group = "Search/Replace", icon = { icon = "󰛔", color = "yellow" } },
				{ "<leader>t", group = "Toggle",         icon = { icon = "󰔡", color = "purple" } },
				{ "<leader>w", group = "Window",         icon = { icon = "󱟱", color = "azure"  } },
				{ "<leader>x", group = "Diagnostics",    icon = { icon = "󰀪", color = "red"    } },
				{ "<leader>o", group = "Outline",        icon = { icon = "󰙅", color = "cyan"   } },
				{ "<leader>b", group = "Buffer",         icon = { icon = "󰓩", color = "blue"   } },
				-- ── harpoon marks ───────────────────────────────────────────────────
				{ "<leader>1", icon = { icon = "󱡅", color = "purple" } },
				{ "<leader>2", icon = { icon = "󱡅", color = "purple" } },
				{ "<leader>3", icon = { icon = "󱡅", color = "purple" } },
				{ "<leader>4", icon = { icon = "󱡅", color = "purple" } },
				-- ── individual keymaps ──────────────────────────────────────────────
				{ "<leader>a",  icon = { icon = "󰙅", color = "cyan"   } }, -- aerial
				{ "<leader>u",  icon = { icon = "󰕌", color = "yellow" } }, -- undotree
				{ "<leader>z",  icon = { icon = "󰒲", color = "purple" } }, -- zen mode
				{ "<leader>e",  icon = { icon = "󱏒", color = "green"  } }, -- neo-tree
				{ "<leader>E",  icon = { icon = "󱏒", color = "green"  } }, -- neo-tree reveal
				{ "<leader>W",  icon = { icon = "󰆓", color = "blue"   } }, -- save
				{ "<leader>Q",  icon = { icon = "󰈆", color = "red"    } }, -- quit all
				{ "<leader>qq", icon = { icon = "󰗼", color = "red"    } }, -- quit window
				{ "<leader>tf", icon = { icon = "󰛖", color = "yellow" } }, -- toggle format
				{ "<leader>O",  icon = { icon = "󰙅", color = "yellow" } }, -- oil
				{ "<leader>/",  icon = { icon = "󰍉", color = "blue"   } }, -- search buffer
				{ "<leader>bd", icon = { icon = "󰅙", color = "red"    } }, -- delete buffer
			})
		end,
	},
	-- flash (jump to chars)
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function()
			require("flash").setup({})
		end,
	},
	-- toggleterm
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = "ToggleTerm",
		keys = { { [[<C-\>]], desc = "Toggle terminal" } },
		config = function()
			require("toggleterm").setup({ open_mapping = [[<c-\>]], direction = "float" })
		end,
	},
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
		end,
	},
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
			vim.g.matchup_surround_enabled = 1
		end,
	},

	-- ── Marks (sign column marks) ─────────────────────────────────────────────
	{
		"chentoast/marks.nvim",
		event = "BufReadPost",
		config = function()
			require("marks").setup({
				default_mappings = true, -- mx, m', m[ m] etc.
				signs = true,
				mappings = {},
			})
		end,
	},

	-- ── Yanky (yank ring) ─────────────────────────────────────────────────────
	{
		"gbprod/yanky.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("yanky").setup({
				ring = { history_length = 100 },
				highlight = { on_put = true, on_yank = true, timer = 150 },
			})
		end,
	},

	-- ── Harpoon (quick file navigation) ───────────────────────────────────────
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		config = function()
			require("harpoon"):setup()
		end,
	},

	-- ── Grug-far (search and replace) ─────────────────────────────────────────
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					require("grug-far").open()
				end,
				desc = "Search & replace",
			},
			{
				"<leader>sw",
				function()
					require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
				end,
				desc = "Search word",
			},
			{
				"<leader>sw",
				function()
					require("grug-far").with_visual_selection()
				end,
				mode = "v",
				desc = "Search selection",
			},
		},
		opts = { headerMaxWidth = 80 },
	},

	-- ── precognition.nvim — motion hint ghost text ────────────────────────────
	{
		"tris203/precognition.nvim",
		event = "BufReadPost",
		keys = {
			{
				"<leader>tp",
				function()
					require("precognition").toggle()
				end,
				desc = "Toggle precognition hints",
			},
		},
		config = function()
			require("precognition").setup({
				startVisible = false, -- off by default, toggle with <leader>tp
				showBlankVirtLine = false,
				highlightColor = { link = "Comment" },
				hints = {
					Caret = { text = "^", prio = 2 },
					Dollar = { text = "$", prio = 1 },
					MatchingPair = { text = "%", prio = 5 },
					Zero = { text = "0", prio = 1 },
					w = { text = "w", prio = 10 },
					b = { text = "b", prio = 9 },
					e = { text = "e", prio = 8 },
					W = { text = "W", prio = 7 },
					B = { text = "B", prio = 6 },
					E = { text = "E", prio = 5 },
				},
				gutterHints = {
					G = { text = "G", prio = 10 },
					gg = { text = "gg", prio = 9 },
					PrevParagraph = { text = "{", prio = 8 },
					NextParagraph = { text = "}", prio = 8 },
				},
				disabled_fts = {
					"alpha",
					"NvimTree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"TelescopePrompt",
					"toggleterm",
				},
			})

			local ok, p = pcall(require("catppuccin.palettes").get_palette, "mocha")
			if ok then
				vim.api.nvim_set_hl(0, "PrecognitionHighlight", { fg = p.overlay1, italic = true })
				vim.api.nvim_set_hl(0, "PrecognitionGutterHint", { fg = p.surface1, italic = true })
			end
		end,
	},
}
