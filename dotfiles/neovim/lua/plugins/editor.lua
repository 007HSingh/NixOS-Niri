return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		config = function()
			require("todo-comments").setup({})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				icons = { rules = false },
			})
			require("which-key").add({
				{ "<leader>f", group = "Find", icon = { icon = "󰭎", color = "blue" } },
				{ "<leader>g", group = "Git", icon = { icon = "󰊢", color = "orange" } },
				{ "<leader>c", group = "Code / LSP", icon = { icon = "󰒋", color = "cyan" } },
				{ "<leader>d", group = "Debug", icon = { icon = "󰃤", color = "red" } },
				{ "<leader>q", group = "Session", icon = { icon = "󰑓", color = "green" } },
				{ "<leader>s", group = "Search/Replace", icon = { icon = "󰛔", color = "yellow" } },
				{ "<leader>t", group = "Toggle", icon = { icon = "󰔡", color = "purple" } },
				{ "<leader>w", group = "Window", icon = { icon = "󱟱", color = "azure" } },
				{ "<leader>x", group = "Diagnostics", icon = { icon = "󰀪", color = "red" } },
				{ "<leader>o", group = "Overseer / Build", icon = { icon = "󰙅", color = "cyan" } },
				{ "<leader>b", group = "Buffer", icon = { icon = "󰓩", color = "blue" } },
				{ "<leader>a", icon = { icon = "󰙅", color = "cyan" } },
				{ "<leader>u", icon = { icon = "󰕌", color = "yellow" } },
				{ "<leader>z", icon = { icon = "󰒲", color = "purple" } },
				{ "<leader>e", icon = { icon = "󱏒", color = "green" } },
				{ "<leader>E", icon = { icon = "󱏒", color = "green" } },
				{ "<leader>W", icon = { icon = "󰆓", color = "blue" } },
				{ "<leader>Q", icon = { icon = "󰈆", color = "red" } },
				{ "<leader>qq", icon = { icon = "󰗼", color = "red" } },
				{ "<leader>tf", icon = { icon = "󰛖", color = "yellow" } },
				{ "<leader>/", icon = { icon = "󰍉", color = "blue" } },
				{ "<leader>bd", icon = { icon = "󰅙", color = "red" } },
				{ "<leader>j", group = "Java", icon = { icon = "", color = "orange" } },
				{ "<leader>jt", group = "Test", icon = { icon = "󰙨", color = "green" } },
				{ "<leader>jx", group = "Extract", icon = { icon = "󰆏", color = "yellow" } },
				{ "<leader>jS", group = "Spring", icon = { icon = "󱞉", color = "green" } },
				{ "<leader>jH", group = "HTTP Client", icon = { icon = "󰖟", color = "blue" } },
				{ "<leader>jD", group = "Database", icon = { icon = "󰆼", color = "blue" } },
			})
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function()
			require("flash").setup({})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = "ToggleTerm",
		config = function()
			require("toggleterm").setup({ open_mapping = [[<c-\>]], direction = "float" })
		end,
	},
	{"andymass/vim-matchup",
		event = "BufReadPost",
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
			vim.g.matchup_surround_enabled = 1
		end,
	},

	{
		"gbprod/yanky.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" },
			{ "Y", "<Plug>(YankyYank)$", mode = "n", desc = "Yank to EOL" },
			{ "p", "<Plug>(YankyPutAfter)", mode = "n", desc = "Put after" },
			{ "P", "<Plug>(YankyPutBefore)", mode = "n", desc = "Put before" },
			{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "gPut after" },
			{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "gPut before" },
			{ "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Yank ring: previous" },
			{ "<C-n>", "<Plug>(YankyNextEntry)", desc = "Yank ring: next" },
		},
		config = function()
			require("yanky").setup({
				ring = { history_length = 100 },
				highlight = { on_put = true, on_yank = true, timer = 150 },
			})
		end,
	},

	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		opts = { headerMaxWidth = 80 },
	},
}
