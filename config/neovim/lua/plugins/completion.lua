-- ============================================================================
-- COMPLETION — nvim-cmp + LuaSnip + friendly-snippets + Supermaven AI
-- ============================================================================
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		{
			"L3MON4D3/LuaSnip",
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		"onsails/lspkind.nvim",
		-- Supermaven cmp source (loaded separately in ai_completion.lua,
		-- but we reference it here so cmp finds it after Supermaven inits)
		"supermaven-inc/supermaven-nvim",
		"folke/lazydev.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			-- Sources in priority order. Supermaven is first — it shows up as
			-- "AI" in the menu (see lspkind symbol_map below).
			sources = cmp.config.sources({
				{ name = "supermaven", priority = 1200, max_item_count = 3 },
				{ name = "nvim_lsp", priority = 1000 },
				{ name = "luasnip", priority = 750 },
				{ name = "buffer", priority = 500 },
				{ name = "path", priority = 250 },
				{ name = "lazydev", priority = 900, group_index = 0 },
			}),
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "…",
					-- Add a custom icon for Supermaven AI suggestions
					symbol_map = {
						Supermaven = "󱙺", -- Nerd Font: nf-md-robot
					},
					-- Show source name in the menu for clarity
					before = function(entry, vim_item)
						if entry.source.name == "supermaven" then
							vim_item.kind = "󱙺 AI"
							vim_item.kind_hl_group = "CmpItemKindSupermaven"
						end
						return vim_item
					end,
				}),
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			experimental = { ghost_text = true },
		})

		-- Highlight group for the AI kind label (Catppuccin mauve)
		vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#cba6f7", bold = true })

		-- Cmdline completion
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
		})
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = { { name = "buffer" } },
		})
	end,
}
