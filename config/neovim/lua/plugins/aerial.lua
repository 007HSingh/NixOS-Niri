return {
	"stevearc/aerial.nvim",
	event = "LspAttach",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("aerial").setup({
			attach_mode = "cursor",
			backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
			show_guides = true,
			filter_kind = false,
			layout = {
				max_width = { 40, 0.2 },
				min_width = 20,
				default_direction = "prefer_right",
			},
		})
		require("telescope").load_extension("aerial")
	end,
}
