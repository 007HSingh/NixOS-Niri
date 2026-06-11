return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
		require("nvim-treesitter").setup({})

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyDone",
				once = true,
				callback = function()
					require("nvim-treesitter.install").install({
						"bash",
						"c",
						"cpp",
						"go",
						"lua",
						"python",
						"javascript",
						"typescript",
						"html",
						"css",
						"json",
						"yaml",
						"markdown",
						"markdown_inline",
						"vim",
						"vimdoc",
						"rust",
						"java",
						"nix",
						"qmljs",
					})
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enable = true,
			multiwindow = true,
			line_numbers = false,
			multiline_threshold = 2,
		},
	},
}
