-- ============================================================================
-- UTILITIES — harpoon, spectre, oil, undotree, persistence, project-nvim, UFO
-- ============================================================================
return {
	-- ── Spectre (search & replace) ────────────────────────────────────────────
	{
		"windwp/nvim-spectre",
		cmd = "Spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("spectre").setup()
		end,
	},

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
			})
		end,
	},

	-- ── Project.nvim ──────────────────────────────────────────────────────────
	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		config = function()
			require("project_nvim").setup({
				detection_methods = { "lsp", "pattern" },
				patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
			})
			require("telescope").load_extension("projects")
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
			require("inc_rename").setup()
		end,
	},
}
