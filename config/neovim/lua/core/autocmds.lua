-- ============================================================================
-- AUTOCMDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================================
-- General
-- ============================================================================

-- Highlight yanked text briefly
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	group = "YankHighlight",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

-- Restore cursor position when re-opening a file
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
	group = "RestoreCursor",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Remove trailing whitespace on save
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
	group = "TrimWhitespace",
	pattern = "*",
	callback = function()
		local pos = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, pos)
	end,
})

-- Auto-resize splits when the terminal is resized
augroup("AutoResize", { clear = true })
autocmd("VimResized", {
	group = "AutoResize",
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Close certain filetypes with just 'q'
augroup("QuickClose", { clear = true })
autocmd("FileType", {
	group = "QuickClose",
	pattern = {
		"help",
		"man",
		"qf",
		"notify",
		"lspinfo",
		"startuptime",
		"tsplayground",
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- ============================================================================
-- File-type specific
-- ============================================================================

-- Set spell and wrap for markdown / text
augroup("Markdown", { clear = true })
autocmd("FileType", {
	group = "Markdown",
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- ============================================================================
-- LSP attach helpers
-- ============================================================================

-- Attach navic for breadcrumbs when LSP supports documentSymbol
augroup("NavicAttach", { clear = true })
autocmd("LspAttach", {
	group = "NavicAttach",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities.documentSymbolProvider then
			pcall(function()
				require("nvim-navic").attach(client, args.buf)
			end)
		end
	end,
})
