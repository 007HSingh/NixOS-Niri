-- ============================================================================
-- EXTRA UI — rainbow-delimiters, illuminate, vim-illuminate, lspsaga, markdown-preview
-- ============================================================================
return {
	-- ── Rainbow delimiters ────────────────────────────────────────────────────
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "BufReadPost",
		config = function()
			local rainbow = require("rainbow-delimiters")
			require("rainbow-delimiters.setup").setup({
				strategy = { [""] = rainbow.strategy["global"] },
				query = { [""] = "rainbow-delimiters" },
			})
		end,
	},

	-- ── Illuminate (highlight word under cursor) ──────────────────────────────
	{
		"RRethy/vim-illuminate",
		event = "BufReadPost",
		config = function()
			require("illuminate").configure({
				providers = { "lsp", "regex" },
				delay = 200,
				under_cursor = true,
				large_file_cutoff = 2000,
			})
		end,
	},

	-- ── Markdown Preview ──────────────────────────────────────────────────────
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
		ft = "markdown",
		build = "cd app && npm install",
		config = function()
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_theme = "dark"
		end,
	},

	-- ── Trouble ───────────────────────────────────────────────────────────────
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({ use_diagnostic_signs = true })
		end,
	},
}
