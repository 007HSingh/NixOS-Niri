-- ============================================================================
-- LSP — Language Server Protocol configuration (Native Neovim 0.12+ API)
-- ============================================================================
return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"jay-babu/mason-null-ls.nvim",
			"nvimtools/none-ls.nvim",
			"nvimtools/none-ls-extras.nvim",
			"stevearc/conform.nvim",
			"folke/trouble.nvim",
			"ray-x/lsp_signature.nvim",
			"folke/lsp-colors.nvim",
		},
		event = "BufReadPre",
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_null_ls = require("mason-null-ls")
			local null_ls = require("null-ls")
			local conform = require("conform")

			mason.setup()
			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"rust_analyzer",
					"bashls",
					"jsonls",
					"yamlls",
					"jdtls",
					"nil_ls",
				},
			})
			mason_null_ls.setup({
				ensure_installed = { "stylua", "black", "prettier", "flake8", "eslint" },
			})

			-- Peek definition helper (Lspsaga replacement)
			local function peek_definition()
				local params = vim.lsp.util.make_position_params()
				vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
					if not result or vim.tbl_isempty(result) then
						return
					end
					vim.lsp.util.preview_location(result[1] or result, { border = "rounded" })
				end)
			end

			-- on_attach common mappings
			local on_attach = function(client, bufnr)
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
				end

				-- Standard LSP mappings
				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
				map("n", "gr", vim.lsp.buf.references, "Show references")
				map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
				map("n", "K", vim.lsp.buf.hover, "Hover documentation")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("n", "<leader>cl", vim.diagnostic.open_float, "Line diagnostics")
				map("n", "<leader>cf", function()
					require("conform").format({ bufnr = bufnr, async = true })
				end, "Format buffer (conform)")

				-- Lspsaga replacements
				map("n", "gh", vim.lsp.buf.references, "LSP References (Finder replacement)")
				map("n", "gp", peek_definition, "Peek definition")
				map("n", "<leader>co", "<cmd>Trouble symbols toggle focus=true<cr>", "Symbols outline (Trouble)")

				-- IncRename mapping (if available)
				map("n", "<leader>cr", function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end, "Rename (IncRename)")

				-- Signature help (ray-x/lsp_signature)
				if client:supports_method("textDocument/signatureHelp") then
					require("lsp_signature").on_attach({}, bufnr)
				end
			end

			-- Setup servers with new vim.lsp.config API (Neovim 0.11+)
			local servers = {
				"lua_ls",
				"pyright",
				"ts_ls",
				"rust_analyzer",
				"gopls",
				"bashls",
				"html",
				"cssls",
				"jsonls",
				"yamlls",
				"nil_ls",
			}
			for _, name in ipairs(servers) do
				vim.lsp.config(name, {
					on_attach = on_attach,
				})
			end
			vim.lsp.enable(servers)

			-- Null-ls for formatting / diagnostics
			null_ls.setup({
				sources = {
					require("none-ls.diagnostics.flake8"),
					require("none-ls.diagnostics.eslint"),
				},
			})

			-- Conform (fallback formatter)
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
				},
			})
		end,
	},
}
