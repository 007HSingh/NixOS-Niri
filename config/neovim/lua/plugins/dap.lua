-- ============================================================================
-- DAP — Debug Adapter Protocol
-- ============================================================================
return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	ft = { "java" },
	keys = {
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle breakpoint",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Continue / Start",
		},
		{
			"<leader>dO",
			function()
				require("dap").step_over()
			end,
			desc = "Step over",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Step into",
		},
		{
			"<leader>do",
			function()
				require("dap").step_out()
			end,
			desc = "Step out",
		},
		{
			"<leader>dq",
			function()
				require("dap").terminate()
				require("dapui").close()
			end,
			desc = "Terminate",
		},
	},
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"mfussenegger/nvim-dap-python",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-telescope/telescope-dap.nvim",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- DAP UI
		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 40,
					position = "left",
				},
				{
					elements = { "repl", "console" },
					size = 0.25,
					position = "bottom",
				},
			},
		})

		-- Virtual text
		require("nvim-dap-virtual-text").setup({})

		-- Auto-open/close DAP UI with session
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Python adapter
		local debugpy = vim.env.DEBUGPY_PATH
		if debugpy and debugpy ~= "" then
			require("dap-python").setup(debugpy)
		else
			vim.notify("DAP: DEBUGPY_PATH not set — Python debugging unavailable", vim.log.levels.WARN)
		end

		-- C/C++/Rust adapter (codelldb)
		local codelldb = vim.env.CODELLDB_PATH
		if codelldb and codelldb ~= "" then
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb,
					args = { "--port", "${port}" },
				},
			}
			for _, ft in ipairs({ "rust", "c", "cpp" }) do
				dap.configurations[ft] = {
					{
						name = "Launch file",
						type = "codelldb",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
					},
				}
			end
		else
			vim.notify("DAP: CODELLDB_PATH not set — C/C++/Rust debugging unavailable", vim.log.levels.WARN)
		end

		-- JavaScript/TypeScript adapter (vscode-js-debug)
		local js_debug = vim.env.VSCODE_JS_DEBUG_PATH
		if js_debug and js_debug ~= "" then
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = vim.fn.exepath("node"),
					args = { js_debug, "${port}" },
				},
			}
			for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
				dap.configurations[ft] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to process",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end
		else
			vim.notify("DAP: VSCODE_JS_DEBUG_PATH not set — JS/TS debugging unavailable", vim.log.levels.WARN)
		end

		-- Telescope DAP extension
		require("telescope").load_extension("dap")

		-- Sign styling
		vim.fn.sign_define("DapBreakpoint", { text = "󰝥", texthl = "DiagnosticError" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "󰯈", texthl = "DiagnosticWarn" })
		vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
		vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "DapStoppedLine" })
	end,
}
