-- ============================================================================
-- TREESITTER — Syntax highlighting and incremental selection
-- ============================================================================
return {
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	build = false,
	event = "VeryLazy",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = {},
		auto_install = false,
		highlight = { enable = true, additional_vim_regex_highlighting = false },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
		indent = { enable = true },
	},
}