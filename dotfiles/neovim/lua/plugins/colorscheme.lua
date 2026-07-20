return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				background = { dark = "mocha", light = "latte" },
				transparent_background = false,
				show_end_of_buffer = false,
				term_colors = true,
				dim_inactive = { enabled = false },
				styles = {
					comments = { "italic" },
					keywords = { "italic" },
					functions = {},
					variables = {},
				},
				integrations = {
					aerial = true,
					bufferline = true,
					cmp = true,
					dap = true,
					dap_ui = true,
					diffview = true,
					flash = true,
					gitsigns = true,
					harpoon = true,
					helpview = true,
					indent_blankline = { enabled = true },
					lsp_trouble = true,
					markdown = true,
					mason = false,
					mini = { enabled = true, indentscope_color = "lavender" },
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = {},
							warnings = { "italic" },
							information = {},
						},
						underlines = {
							errors = { "underline" },
							hints = {},
							warnings = { "underline" },
							information = {},
						},
						inlay_hints = { background = true },
					},
					neogit = true,
					noice = true,
					notify = true,
					nvimtree = true,
					rainbow_delimiters = true,
					render_markdown = true,
					telescope = { style = "nvchad" }, -- borderless telescope
					treesitter = true,
					treesitter_context = true,
					which_key = true,
				},
				custom_highlights = function(c)
					return {
						-- treesitter variable tokens
						["@variable"] = { fg = c.lavender },
						["@variable.builtin"] = { fg = c.red, italic = true },
						["@variable.parameter"] = { fg = c.maroon, italic = true },
						["@variable.member"] = { fg = c.sky },
						["@property"] = { fg = c.sky },
						-- LSP semantic tokens
						["@lsp.type.variable"] = { fg = c.lavender },
						["@lsp.type.parameter"] = { fg = c.maroon, italic = true },
						["@lsp.type.property"] = { fg = c.sky },
						["@lsp.type.field"] = { fg = c.sky },
					}
				end,
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
