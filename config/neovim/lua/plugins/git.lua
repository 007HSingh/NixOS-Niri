-- ============================================================================
-- GIT PLUGINS — gitsigns, neogit, diffview, gitlinker
-- ============================================================================
return {
	-- gitsigns
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("gitsigns").setup({
				signs = { add = "│", change = "│", delete = "契", topdelete = "契", changedelete = "│" },
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, opts)
						opts = vim.tbl_extend("force", { buffer = bufnr }, opts or {})
						vim.keymap.set(mode, l, r, opts)
					end
					map("n", "<leader>gs", gs.stage_hunk)
					map("n", "<leader>gu", gs.undo_stage_hunk)
					map("n", "<leader>gp", gs.preview_hunk)
					map("n", "<leader>gb", gs.toggle_current_line_blame)
				end,
			})
		end,
	},
	-- neogit
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("neogit").setup({})
		end,
	},
	-- diffview
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("diffview").setup({})
		end,
	},
	-- gitlinker
	{
		"ruifm/gitlinker.nvim",
		cmd = "GitLink",
		config = function()
			require("gitlinker").setup({})
		end,
	},
}
