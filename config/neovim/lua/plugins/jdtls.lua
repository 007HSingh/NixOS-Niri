-- ============================================================================
-- nvim-jdtls — Enhanced Java LSP + DAP integration
-- ============================================================================
return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	config = function()
		-- Locate the java-debug jar from the nix store
		local java_debug_jar = vim.env.JAVA_DEBUG_JAR
		local bundles = {}
		if java_debug_jar then
			table.insert(bundles, java_debug_jar)
		end

		-- jdtls is already on PATH via nix
		local jdtls_cmd = { "jdtls" }

		-- Workspace directory (one per project)
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

		local jdtls = require("jdtls")

		local config = {
			cmd = jdtls_cmd,
			root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
			settings = {
				java = {
					inlayHints = { parameterNames = { enabled = "all" } },
					signatureHelp = { enabled = true },
					contentProvider = { preferred = "fernflower" },
				},
			},
			init_options = {
				bundles = bundles,
				workspaceFolders = workspace_dir,
			},
			on_attach = function(client, bufnr)
				-- Set up DAP integration when jdtls attaches
				if java_debug_jar then
					jdtls.setup_dap({ hotcodereplace = "auto" })
					require("jdtls.dap").setup_dap_main_class_configs()
				end
			end,
		}

		-- Start or attach jdtls
		jdtls.start_or_attach(config)
	end,
}
