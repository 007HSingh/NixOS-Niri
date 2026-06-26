return {
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		keys = { { "<leader>O", "<cmd>Oil<cr>", desc = "Oil" } },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = { default_file_explorer = false, view_options = { show_hidden = true } },
	},

	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" } },
		init = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			dir = vim.fn.stdpath("state") .. "/sessions/",
			need = 1,
			branch = true,
		},
	},

	{
		"kevinhwang91/nvim-ufo",
		event = "BufReadPost",
		dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
		opts = {
			provider_selector = function() return { "treesitter", "indent" } end,
		},
	},

	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		opts = {},
	},

	{
		"airblade/vim-rooter",
		event = "VeryLazy",
		init = function()
			vim.g.rooter_patterns = { ".git", "package.json", "Makefile", "Cargo.toml",
				"pyproject.toml", "build.gradle.kts", "settings.gradle.kts", "gradlew" }
			vim.g.rooter_silent_chdir = 1
			vim.g.rooter_resolve_links = 1
		end,
	},

	-- Discord rich presence — build disabled; package via Nix derivation if you want it
	{
		"vyfor/cord.nvim",
		build = false,
		event = "VeryLazy",
		opts = {},
	},

	{
		"luukvbaal/statuscol.nvim",
		event = "BufReadPost",
		config = function()
			local b = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = true,
				segments = {
					{ text = { b.foldfunc }, click = "v:lua.ScFa" },
					{ text = { "%s" },       click = "v:lua.ScSa" },
					{ text = { b.lnumfunc, " " }, click = "v:lua.ScLa" },
				},
			})
		end,
	},

	{
		"eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
		keys = {
			{ "<leader>fml", function()
				if vim.bo.filetype == "" then return end
				vim.cmd("CellularAutomaton make_it_rain")
			end, desc = "Make it rain" },
		},
	},
}
