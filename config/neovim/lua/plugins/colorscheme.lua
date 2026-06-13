-- ============================================================================
-- COLORSCHEMES — Catppuccin
-- ============================================================================
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				show_end_of_buffer = false,
				term_colors = true,
				-- Slightly shade inactive splits — complements compositor inactive dimming.
				dim_inactive = { enabled = true, shade = "dark", percentage = 0.12 },
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					notify = true,
					telescope = { enabled = true },
					bufferline = true,
					noice = true,
					which_key = true,
					indent_blankline = { enabled = true },
					dashboard = true,
					native_lsp = { enabled = true },
					mini = { enabled = true },
					rainbow_delimiters = true,
					illuminate = { enabled = true },
					navic = { enabled = true },
					harpoon = true,
				},
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
