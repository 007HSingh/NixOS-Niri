-- ============================================================================
-- EDITOR PLUGINS — autopairs, comment, surround, todo-comments, which-key, flash, toggleterm
-- ============================================================================
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
			require("which-key").setup({})
			require("which-key").add({
				{ "<leader>f", group = "Find (Telescope)" },
				{ "<leader>g", group = "Git" },
				{ "<leader>c", group = "Code / LSP" },
				{ "<leader>d", group = "Debug (DAP)" },
				{ "<leader>h", group = "Harpoon" },
				{ "<leader>o", group = "Obsidian" },
				{ "<leader>q", group = "Session" },
				{ "<leader>s", group = "Search & Replace" },
				{ "<leader>t", group = "Toggle" },
				{ "<leader>w", group = "Workspace" },
				{ "<leader>x", group = "Diagnostics (Trouble)" },
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
				desc = "Search and replace (grug-far)",
			},
			{
				"<leader>sw",
				function()
					require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
				end,
				desc = "Search current word",
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
		config = function()
			require("grug-far").setup({
				headerMaxWidth = 80,
			})
		end,
	},
}
