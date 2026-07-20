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
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, opts)
						opts = vim.tbl_extend("force", { buffer = bufnr }, opts or {})
						vim.keymap.set(mode, l, r, opts)
					end
					map("n", "<leader>gs", gs.stage_hunk, { desc = "Git: stage hunk" })
					map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Git: undo stage hunk" })
					map("n", "<leader>gP", gs.preview_hunk, { desc = "Git: preview hunk" })
					map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Git: toggle line blame" })
					map("n", "<leader>gR", gs.reset_hunk, { desc = "Git: reset hunk" })
					map("n", "<leader>gB", gs.blame_line, { desc = "Git: blame line (full)" })
					-- renamed from <leader>gd to avoid colliding with global DiffviewOpen
					map("n", "<leader>gdf", gs.diffthis, { desc = "Git: diff this file" })
					map("n", "<leader>gdF", function()
						gs.diffthis("~")
					end, { desc = "Git: diff against HEAD~1" })
					map("n", "]h", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(gs.next_hunk)
						return "<Ignore>"
					end, { expr = true, desc = "Next hunk" })
					map("n", "[h", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(gs.prev_hunk)
						return "<Ignore>"
					end, { expr = true, desc = "Prev hunk" })
				end,
			})
		end,
	},
	-- neogit
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		config = function()
			require("neogit").setup({ integrations = { diffview = true } })
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
		keys = {
			{
				"<leader>gy",
				function()
					require("gitlinker").get_buf_line_url({ action_callback = require("gitlinker.actions").copy_to_clipboard })
				end,
				mode = { "n", "v" },
				desc = "Git: copy line URL",
			},
			{
				"<leader>gY",
				function()
					require("gitlinker").get_repo_url({ action_callback = require("gitlinker.actions").open_in_browser })
				end,
				desc = "Git: open repo in browser",
			},
		},
		config = function()
			require("gitlinker").setup({})
		end,
	},
}
