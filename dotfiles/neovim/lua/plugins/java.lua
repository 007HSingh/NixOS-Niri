return {

	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",

			"rcasia/neotest-java",
		},

		keys = {
			{
				"<leader>jtr",
				function()
					require("neotest").run.run()
				end,
				desc = "Test: run nearest",
			},
			{
				"<leader>jtR",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Test: run file",
			},
			{
				"<leader>jts",
				function()
					require("neotest").run.stop()
				end,
				desc = "Test: stop",
			},
			{
				"<leader>jta",
				function()
					require("neotest").run.attach()
				end,
				desc = "Test: attach",
			},
			{
				"<leader>jto",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Test: output",
			},
			{
				"<leader>jtO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Test: output panel",
			},
			{
				"<leader>jtp",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Test: summary panel",
			},
			{
				"<leader>jtd",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Test: debug nearest (DAP)",
			},
			{
				"<leader>jtD",
				function()
					require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
				end,
				desc = "Test: debug file (DAP)",
			},

			{
				"[t",
				function()
					require("neotest").jump.prev({ status = "failed" })
				end,
				desc = "Test: prev failed",
			},
			{
				"]t",
				function()
					require("neotest").jump.next({ status = "failed" })
				end,
				desc = "Test: next failed",
			},
		},
		config = function()
			local java_test_jar = vim.env.JAVA_TEST_JAR

			require("neotest").setup({
				adapters = {
					require("neotest-java")({
						junit_jar = java_test_jar or nil,
					}),
				},

				status = {
					enabled = true,
					signs = true,
					virtual_text = true,
				},
				icons = {
					child_indent = "│",
					child_prefix = "├",
					collapsed = "─",
					expanded = "╮",
					failed = "✗",
					final_child_indent = " ",
					final_child_prefix = "╰",
					non_collapsible = "─",
					passed = "✓",
					running = "󰑮",
					running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
					skipped = "○",
					unknown = "?",
					watching = "󰈈",
				},

				output = { open_on_run = false },

				diagnostic = { enabled = true, severity = vim.diagnostic.severity.ERROR },

				quickfix = {
					enabled = true,
					open = false,
				},
				summary = {
					animated = true,
					follow = true,
					expand_errors = true,
					mappings = {
						attach = "a",
						clear_marked = "M",
						clear_target = "T",
						debug = "d",
						debug_marked = "D",
						expand = { "<CR>", "<2-LeftMouse>" },
						expand_all = "e",
						help = "?",
						jump = "o",
						mark = "m",
						output = "O",
						run = "r",
						run_marked = "R",
						short = "L",
						stop = "u",
						target = "t",
						watch = "w",
					},
				},
			})

			local ok, wk = pcall(require, "which-key")
			if ok then
				wk.add({
					{ "<leader>jt", group = "Test", icon = { icon = "󰙨", color = "green" }, ft = "java" },
				})
			end
		end,
	},

	{
		"mistweaverco/kulala.nvim",
		ft = { "http", "rest" },
		keys = {

			{
				"<leader>jHn",
				function()
					local file = vim.fn.getcwd() .. "/scratch.http"
					vim.cmd("edit " .. file)
				end,
				desc = "HTTP: open scratch file",
			},
		},
		opts = {

			split_direction = "horizontal",

			default_env = "dev",

			debug = false,

			icons = {
				inlay = {
					loading = "󰔟",
					done = "󰩐",
					error = "󰜺",
				},
				lualine = "󰖟",
			},

			formatters = {
				json = { "jq", "." },
				xml = { "xmllint", "--format", "-" },
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
					map("<leader>jHr", function()
						k.run()
					end, "HTTP: run request")
					map("<leader>jHR", function()
						k.run_all()
					end, "HTTP: run all")
					map("<leader>jHp", function()
						k.replay()
					end, "HTTP: replay last")
					map("<leader>jHi", function()
						k.inspect()
					end, "HTTP: inspect (curl)")
					map("<leader>jHc", function()
						k.copy()
					end, "HTTP: copy as curl")
					map("<leader>jHe", function()
						k.set_selected_env()
					end, "HTTP: select env")
					map("<leader>jHo", function()
						k.show_stats()
					end, "HTTP: response stats")
					map("<leader>jH[", function()
						k.jump_prev()
					end, "HTTP: prev request")
					map("<leader>jH]", function()
						k.jump_next()
					end, "HTTP: next request")

					local ok, wk = pcall(require, "which-key")
					if ok then
						wk.add({
							{ "<leader>jH", group = "HTTP Client", buffer = ev.buf },
						})
					end
				end,
			})
		end,
	},

	{
		"tpope/vim-dadbod",
		cmd = { "DB" },
		lazy = true,
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			"tpope/vim-dadbod",

			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>jD", "<cmd>DBUIToggle<cr>", desc = "Database: toggle UI" },
			{ "<leader>jDa", "<cmd>DBUIAddConnection<cr>", desc = "Database: add connection" },
			{ "<leader>jDf", "<cmd>DBUIFindBuffer<cr>", desc = "Database: find buffer" },
		},
		init = function()
			vim.g.db_ui_save_location = vim.fn.stdpath("state") .. "/db_ui"
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1

			if vim.env.DATABASE_URL and vim.env.DATABASE_URL ~= "" then
				-- vim.g.* returns a copy, not a live reference, so table.insert(vim.g.dbs, ...)
				-- below would silently insert into a throwaway copy and never persist.
				-- Build the table locally, then write it back to vim.g.dbs once at the end.
				local dbs = vim.deepcopy(vim.g.dbs or {})

				local has = false
				for _, db in ipairs(dbs) do
					if db.url == vim.env.DATABASE_URL then
						has = true
						break
					end
				end
				if not has then
					table.insert(dbs, {
						name = "default (DATABASE_URL)",
						url = vim.env.DATABASE_URL,
					})
				end

				vim.g.dbs = dbs
			end

			vim.g.db_ui_icons = {
				expanded = {
					db = "▾ ",
					buffers = "▾ ",
					saved_queries = "▾ ",
					schemas = "▾ ",
					schema = "▾ ",
					tables = "▾ ",
					table = "▾ ",
				},
				collapsed = {
					db = "▸ ",
					buffers = "▸ ",
					saved_queries = "▸ ",
					schemas = "▸ ",
					schema = "▸ ",
					tables = "▸ ",
					table = "▸ ",
				},
				saved_query = " ",
				new_query = "󰓤 ",
				tables = "󰓫 ",
				buffers = "󰓘 ",
				connection_ok = "✓",
				connection_error = "✕",
			}
		end,
		config = function()
			local ok, wk = pcall(require, "which-key")
			if ok then
				wk.add({
					{ "<leader>jD", group = "Database", icon = { icon = "󰆼", color = "blue" } },
				})
			end
		end,
	},
}
