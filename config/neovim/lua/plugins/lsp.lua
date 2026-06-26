return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			"stevearc/conform.nvim",
			"folke/trouble.nvim",
			"smjonas/inc-rename.nvim",
		},
		config = function()
			-- capabilities: merge LSP defaults with blink/cmp extras
			local has_blink, blink = pcall(require, "blink.cmp")
			local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				has_blink and blink.get_lsp_capabilities() or {},
				has_cmp and cmp_lsp.default_capabilities() or {}
			)
			-- nvim-ufo: advertise folding range support
			capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = function(d)
						return ({ [1] = " ", [2] = " ", [3] = " ", [4] = "󰌵 " })[d.severity] or "● "
					end,
				},
				virtual_lines = false,
				signs = {
					text = { [1] = " ", [2] = " ", [3] = " ", [4] = "󰌵 " },
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { focusable = true, source = true, header = "", prefix = "", max_width = 100 },
			})

			local function peek_definition()
				local params = vim.lsp.util.make_position_params(0, "utf-16")
				vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
					if not result or vim.tbl_isempty(result) then return end
					local target = vim.islist(result) and result[1] or result
					vim.lsp.util.preview_location(target)
				end)
			end

			local function on_attach(client, bufnr)
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
				end

				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
				map("n", "gr", vim.lsp.buf.references, "References")
				map("n", "gt", vim.lsp.buf.type_definition, "Type definition")
				map("n", "K",  vim.lsp.buf.hover, "Hover")
				map("n", "gp", peek_definition, "Peek definition")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("v", "<leader>ca", vim.lsp.buf.code_action, "Code action (range)")
				map("n", "<leader>cr", function()
					vim.cmd("IncRename " .. vim.fn.expand("<cword>"))
				end, "Rename")
				map("n", "<leader>co", "<cmd>Trouble symbols toggle focus=true<cr>", "Symbols outline")
				map("n", "<leader>cL", vim.lsp.codelens.run, "Code lens")
				map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
				map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")

				if client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					map("n", "<leader>th", function()
						local en = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
						vim.lsp.inlay_hint.enable(not en, { bufnr = bufnr })
					end, "Toggle inlay hints")
				end

				if client:supports_method("textDocument/signatureHelp") then
					-- native signature help on cursor hold while in insert mode
					vim.api.nvim_create_autocmd("CursorHoldI", {
						buffer = bufnr,
						callback = function() vim.lsp.buf.signature_help() end,
					})
				end

				if client:supports_method("textDocument/documentHighlight") then
					local group = vim.api.nvim_create_augroup("LspDocHL_" .. bufnr, { clear = true })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = bufnr, group = group, callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = bufnr, group = group, callback = vim.lsp.buf.clear_references,
					})
				end

				if client:supports_method("textDocument/codeLens") then
					vim.lsp.codelens.enable(true, { bufnr = bufnr })
				end

				if client:supports_method("textDocument/documentSymbol") then
					local ok, navic = pcall(require, "nvim-navic")
					if ok then navic.attach(client, bufnr) end
				end
			end

			-- per-server settings (merged on top of shared on_attach + capabilities)
			local servers = {
				lua_ls = {
					settings = { Lua = {
						hint = { enable = true, setType = true, paramName = "All", paramType = true },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						completion = { callSnippet = "Replace" },
					}},
				},
				pyright = {
					settings = { python = { analysis = {
						typeCheckingMode = "standard",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
						inlayHints = {
							variableTypes = true, functionReturnTypes = true,
							callArgumentNames = true, pytestParameters = true,
						},
					}}},
				},
				ts_ls = {
					settings = {
						typescript = { inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						}},
						javascript = { inlayHints = {
							includeInlayParameterNameHints = "literals",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						}},
					},
				},
				rust_analyzer = {
					settings = { ["rust-analyzer"] = {
						inlayHints = {
							chainingHints = { enable = true },
							closingBraceHints = { enable = true, minLines = 25 },
							closureReturnTypeHints = { enable = "with_block" },
							lifetimeElisionHints = { enable = "skip_trivial" },
							parameterHints = { enable = true },
							typeHints = { enable = true },
						},
						checkOnSave = { command = "clippy" },
						cargo = { allFeatures = true },
						procMacro = { enable = true },
					}},
				},
				nixd = {
					settings = { nixd = { formatting = { command = { "nixfmt" } } } },
				},
				qmlls = { cmd = { "qmlls" } },
				-- servers that work well with defaults
				bashls = {}, html = {}, cssls = {}, yamlls = {},
				dockerls = {}, docker_compose_language_service = {},
				marksman = {}, clangd = {},
				jsonls = {
					cmd = { "vscode-json-language-server", "--stdio" },
					filetypes = { "json", "jsonc" },
					settings = {
						json = {
							validate = { enable = true },
							format  = { enable = true },
						},
					},
				},
			}

			for name, extra in pairs(servers) do
				vim.lsp.config(name, vim.tbl_deep_extend("force", {
					on_attach = on_attach,
					capabilities = capabilities,
				}, extra))
			end
			vim.lsp.enable(vim.tbl_keys(servers))

			-- conform (formatters)
			require("conform").setup({
				formatters = {
					google_java_format = { command = "google-java-format", args = { "--aosp", "-" }, stdin = true },
					kdlfmt = { command = "kdlfmt", args = { "format", "-" }, stdin = true },
				},
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					javascript = { "prettier" }, typescript = { "prettier" },
					json = { "prettier" }, yaml = { "prettier" },
					markdown = { "prettier" },
					nix = { "nixfmt" },
					rust = { "rustfmt" },
					sh = { "shfmt" }, bash = { "shfmt" },
					kdl = { "kdlfmt" },
					java = { "google_java_format" },
					qml = { "qmlformat" },
				},
			})
		end,
	},

	{
		"stevearc/aerial.nvim",
		event = "LspAttach",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>a",  "<cmd>AerialToggle<cr>", desc = "Aerial outline" },
			{ "<leader>fa", "<cmd>Telescope aerial<cr>", desc = "Find symbol (aerial)" },
			{ "{", "<cmd>AerialPrev<cr>", desc = "Prev symbol" },
			{ "}", "<cmd>AerialNext<cr>", desc = "Next symbol" },
		},
		config = function()
			require("aerial").setup({
				attach_mode = "cursor",
				backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
				show_guides = true,
				filter_kind = false,
				layout = { max_width = { 40, 0.2 }, min_width = 20, default_direction = "prefer_right" },
			})
			require("telescope").load_extension("aerial")
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
		},
	},
}
