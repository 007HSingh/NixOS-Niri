return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		build = "cargo build --release",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				"saghen/blink.compat",
				version = "1.*",
				lazy = true,
				opts = {},
			},
		},
		event = { "InsertEnter", "CmdlineEnter" },
		opts = {
			keymap = {
				preset = "none",
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-l>"] = { "snippet_forward", "fallback" },
				["<C-h>"] = { "snippet_backward", "fallback" },
			},

			snippets = {
				preset = "default",
			},

			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
					"lazydev",
				},

				per_filetype = {
					sql = { "dadbod", "lsp", "buffer" },
					mysql = { "dadbod", "lsp", "buffer" },
					plsql = { "dadbod", "lsp", "buffer" },
				},

				providers = {
					lsp = {
						name = "LSP",
						module = "blink.cmp.sources.lsp",
						score_offset = 5,
					},

					snippets = {
						name = "Snippets",
						module = "blink.cmp.sources.snippets",
						score_offset = 4,
					},

					cmdline = {
						name = "Cmdline",
						module = "blink.cmp.sources.cmdline",
					},

					path = {
						name = "Path",
						module = "blink.cmp.sources.path",
						score_offset = 3,
						opts = {
							show_hidden_files_by_default = true,
						},
					},

					buffer = {
						name = "Buffer",
						module = "blink.cmp.sources.buffer",
						score_offset = 1,
					},

					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 10,
					},

					dadbod = {
						name = "Dadbod",
						module = "blink.compat.source",
						opts = {
							name = "vim-dadbod-completion",
						},
					},
				},
			},

			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = true,
					},
				},

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = "rounded",
					},
				},

				menu = {
					border = "rounded",
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
						},
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									local icons = {
										Text = "󰉿",
										Method = "󰆧",
										Function = "󰊕",
										Constructor = "",
										Field = "󰜢",
										Variable = "󰀫",
										Class = "󰠱",
										Interface = "",
										Module = "",
										Property = "󰜢",
										Unit = "",
										Value = "󰎠",
										Enum = "",
										Keyword = "󰌋",
										Snippet = "",
										Color = "󰏘",
										File = "󰈙",
										Reference = "",
										Folder = "󰉋",
										EnumMember = "",
										Constant = "󰏿",
										Struct = "",
										Event = "",
										Operator = "󰆕",
										TypeParameter = "",
									}
									return icons[ctx.kind] or ""
								end,
							},
						},
					},
				},

				ghost_text = {
					enabled = true,
				},
			},

			signature = {
				enabled = true,
				window = {
					border = "rounded",
				},
			},

			cmdline = {
				sources = { "cmdline" },
			},

			fuzzy = {
				prebuilt_binaries = {
					download = false,
				},
				implementation = "prefer_rust",
			},
		},
	},
}
