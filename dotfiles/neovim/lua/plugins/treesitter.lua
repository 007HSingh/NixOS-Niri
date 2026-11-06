return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter").install({
				"bash",
				"c",
				"cpp",
				"go",
				"lua",
				"python",
				"yaml",
				"markdown",
				"markdown_inline",
				"vim",
				"vimdoc",
				"rust",
				"java",
				"nix",
				"kotlin",
				"toml",
				"dockerfile",
				"sql",
				"regex",
				"comment",
				"scss",
				"javascript",
				"typescript",
				"tsx",
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					if pcall(vim.treesitter.start, ev.buf) then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = true,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
						["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
					},
					include_surrounding_whitespace = true,
				},
				move = {
					enable = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = { query = "@class.outer", desc = "Next class start" },
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>csa"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>csA"] = "@parameter.inner",
					},
				},
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "BufReadPre",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 4,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "topline",
				separator = nil,
				zindex = 20,
			})
		end,
	},
}
