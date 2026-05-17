-- ============================================================================
-- UTILITIES — harpoon, oil, undotree, persistence, project-nvim, UFO
-- ============================================================================
return {
	-- ── Oil (file manager as a buffer) ────────────────────────────────────────
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = false,
				view_options = { show_hidden = true },
			})
		end,
	},

	-- ── Undotree ──────────────────────────────────────────────────────────────
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		config = function()
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	},

	-- ── Persistence (sessions) ────────────────────────────────────────────────
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		config = function()
			require("persistence").setup({
				dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
				need = 1,
				branch = true,
			})
		end,
	},
	-- ── UFO (folding) ─────────────────────────────────────────────────────────
	{
		"kevinhwang91/nvim-ufo",
		event = "BufReadPost",
		dependencies = {
			"kevinhwang91/promise-async",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local ufo = require("ufo")
			ufo.setup({
				provider_selector = function()
					return { "treesitter", "indent" }
				end,
			})
		end,
	},

	-- ── Inc-Rename (live rename) ──────────────────────────────────────────────
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = function()
			require("inc_rename").setup({})
		end,
	},
	{
		"airblade/vim-rooter",
		event = "VeryLazy",
		init = function()
			vim.g.rooter_patterns = { ".git", "package.json", "Makefile", "Cargo.toml", "pyproject.toml" }
			vim.g.rooter_silent_chdir = 1
			vim.g.rooter_resolve_links = 1
		end,
	},

	-- Cord
	{
		"vyfor/cord.nvim",
		build = "cargo build --release",
		event = "VeryLazy",
		opts = {
			display = {
				theme = "catppuccin",
				flavor = "dark",
			},
		},
	},

	{
		"luukvbaal/statuscol.nvim",
		event = "BufReadPost",
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = true,
				segments = {
					{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
				},
			})
		end,
	},

	{
		"eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
		keys = {
			{
				"<leader>fml",
				function()
					if vim.bo.filetype == "" then
						vim.notify("No filetype — open a file first", vim.log.levels.WARN)
						return
					end
					vim.cmd("CellularAutomaton make_it_rain")
				end,
				desc = "Make it rain",
			},
		},
	},
}
