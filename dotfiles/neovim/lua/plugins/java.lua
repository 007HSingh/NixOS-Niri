-- Java ecosystem: jdtls LSP, neotest, kulala HTTP, dadbod DB
return {

	--- JDTLS — Eclipse JDT Language Server (Java LSP via nvim-jdtls).
	--- Keymaps are buffer-local in on_attach (need bufnr + client context).
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local java_debug_jar = vim.env.JAVA_DEBUG_JAR
			local java_test_jar = vim.env.JAVA_TEST_JAR
			local lombok_jar = vim.env.LOMBOK_JAR

			local bundles = {}
			if java_debug_jar and java_debug_jar ~= "" then
				table.insert(bundles, java_debug_jar)
			end
			if java_test_jar and java_test_jar ~= "" then
				if vim.fn.isdirectory(java_test_jar) == 1 then
					vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_jar .. "/*.jar"), "\n", { trimempty = true }))
				else
					table.insert(bundles, java_test_jar)
				end
			end

			local jdtls_cmd = { "jdtls" }
			if lombok_jar and lombok_jar ~= "" then
				vim.list_extend(jdtls_cmd, {
					"--jvm-arg=-javaagent:" .. lombok_jar,
					"--jvm-arg=-Xbootclasspath/a:" .. lombok_jar,
				})
			end

			local function get_workspace(root)
				local name = root:gsub("[/\\%s:]", "_"):gsub("^_+", "")
				return vim.fn.stdpath("data") .. "/jdtls-workspace/" .. name
			end

			local jdtls = require("jdtls")
			local jdtls_setup = require("jdtls.setup")

			local root_markers = {
				"gradlew", "build.gradle", "build.gradle.kts",
				"settings.gradle", "settings.gradle.kts",
				"mvnw", "pom.xml", ".git",
			}

			local function get_root()
				return jdtls_setup.find_root(root_markers) or vim.fn.getcwd()
			end

			local capabilities = vim.tbl_deep_extend("force", require("blink.cmp").get_lsp_capabilities(), {
				textDocument = {
					foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
				},
			})

			local function on_attach(client, bufnr)
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
				end

				-- standard LSP navigation
				map("n", "gd",  vim.lsp.buf.definition,    "Go to definition")
				map("n", "gD",  vim.lsp.buf.declaration,   "Go to declaration")
				map("n", "gi",  vim.lsp.buf.implementation, "Go to implementation")
				map("n", "gr",  vim.lsp.buf.references,    "References")
				map("n", "gt",  vim.lsp.buf.type_definition, "Type definition")
				map("n", "K",   vim.lsp.buf.hover,         "Hover / JavaDoc")

				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("v", "<leader>ca", vim.lsp.buf.code_action, "Code action (range)")
				map("n", "<leader>cr", function()
					vim.cmd("IncRename " .. vim.fn.expand("<cword>"))
				end, "Rename")
				map("n", "<leader>cL", vim.lsp.codelens.run,                           "Run code lens")
				map("n", "<leader>co", "<cmd>Trouble symbols toggle focus=true<cr>",   "Symbols outline")
				map("n", "<leader>cl", vim.diagnostic.open_float,                      "Line diagnostics")
				map("n", "[d",         vim.diagnostic.goto_prev,                       "Previous diagnostic")
				map("n", "]d",         vim.diagnostic.goto_next,                       "Next diagnostic")

				if client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					map("n", "<leader>th", function()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
					end, "Toggle inlay hints")
				end

				if client:supports_method("textDocument/documentHighlight") then
					local group = vim.api.nvim_create_augroup("JdtlsDocumentHighlight" .. bufnr, { clear = true })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						group = group, buffer = bufnr, callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						group = group, buffer = bufnr, callback = vim.lsp.buf.clear_references,
					})
				end

				if client:supports_method("textDocument/codeLens") then
					vim.lsp.codelens.enable(true, { bufnr = bufnr })
				end

				local ok, navic = pcall(require, "nvim-navic")
				if ok then navic.attach(client, bufnr) end

				-- Java-specific actions
				map("n", "<leader>ji", jdtls.organize_imports, "Organize imports")
				map("n", "<leader>jI", function()
					vim.lsp.buf.code_action({ context = { only = { "source.addImport" } }, apply = true })
				end, "Add import (cursor)")

				-- generate
				map("n", "<leader>jgs", function()
					vim.lsp.buf.code_action({ context = { only = { "source.generate.accessors" } }, apply = true })
				end, "Generate getters/setters")
				map("n", "<leader>jgt", function()
					vim.lsp.buf.code_action({ context = { only = { "source.generate.toString" } }, apply = true })
				end, "Generate toString")
				map("n", "<leader>jge", function()
					vim.lsp.buf.code_action({ context = { only = { "source.generate.hashCodeEquals" } }, apply = true })
				end, "Generate hashCode/equals")
				map("n", "<leader>jgc", function()
					vim.lsp.buf.code_action({ context = { only = { "source.generate.constructor" } }, apply = true })
				end, "Generate constructor")

				-- extract
				map("n", "<leader>jxv", jdtls.extract_variable, "Extract variable")
				map("v", "<leader>jxv", function() jdtls.extract_variable(true) end, "Extract variable (selection)")
				map("n", "<leader>jxc", jdtls.extract_constant, "Extract constant")
				map("v", "<leader>jxc", function() jdtls.extract_constant(true) end, "Extract constant (selection)")
				map("n", "<leader>jxm", jdtls.extract_method, "Extract method")
				map("v", "<leader>jxm", function() jdtls.extract_method(true) end, "Extract method (selection)")

				-- test (jdtls built-in runner)
				map("n", "<leader>jtt", jdtls.test_nearest_method, "Test method")
				map("n", "<leader>jtc", jdtls.test_class, "Test class")

				-- Spring
				map("n", "<leader>jSa", function()
					vim.lsp.buf.code_action({ context = { only = { "source" } } })
				end, "Spring source actions")
				map("n", "<leader>jSb", function()
					vim.lsp.buf.code_action({
						context = { only = { "source.generate.constructor" } }, apply = true,
					})
				end, "Generate constructor")

				-- build / workspace
				map("n", "<leader>jm", "<cmd>OverseerRun<cr>",             "Run Maven / Gradle")
				map("n", "<leader>jw", "<cmd>JdtUpdateConfig<cr>",         "Reload config")
				map("n", "<leader>jW", "<cmd>JdtCompile incremental<cr>",  "Compile incremental")
				map("n", "<leader>jF", "<cmd>JdtCompile full<cr>",         "Compile full")

				if java_debug_jar and java_debug_jar ~= "" then
					jdtls.setup_dap({ hotcodereplace = "auto", config_overrides = {} })
					vim.defer_fn(function()
						require("jdtls.dap").setup_dap_main_class_configs()
					end, 1500)
				end
			end

			local function make_config()
				local root = get_root()
				local workspace = get_workspace(root)
				return {
					cmd = vim.list_extend(vim.deepcopy(jdtls_cmd), { "--data", workspace }),
					root_dir = root,
					capabilities = capabilities,
					settings = {
						java = {
							project = { referencedLibraries = {} },
							eclipse = { downloadSources = true },
							maven = { downloadSources = true, updateSnapshots = true },
							gradle = { enabled = true },
							configuration = {
								runtimes = {
									{ name = "JavaSE-21", path = vim.env.JAVA_HOME, default = true },
								},
							},
							format = {
								enabled = true,
								settings = {
									url = vim.env.GOOGLE_JAVA_STYLE
										or "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
									profile = "GoogleStyle",
								},
							},
							signatureHelp = { enabled = true, description = { enabled = true } },
							contentProvider = { preferred = "fernflower" },
							completion = {
								favoriteStaticMembers = {
									"org.junit.jupiter.api.Assertions.*",
									"org.junit.jupiter.api.Assumptions.*",
									"org.mockito.Mockito.*",
									"org.mockito.ArgumentMatchers.*",
									"org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
									"org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
									"org.hamcrest.Matchers.*",
									"org.assertj.core.api.Assertions.*",
								},
								filteredTypes = {
									"com.sun.*", "io.micrometer.shaded.*", "java.awt.*", "jdk.*", "sun.*",
								},
								guessMethodArguments = "auto",
							},
							sources = { organizeImports = { starThreshold = 3, staticStarThreshold = 3 } },
							inlayHints = { parameterNames = { enabled = "all", exclusions = { "this" } } },
							referencesCodeLens = { enabled = true },
							implementationsCodeLens = { enabled = true },
							import = { gradle = { enabled = true }, maven = { enabled = true } },
							semanticHighlighting = { enabled = true },
							autobuild = { enabled = false },
							foldingRange = { enabled = false },
						},
					},
					init_options = {
						bundles = bundles,
						extendedClientCapabilities = (function()
							local ec = vim.deepcopy(jdtls_setup.extendedClientCapabilities)
							ec.resolveAdditionalTextEditsSupport = true
							ec.progressReportProvider = true
							return ec
						end)(),
					},
					handlers = {
						["workspace/didChangeWorkspaceFolders"] = function() end,
					},
					on_attach = on_attach,
					on_init = function(client)
						client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
						client:notify("java/buildWorkspace", { fullBuild = false })
					end,
				}
			end

			local group = vim.api.nvim_create_augroup("JdtlsAttach", { clear = true })
			vim.api.nvim_create_autocmd("BufEnter", {
				group = group,
				pattern = "*.java",
				callback = function()
					require("jdtls").start_or_attach(make_config())
				end,
			})

			local ok, wk = pcall(require, "which-key")
			if ok then
				wk.add({
					{ "<leader>j",  group = "Java",     icon = { icon = "󰬷", color = "orange" } },
					{ "<leader>jx", group = "Extract",  icon = { icon = "󰆏", color = "yellow" } },
					{ "<leader>jg", group = "Generate", icon = { icon = "󰛄", color = "cyan"   } },
					{ "<leader>jt", group = "Test",     icon = { icon = "󰙨", color = "green"  } },
					{ "<leader>jS", group = "Spring",   icon = { icon = "󱞉", color = "green"  } },
				})
			end

			require("jdtls").start_or_attach(make_config())
		end,
	},

	--- Neotest — test runner UI; keymaps are in keymaps.lua under <leader>jt.
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"rcasia/neotest-java",
		},
		config = function()
			local java_test_jar = vim.env.JAVA_TEST_JAR
			require("neotest").setup({
				adapters = {
					require("neotest-java")({ junit_jar = java_test_jar or nil }),
				},
				status = { enabled = true, signs = true, virtual_text = true },
				icons = {
					child_indent = "│", child_prefix = "├", collapsed = "─",
					expanded = "╮", failed = "✗", final_child_indent = " ",
					final_child_prefix = "╰", non_collapsible = "─", passed = "✓",
					running = "󰑮",
					running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
					skipped = "○", unknown = "?", watching = "󰈈",
				},
				output = { open_on_run = false },
				diagnostic = { enabled = true, severity = vim.diagnostic.severity.ERROR },
				quickfix = { enabled = true, open = false },
				summary = {
					animated = true, follow = true, expand_errors = true,
					mappings = {
						attach = "a", clear_marked = "M", clear_target = "T",
						debug = "d", debug_marked = "D",
						expand = { "<CR>", "<2-LeftMouse>" }, expand_all = "e",
						help = "?", jump = "o", mark = "m", output = "O",
						run = "r", run_marked = "R", short = "L", stop = "u",
						target = "t", watch = "w",
					},
				},
			})

			local ok, wk = pcall(require, "which-key")
			if ok then
				wk.add({ { "<leader>jt", group = "Test", icon = { icon = "󰙨", color = "green" }, ft = "java" } })
			end
		end,
	},

	--- Kulala — HTTP client for .http/.rest files.
	--- Global scratch keymap is in keymaps.lua; buffer-local keymaps are registered below via FileType autocmd.
	{
		"mistweaverco/kulala.nvim",
		ft = { "http", "rest" },
		opts = {
			split_direction = "horizontal",
			default_env = "dev",
			debug = false,
			icons = {
				inlay = { loading = "󰔟", done = "󰩐", error = "󰜺" },
				lualine = "󰖟",
			},
			formatters = {
				json = { "jq", "." },
				xml  = { "xmllint", "--format", "-" },
				html = { "prettier", "--parser", "html" },
			},
			scratchpad_default_contents = {
				"@BASE_URL = http://localhost:8080",
				"",
				"### Health check",
				"GET {{BASE_URL}}/actuator/health",
				"Accept: application/json",
				"",
				"### Example POST",
				"# POST {{BASE_URL}}/api/resource",
				"# Content-Type: application/json",
				"#",
				"# {",
				'#   "key": "value"',
				"# }",
			},
		},
		config = function(_, opts)
			require("kulala").setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "http", "rest" },
				group = vim.api.nvim_create_augroup("KulalaKeys", { clear = true }),
				callback = function(ev)
					local function map(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
					end
					local k = require("kulala")
					map("<leader>jHr", function() k.run() end,              "HTTP: run request")
					map("<leader>jHR", function() k.run_all() end,          "HTTP: run all")
					map("<leader>jHp", function() k.replay() end,           "HTTP: replay last")
					map("<leader>jHi", function() k.inspect() end,          "HTTP: inspect (curl)")
					map("<leader>jHc", function() k.copy() end,             "HTTP: copy as curl")
					map("<leader>jHe", function() k.set_selected_env() end, "HTTP: select env")
					map("<leader>jHo", function() k.show_stats() end,       "HTTP: response stats")
					map("<leader>jH[", function() k.jump_prev() end,        "HTTP: prev request")
					map("<leader>jH]", function() k.jump_next() end,        "HTTP: next request")
					local ok, wk = pcall(require, "which-key")
					if ok then
						wk.add({ { "<leader>jH", group = "HTTP Client", buffer = ev.buf } })
					end
				end,
			})
		end,
	},

	--- vim-dadbod — database query engine (backend only).
	{ "tpope/vim-dadbod", cmd = { "DB" }, lazy = true },

	--- vim-dadbod-ui — database browser UI; keymaps are in keymaps.lua under <leader>jD.
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			"tpope/vim-dadbod",
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		init = function()
			vim.g.db_ui_save_location = vim.fn.stdpath("state") .. "/db_ui"
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1

			if vim.env.DATABASE_URL and vim.env.DATABASE_URL ~= "" then
				local dbs = vim.deepcopy(vim.g.dbs or {})
				local has = false
				for _, db in ipairs(dbs) do
					if db.url == vim.env.DATABASE_URL then has = true; break end
				end
				if not has then
					table.insert(dbs, { name = "default (DATABASE_URL)", url = vim.env.DATABASE_URL })
				end
				vim.g.dbs = dbs
			end

			vim.g.db_ui_icons = {
				expanded  = {
					db = "▾ ", buffers = "▾ ", saved_queries = "▾ ",
					schemas = "▾ ", schema = "▾ ", tables = "▾ ", table = "▾ ",
				},
				collapsed = {
					db = "▸ ", buffers = "▸ ", saved_queries = "▸ ",
					schemas = "▸ ", schema = "▸ ", tables = "▸ ", table = "▸ ",
				},
				saved_query = " ", new_query = "󰓤 ", tables = "󰓫 ", buffers = "󰓘 ",
				connection_ok = "✓", connection_error = "✕",
			}
		end,
		config = function()
			local ok, wk = pcall(require, "which-key")
			if ok then
				wk.add({ { "<leader>jD", group = "Database", icon = { icon = "󰆼", color = "blue" } } })
			end
		end,
	},
}
