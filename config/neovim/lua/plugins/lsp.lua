-- ============================================================================
-- LSP — Language Server Protocol configuration (Neovim 0.12+ native API)
-- ============================================================================
return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
			"jay-babu/mason-null-ls.nvim",
			"nvimtools/none-ls.nvim",
			"nvimtools/none-ls-extras.nvim",
			"stevearc/conform.nvim",
			"folke/trouble.nvim",
			"ray-x/lsp_signature.nvim",
			"smjonas/inc-rename.nvim",
		},
		event = "BufReadPre",
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_null_ls = require("mason-null-ls")
			local null_ls = require("null-ls")
			local conform = require("conform")

			-- ── Mason ─────────────────────────────────────────────────────────
			mason.setup({
				ui = { border = "rounded" },
			})
			mason_lspconfig.setup({ ensure_installed = {} })
			mason_null_ls.setup({ ensure_installed = {} })

			-- ── Capabilities: merge LSP defaults with cmp's extra capabilities ─
			-- This is the key step most basic configs miss. Without this, LSP
			-- servers don't know the client supports snippet completions,
			-- labelDetails, insertReplaceEdit, etc.
			local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_lsp.default_capabilities() or {}
			)
			-- Tell servers we support folding (nvim-ufo)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			-- ── Diagnostic configuration ──────────────────────────────────────
			-- Rich virtual text with icons, better sign column, float on cursor
			vim.diagnostic.config({
				-- Show diagnostic message inline as virtual text at end of line
				virtual_text = {
					spacing = 4,
					source = "if_many", -- only show source when multiple LSPs
					prefix = function(diagnostic)
						local icons = {
							[vim.diagnostic.severity.ERROR] = " ",
							[vim.diagnostic.severity.WARN] = " ",
							[vim.diagnostic.severity.INFO] = " ",
							[vim.diagnostic.severity.HINT] = "󰌵 ",
						}
						return icons[diagnostic.severity] or "● "
					end,
				},
				-- Also show structured lines as a separate virtual_lines block
				-- (Neovim 0.11+: shows the full message below the offending line)
				virtual_lines = false, -- toggle with <leader>tl if you want it
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.INFO] = " ",
						[vim.diagnostic.severity.HINT] = "󰌵 ",
					},
				},
				underline = true,
				update_in_insert = false, -- don't flash while typing
				severity_sort = true,
				float = {
					focusable = true,
					border = "rounded",
					source = true, -- always show "eslint:", "pyright:" etc.
					header = "",
					prefix = "",
					max_width = 100,
					max_height = 20,
				},
			})

			-- ── Peek definition helper ────────────────────────────────────────
			local function peek_definition()
				local params = vim.lsp.util.make_position_params(0, "utf-16")
				vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
					if not result or vim.tbl_isempty(result) then
						return
					end
					local target = vim.islist(result) and result[1] or result
					vim.lsp.util.preview_location(target, { border = "rounded" })
				end)
			end

			-- ── on_attach: runs every time a server attaches to a buffer ──────
			local on_attach = function(client, bufnr)
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
				end

				-- ── Navigation ───────────────────────────────────────────────
				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
				map("n", "gr", vim.lsp.buf.references, "Show references")
				map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
				map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
				map("n", "K", vim.lsp.buf.hover, "Hover documentation")
				map("n", "gp", peek_definition, "Peek definition")
				map("n", "gh", vim.lsp.buf.references, "LSP references")

				-- ── Code actions & refactoring ────────────────────────────────
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("v", "<leader>ca", vim.lsp.buf.code_action, "Code action (range)")
				map("n", "<leader>co", "<cmd>Trouble symbols toggle focus=true<cr>", "Symbols outline")
				map("n", "<leader>cr", function()
					vim.cmd("IncRename " .. vim.fn.expand("<cword>"))
				end, "Rename (IncRename)")

				-- ── Diagnostics ───────────────────────────────────────────────
				map("n", "<leader>cl", vim.diagnostic.open_float, "Line diagnostics")
				map("n", "<leader>cf", function()
					require("conform").format({ bufnr = bufnr, async = true })
				end, "Format buffer")

				-- ── Inlay hints (Neovim 0.10+) ────────────────────────────────
				-- Shows parameter names and type annotations inline in the buffer.
				-- e.g., func(/*count:*/ 3, /*verbose:*/ true)
				if client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					-- Toggle keymap
					map("n", "<leader>th", function()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
						vim.notify("Inlay hints: " .. (not enabled and "enabled" or "disabled"), vim.log.levels.INFO)
					end, "Toggle inlay hints")
				end

				-- ── Signature help while typing (lsp_signature) ───────────────
				-- Shows function signature popup as you type arguments.
				-- Much more useful than the default since it highlights the
				-- current parameter as you tab through arguments.
				if client:supports_method("textDocument/signatureHelp") then
					require("lsp_signature").on_attach({
						bind = true,
						handler_opts = { border = "rounded" },
						hint_enable = true,
						hint_prefix = "󰏫 ",
						hint_scheme = "Comment",
						hi_parameter = "LspSignatureActiveParameter",
						max_height = 12,
						max_width = 80,
						wrap = true,
						floating_window = true,
						floating_window_above_cur_line = true,
						toggle_key = "<C-s>", -- manually re-trigger signature help
						select_signature_key = "<M-n>", -- cycle through overloads
					}, bufnr)
				end

				-- ── Document highlight (illuminate word under cursor) ─────────
				-- When cursor rests on a symbol, all other references in the
				-- buffer get highlighted. Falls back to vim-illuminate.
				if client:supports_method("textDocument/documentHighlight") then
					local group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = bufnr,
						group = group,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = bufnr,
						group = group,
						callback = vim.lsp.buf.clear_references,
					})
				end

				-- ── Code lens (show test counts, references inline) ───────────
				if client:supports_method("textDocument/codeLens") then
					vim.lsp.codelens.enable(true, { bufnr = bufnr })
					map("n", "<leader>cL", vim.lsp.codelens.run, "Run code lens")
				end

				-- ── Workspace folders ─────────────────────────────────────────
				map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
				map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
				map("n", "<leader>wl", function()
					vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()), vim.log.levels.INFO)
				end, "List workspace folders")
			end

			-- ── Server configurations ──────────────────────────────────────────
			-- Per-server settings passed on top of the shared on_attach + capabilities.
			local server_settings = {
				lua_ls = {
					settings = {
						Lua = {
							-- Inlay hints for Lua
							hint = {
								enable = true,
								arrayIndex = "Disable", -- too noisy
								setType = true,
								paramName = "All",
								paramType = true,
							},
							-- Don't warn about vim globals
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
							completion = { callSnippet = "Replace" },
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "standard",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
								-- Inlay hint support
								inlayHints = {
									variableTypes = true,
									functionReturnTypes = true,
									callArgumentNames = true,
									pytestParameters = true,
								},
							},
						},
					},
				},
				ts_ls = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all", -- "none" | "literals" | "all"
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "literals",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							inlayHints = {
								bindingModeHints = { enable = false },
								chainingHints = { enable = true },
								closingBraceHints = { enable = true, minLines = 25 },
								closureReturnTypeHints = { enable = "with_block" },
								lifetimeElisionHints = { enable = "skip_trivial" },
								parameterHints = { enable = true },
								reborrowHints = { enable = "closure" },
								renderColons = true,
								typeHints = {
									enable = true,
									hideClosureInitialization = false,
									hideNamedConstructor = false,
								},
							},
							checkOnSave = { command = "clippy" }, -- use clippy for linting
							cargo = { allFeatures = true },
							procMacro = { enable = true },
							lens = {
								-- Show "Run | Debug | N references" above functions
								enable = true,
								references = { enable = true },
								implementations = { enable = true },
								enumVariantReferences = { enable = true },
								methodReferences = { enable = true },
							},
						},
					},
				},
				nixd = {
					settings = {
						nixd = {
							formatting = { command = { "nixfmt" } },
						},
					},
				},
				jdtls = {
					settings = {
						java = {
							inlayHints = { parameterNames = { enabled = "all" } },
							signatureHelp = { enabled = true },
							contentProvider = { preferred = "fernflower" },
						},
					},
				},
				-- Servers that work well with just defaults:
				bashls = {},
				html = {},
				cssls = {},
				jsonls = {},
				yamlls = {},
			}

			-- Apply shared config + per-server settings
			for name, extra in pairs(server_settings) do
				local cfg = vim.tbl_deep_extend("force", {
					on_attach = on_attach,
					capabilities = capabilities,
				}, extra)
				vim.lsp.config(name, cfg)
			end
			vim.lsp.enable(vim.tbl_keys(server_settings))

			-- ── Toggle virtual_lines (multi-line diagnostics) ─────────────────
			vim.keymap.set("n", "<leader>tl", function()
				local current = vim.diagnostic.config().virtual_lines
				vim.diagnostic.config({ virtual_lines = not current })
				vim.notify(
					"Diagnostic virtual lines: " .. (not current and "enabled" or "disabled"),
					vim.log.levels.INFO
				)
			end, { desc = "Toggle diagnostic virtual lines" })

			-- ── Null-ls ───────────────────────────────────────────────────────
			null_ls.setup({ sources = {} })

			-- ── Conform (formatter) ───────────────────────────────────────────
			conform.setup({
				formatters = {
					google_java_format = {
						command = "google-java-format",
						args = { "-" },
						stdin = true,
					},
				},
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					nix = { "nixfmt" },
					rust = { "rustfmt" },
					sh = { "shfmt" },
					bash = { "shfmt" },
					kdl = { "kdlfmt" },
					java = { "google_java_format" },
				},
			})
		end,
	},
}
