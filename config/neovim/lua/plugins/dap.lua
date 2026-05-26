-- ============================================================================
-- DAP — Debug Adapter Protocol
-- ============================================================================
return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
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
		local debugpy = vim.fn.exepath("python3")
		local debugpy_path = vim.fn.glob(
			vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/lib/python*/site-packages/debugpy")
				or "/nix/store/*/lib/python*/site-packages/debugpy",
			false,
			true
		)[1]
		if debugpy_path then
			require("dap-python").setup(debugpy)
		else
			require("dap-python").setup("python3")
		end

		-- C/C++/Rust adapter (codelldb)
		local codelldb =
			vim.fn.glob("/nix/store/*/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb", false, true)[1]

		if codelldb then
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = { command = codelldb, args = { "--port", "${port}" } },
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
		end

		-- JavaScript/TypeScript adapter (vscode-js-debug)
		local js_debug =
			vim.fn.glob("/nix/store/*/lib/node_modules/@vscode/js-debug/src/dapDebugServer.js", false, true)[1]

		if js_debug then
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
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
		end

		-- Java adapter (jdtls)
		-- jdtls handles its own DAP

		-- Telescope DAP extension
		require("telescope").load_extension("dap")

		-- Sign styling
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
		vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
		vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "DapStoppedLine" })
	end,
}
