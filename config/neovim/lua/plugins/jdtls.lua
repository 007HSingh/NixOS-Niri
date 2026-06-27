return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
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
			"gradlew",
			"build.gradle",
			"build.gradle.kts",
			"settings.gradle",
			"settings.gradle.kts",
			"mvnw",
			"pom.xml",
			".git",
		}

		local function get_root()
			return jdtls_setup.find_root(root_markers) or vim.fn.getcwd()
		end

		local capabilities = vim.tbl_deep_extend("force", require("blink.cmp").get_lsp_capabilities(), {
			textDocument = {
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		})

		local function on_attach(client, bufnr)
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, {
					buffer = bufnr,
					silent = true,
					desc = desc,
				})
			end

			map("n", "gd", vim.lsp.buf.definition, "Go to definition")
			map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
			map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
			map("n", "gr", vim.lsp.buf.references, "References")
			map("n", "gt", vim.lsp.buf.type_definition, "Type definition")
			map("n", "K", vim.lsp.buf.hover, "Hover / JavaDoc")

			map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
			map("v", "<leader>ca", vim.lsp.buf.code_action, "Code action (range)")

			map("n", "<leader>cr", function()
				vim.cmd("IncRename " .. vim.fn.expand("<cword>"))
			end, "Rename")

			map("n", "<leader>cL", vim.lsp.codelens.run, "Run code lens")
			map("n", "<leader>co", "<cmd>Trouble symbols toggle focus=true<cr>", "Symbols outline")

			map("n", "<leader>cl", vim.diagnostic.open_float, "Line diagnostics")
			map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
			map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

			if client:supports_method("textDocument/inlayHint") then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

				map("n", "<leader>th", function()
					local enabled = vim.lsp.inlay_hint.is_enabled({
						bufnr = bufnr,
					})
					vim.lsp.inlay_hint.enable(not enabled, {
						bufnr = bufnr,
					})
				end, "Toggle inlay hints")
			end

			if client:supports_method("textDocument/documentHighlight") then
				local group = vim.api.nvim_create_augroup("JdtlsDocumentHighlight" .. bufnr, { clear = true })

				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = group,
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					group = group,
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
				})
			end

			if client:supports_method("textDocument/codeLens") then
				vim.lsp.codelens.enable(true, { bufnr = bufnr })
			end

			local ok, navic = pcall(require, "nvim-navic")
			if ok then
				navic.attach(client, bufnr)
			end

			map("n", "<leader>ji", jdtls.organize_imports, "Organize imports")
			map("n", "<leader>jI", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.addImport" } },
					apply = true,
				})
			end, "Add import (cursor)")

			map("n", "<leader>jgs", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.generate.accessors" } },
					apply = true,
				})
			end, "Generate getters/setters")
			map("n", "<leader>jgt", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.generate.toString" } },
					apply = true,
				})
			end, "Generate toString")
			map("n", "<leader>jge", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.generate.hashCodeEquals" } },
					apply = true,
				})
			end, "Generate hashCode/equals")
			map("n", "<leader>jgc", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.generate.constructor" } },
					apply = true,
				})
			end, "Generate constructor")

			map("n", "<leader>jxv", jdtls.extract_variable, "Extract variable")
			map("v", "<leader>jxv", function()
				jdtls.extract_variable(true)
			end, "Extract variable (selection)")

			map("n", "<leader>jxc", jdtls.extract_constant, "Extract constant")
			map("v", "<leader>jxc", function()
				jdtls.extract_constant(true)
			end, "Extract constant (selection)")

			map("n", "<leader>jxm", jdtls.extract_method, "Extract method")
			map("v", "<leader>jxm", function()
				jdtls.extract_method(true)
			end, "Extract method (selection)")

			map("n", "<leader>jtt", jdtls.test_nearest_method, "Test method")
			map("n", "<leader>jtc", jdtls.test_class, "Test class")

			map("n", "<leader>jSa", function()
				vim.lsp.buf.code_action({
					context = {
						only = { "source" },
					},
				})
			end, "Spring source actions")

			map("n", "<leader>jSb", function()
				vim.lsp.buf.code_action({
					context = {
						only = {
							"source.generate.constructor",
						},
					},
					apply = true,
				})
			end, "Generate constructor")

			map("n", "<leader>jm", "<cmd>OverseerRun<cr>", "Run Maven / Gradle")

			map("n", "<leader>jw", "<cmd>JdtUpdateConfig<cr>", "Reload config")
			map("n", "<leader>jW", "<cmd>JdtCompile incremental<cr>", "Compile incremental")
			map("n", "<leader>jF", "<cmd>JdtCompile full<cr>", "Compile full")

			if java_debug_jar and java_debug_jar ~= "" then
				jdtls.setup_dap({
					hotcodereplace = "auto",
				})
				require("jdtls.dap").setup_dap_main_class_configs()
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
						project = {
							referencedLibraries = {},
						},

						eclipse = {
							downloadSources = true,
						},

						maven = {
							downloadSources = true,
							updateSnapshots = true,
						},

						gradle = {
							enabled = true,
						},

						format = {
							enabled = true,
							settings = {
								-- Prefer a Nix-managed local path (set GOOGLE_JAVA_STYLE to a
								-- pkgs.fetchurl result in your Nix config) over fetching this
								-- over the network on every jdtls start. Falls back to the
								-- network URL if the env var isn't set.
								url = vim.env.GOOGLE_JAVA_STYLE
									or "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
								profile = "GoogleStyle",
							},
						},

						signatureHelp = {
							enabled = true,
							description = {
								enabled = true,
							},
						},

						contentProvider = {
							preferred = "fernflower",
						},

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
								"com.sun.*",
								"io.micrometer.shaded.*",
								"java.awt.*",
								"jdk.*",
								"sun.*",
							},

							guessMethodArguments = "auto",
						},

						sources = {
							organizeImports = {
								starThreshold = 3,
								staticStarThreshold = 3,
							},
						},

						inlayHints = {
							parameterNames = {
								enabled = "all",
								exclusions = { "this" },
							},
						},

						referencesCodeLens = {
							enabled = true,
						},

						implementationsCodeLens = {
							enabled = true,
						},

						import = {
							gradle = {
								enabled = true,
							},
							maven = {
								enabled = true,
							},
						},

						semanticHighlighting = {
							enabled = true,
						},

						autobuild = {
							enabled = false,
						},

						foldingRange = {
							enabled = false,
						},
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
					client.notify("workspace/didChangeConfiguration", {
						settings = client.config.settings,
					})

					client.notify("java/buildWorkspace", {
						fullBuild = false,
					})
				end,
			}
		end
		local group = vim.api.nvim_create_augroup("JdtlsAttach", {
			clear = true,
		})

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
				{
					"<leader>j",
					group = "Java",
					icon = { icon = "󰬷", color = "orange" },
				},
				{
					"<leader>jx",
					group = "Extract",
					icon = { icon = "󰆏", color = "yellow" },
				},
				{
					"<leader>jg",
					group = "Generate",
					icon = { icon = "󰛄", color = "cyan" },
				},
				{
					"<leader>jt",
					group = "Test",
					icon = { icon = "󰙨", color = "green" },
				},
				{
					"<leader>jS",
					group = "Spring",
					icon = { icon = "󱞉", color = "green" },
				},
			})
		end

		require("jdtls").start_or_attach(make_config())
	end,
}
