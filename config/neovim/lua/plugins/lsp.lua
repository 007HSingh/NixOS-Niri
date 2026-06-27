return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			"b0o/SchemaStore.nvim",
			-- NOTE: conform.nvim, trouble.nvim, and inc-rename.nvim used to be listed
			-- here. Being a "dependency" of lspconfig forces eager loading on every
			-- BufReadPre, overriding their own lazy cmd/keys specs (trouble.nvim alone
			-- adds ~3-6ms to every file open this way). conform now has its own spec
			-- below with an explicit load event; trouble/inc-rename already lazy-load
			-- fine via the cmd strings and keymaps that reference them elsewhere.
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

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

			local function on_attach(client, bufnr)
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
				end

				-- moved inside on_attach (was a free function using a hard-coded
				-- "utf-16" offset) so it can use the negotiated offset encoding for
				-- this specific client — clangd in particular prefers "utf-8".
				local function peek_definition()
					local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
					vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
						if not result or vim.tbl_isempty(result) then
							return
						end
						local target = vim.islist(result) and result[1] or result
						vim.lsp.util.preview_location(target)
					end)
				end

				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
				map("n", "gr", vim.lsp.buf.references, "References")
				map("n", "gt", vim.lsp.buf.type_definition, "Type definition")
				map("n", "K", vim.lsp.buf.hover, "Hover")
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

				if client:supports_method("textDocument/documentHighlight") then
					local group = vim.api.nvim_create_augroup("LspDocHL_" .. bufnr, { clear = true })
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

				if client:supports_method("textDocument/codeLens") then
					vim.lsp.codelens.enable(true, { bufnr = bufnr })
					local cg = vim.api.nvim_create_augroup("LspCodeLens_" .. bufnr, { clear = true })
					vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
						buffer = bufnr,
						group = cg,
						callback = function()
							vim.lsp.codelens.refresh({ bufnr = bufnr })
						end,
					})
				end

				if client:supports_method("textDocument/documentSymbol") then
					local ok, navic = pcall(require, "nvim-navic")
					if ok then
						navic.attach(client, bufnr)
					end
				end
			end

			local schemastore = require("schemastore")

			-- per-server settings (merged on top of shared on_attach + capabilities)
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							hint = { enable = true, setType = true, paramName = "All", paramType = true },
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
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "literals",
								includeInlayFunctionParameterTypeHints = true,
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
						},
					},
				},
				nixd = {
					settings = { nixd = { formatting = { command = { "nixfmt" } } } },
				},
				-- TOML support for Cargo.toml etc. (Nix package: pkgs.taplo)
				taplo = {},
				-- servers that work well with defaults
				bashls = {},
				html = {},
				cssls = {},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								enable = false,
								url = "",
							},
							schemas = schemastore.yaml.schemas({
								extra = {
									{
										name = "Spring Boot application.yml",
										description = "Spring Boot application configuration",
										fileMatch = {
											"application.yml",
											"application.yaml",
											"application-*.yml",
											"application-*.yaml",
											"bootstrap.yml",
											"bootstrap.yaml",
											"bootstrap-*.yml",
											"bootstrap-*.yaml",
										},
										url = "https://www.schemastore.org/schemas/json/spring-boot-application.json",
									},
								},
							}),
							validate = true,
							completion = true,
							hover = true,
							format = {
								enable = true,
							},
							editor = {
								tabSize = 2,
							},
						},
					},
				},
				dockerls = {},
				docker_compose_language_service = {},
				marksman = {},
				clangd = {
					cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
					init_options = {
						clangdFileStatus = true,
						usePlaceholders = true,
						completeUnimported = true,
					},
				},
				jsonls = {
					cmd = { "vscode-json-language-server", "--stdio" },
					filetypes = { "json", "jsonc" },
					settings = {
						json = {
							schemas = schemastore.json.schemas(),
							validate = { enable = true },
							format = { enable = true },
						},
					},
					-- NOTE: on_new_config used to be set here. It's an nvim-lspconfig
					-- lifecycle hook that vim.lsp.config() (the native 0.11 API) silently
					-- ignores — it never ran. It's also redundant: schemas are already
					-- set directly above via schemastore.json.schemas().
				},
			}

			for name, extra in pairs(servers) do
				vim.lsp.config(
					name,
					vim.tbl_deep_extend("force", {
						on_attach = on_attach,
						capabilities = capabilities,
					}, extra)
				)
			end
			vim.lsp.enable(vim.tbl_keys(servers))

			-- conform (formatters) — also see the standalone spec below which gives
			-- conform its own load event instead of riding along as an implicit
			-- side effect of nvim-lspconfig's config() running.
			require("conform").setup({
				formatters = {
					-- was `args = { "--aosp", "-" }` (4-space AOSP style), which conflicted
					-- with jdtls.lua's GoogleStyle (2-space) eclipse formatter XML. Aligning
					-- both to GoogleStyle by dropping --aosp here.
					google_java_format = { command = "google-java-format", args = { "-" }, stdin = true },
					kdlfmt = { command = "kdlfmt", args = { "format", "-" }, stdin = true },
					shfmt = { prepend_args = { "-i", "2" } }, -- match the 2-space TwoSpaceIndent autocmd
				},
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format" }, -- was "black" — switched to match nvim-lint's move to ruff
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
					toml = { "taplo" },
				},
			})
		end,
	},

	-- conform.nvim now has its own explicit spec with a deterministic load event,
	-- rather than only loading as a side effect inside nvim-lspconfig's config().
	-- This also fixes the edge case where `:new` + immediate `:w` (no BufReadPre
	-- ever fires) used to risk require("conform") erroring in autocmds.lua before
	-- this plugin had loaded.
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufWritePre" },
	},

	{
		"stevearc/aerial.nvim",
		event = "LspAttach",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>a", "<cmd>AerialToggle<cr>", desc = "Aerial outline" },
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
