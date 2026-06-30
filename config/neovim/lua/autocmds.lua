local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
	group = augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

autocmd("BufReadPost", {
	group = augroup("RestoreCursor", { clear = true }),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

autocmd("VimResized", {
	group = augroup("AutoResize", { clear = true }),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

autocmd("FileType", {
	group = augroup("QuickClose", { clear = true }),
	pattern = { "help", "man", "qf", "notify", "lspinfo", "startuptime", "tsplayground", "checkhealth" },
	callback = function(ev)
		vim.bo[ev.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
	end,
})

autocmd("FileType", {
	group = augroup("Markdown", { clear = true }),
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.conceallevel = 2
	end,
})

autocmd("FileType", {
	group = augroup("TwoSpaceIndent", { clear = true }),
	pattern = {
		"lua",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"html",
		"css",
		"scss",
		"json",
		"yaml",
		"nix",
		"ruby",
		"sh",
		"bash",
		"markdown",
	},
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
})

-- stop session saving in git buffers
autocmd("FileType", {
	pattern = { "gitcommit", "gitrebase" },
	callback = function()
		local ok, persistence = pcall(require, "persistence")
		if ok then
			persistence.stop()
		end
	end,
})

-- format on save via conform
autocmd("BufWritePre", {
	group = augroup("FormatOnSave", { clear = true }),
	callback = function(args)
		if vim.g.disable_format_on_save then
			return
		end
		if not vim.bo[args.buf].modifiable or vim.bo[args.buf].readonly then
			return
		end
		local ok, conform = pcall(require, "conform")
		if not ok then
			return
		end
		if #conform.list_formatters(args.buf) == 0 then
			return
		end
		conform.format({ bufnr = args.buf, timeout_ms = 2000, lsp_format = "fallback" })
	end,
})
