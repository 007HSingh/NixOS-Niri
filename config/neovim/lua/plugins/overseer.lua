return {
	"stevearc/overseer.nvim",
	cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild", "OverseerInfo", "OverseerTaskAction" },
	keys = {
		{ "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer: toggle panel" },
		{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: run task" },
		{ "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer: build" },
		{ "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Overseer: task action" },
		{ "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer: info" },
		{ "<leader>ol", "<cmd>OverseerLoadBundle<cr>", desc = "Overseer: load bundle" },
	},
	config = function()
		local overseer = require("overseer")

		overseer.setup({
			task_list = {
				direction = "bottom",
				min_height = 12,
				max_height = 20,
				default_detail = 1,
				bindings = {
					["<CR>"] = "RunAction",
					["<C-e>"] = "Edit",
					["o"] = "Open",
					["<C-v>"] = "OpenVsplit",
					["q"] = "Close",
					["?"] = "ShowHelp",
					["<C-r>"] = "Restart",
					["<C-c>"] = "Stop",
				},
			},

			templates = { "builtin", "java" },

			component_aliases = {
				default = {
					{ "display_duration", detail_level = 2 },
					"on_output_summarize",
					"on_exit_set_status",
					{ "on_complete_notify", statuses = { "FAILURE" } },
					"on_complete_dispose",
				},
			},
		})

		local function detect_build_tool()
			local root = vim.fn.getcwd()
			if
				vim.fn.filereadable(root .. "/gradlew") == 1
				or vim.fn.filereadable(root .. "/build.gradle") == 1
				or vim.fn.filereadable(root .. "/build.gradle.kts") == 1
			then
				return "gradle"
			elseif vim.fn.filereadable(root .. "/mvnw") == 1 or vim.fn.filereadable(root .. "/pom.xml") == 1 then
				return "maven"
			end
			return nil
		end

		local function gradle_cmd()
			local cwd = vim.fn.getcwd()
			if vim.fn.filereadable(cwd .. "/gradlew") == 1 then
				return "./gradlew"
			end
			return "gradle"
		end

		local function mvn_cmd()
			local cwd = vim.fn.getcwd()
			if vim.fn.filereadable(cwd .. "/mvnw") == 1 then
				return "./mvnw"
			end
			return "mvn"
		end

		local function gradle_condition(opts)
			local root = opts.dir or vim.fn.getcwd()
			return vim.fn.filereadable(root .. "/build.gradle") == 1
				or vim.fn.filereadable(root .. "/build.gradle.kts") == 1
				or vim.fn.filereadable(root .. "/gradlew") == 1
		end

		local function maven_condition(opts)
			local root = opts.dir or vim.fn.getcwd()
			return vim.fn.filereadable(root .. "/pom.xml") == 1
		end

		local gradle_templates = {
			{ name = "Gradle: build", args = { "build" } },
			{ name = "Gradle: build (skip tests)", args = { "build", "-x", "test" } },
			{ name = "Gradle: clean", args = { "clean" } },
			{ name = "Gradle: clean build", args = { "clean", "build" } },
			{ name = "Gradle: test", args = { "test" } },
			{ name = "Gradle: bootRun", args = { "bootRun" } },
			{ name = "Gradle: bootRun (dev)", args = { "bootRun", "--args=--spring.profiles.active=dev" } },
			{ name = "Gradle: bootRun (prod)", args = { "bootRun", "--args=--spring.profiles.active=prod" } },
			{ name = "Gradle: bootJar", args = { "bootJar" } },
			{ name = "Gradle: assemble", args = { "assemble" } },
			{ name = "Gradle: dependencies", args = { "dependencies" } },
		}

		for _, tpl in ipairs(gradle_templates) do
			local args = tpl.args
			local name = tpl.name
			overseer.register_template({
				name = name,
				condition = { callback = gradle_condition },
				builder = function()
					return {
						name = name,
						cmd = gradle_cmd(),
						args = args,
						components = {
							{ "on_output_quickfix", open_on_exit = "failure" },
							"default",
						},
					}
				end,
			})
		end

		local maven_templates = {
			{ name = "Maven: package", args = { "package" } },
			{ name = "Maven: package (skip tests)", args = { "package", "-DskipTests" } },
			{ name = "Maven: clean", args = { "clean" } },
			{ name = "Maven: clean package", args = { "clean", "package" } },
			{ name = "Maven: clean install", args = { "clean", "install" } },
			{ name = "Maven: verify", args = { "verify" } },
			{ name = "Maven: test", args = { "test" } },
			{ name = "Maven: spring-boot:run", args = { "spring-boot:run" } },
			{ name = "Maven: spring-boot:run (dev)", args = { "spring-boot:run", "-Dspring-boot.run.profiles=dev" } },
			{ name = "Maven: spring-boot:run (prod)", args = { "spring-boot:run", "-Dspring-boot.run.profiles=prod" } },
			{ name = "Maven: dependency:tree", args = { "dependency:tree" } },
			{ name = "Maven: install (skip tests)", args = { "install", "-DskipTests" } },
		}

		for _, tpl in ipairs(maven_templates) do
			local args = tpl.args
			local name = tpl.name
			overseer.register_template({
				name = name,
				condition = { callback = maven_condition },
				builder = function()
					return {
						name = name,
						cmd = mvn_cmd(),
						args = args,
						components = {
							{ "on_output_quickfix", open_on_exit = "failure" },
							"default",
						},
					}
				end,
			})
		end

		overseer.register_template({
			name = "Spring Boot: run (auto-detect)",
			condition = {
				callback = function(opts)
					return gradle_condition(opts) or maven_condition(opts)
				end,
			},
			builder = function()
				local tool = detect_build_tool()
				if tool == "gradle" then
					return { name = "bootRun", cmd = gradle_cmd(), args = { "bootRun" } }
				elseif tool == "maven" then
					return { name = "spring-boot:run", cmd = mvn_cmd(), args = { "spring-boot:run" } }
				else
					vim.notify("Overseer: could not detect Maven or Gradle project", vim.log.levels.ERROR)
					return { name = "noop", cmd = "true" }
				end
			end,
		})

		overseer.register_template({
			name = "Spring Boot: test (auto-detect)",
			condition = {
				callback = function(opts)
					return gradle_condition(opts) or maven_condition(opts)
				end,
			},
			builder = function()
				local tool = detect_build_tool()
				if tool == "gradle" then
					return { name = "test", cmd = gradle_cmd(), args = { "test" } }
				elseif tool == "maven" then
					return { name = "test", cmd = mvn_cmd(), args = { "test" } }
				else
					vim.notify("Overseer: could not detect Maven or Gradle project", vim.log.levels.ERROR)
					return { name = "noop", cmd = "true" }
				end
			end,
		})

		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>o", group = "Overseer / Build", icon = { icon = "󱁤", color = "orange" } },
			})
		end
	end,
}
