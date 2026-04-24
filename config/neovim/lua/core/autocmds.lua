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
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
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
		local ok, conform = pcall(require, "conform")
		if ok and #conform.list_formatters(0) > 0 then
			return
		end
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
		vim.opt_local.conceallevel = 2
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

-- ============================================================================
-- Glass (Transparency) Overrides
-- ============================================================================

local function apply_glass()
	local hl = vim.api.nvim_set_hl

	-- ── Core editor surfaces ─────────────────────────────────────────────
	hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "CursorLineNr", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "FoldColumn", { bg = "NONE", ctermbg = "NONE" })

	-- ── Floating windows — subtle tinted glass ───────────────────────────
	local ok, cp = pcall(require, "catppuccin.palettes")
	if ok then
		local palette = cp.get_palette("mocha")
		hl(0, "NormalFloat", { bg = palette.mantle, ctermbg = "NONE" })
		hl(0, "FloatBorder", { fg = palette.lavender, bg = palette.mantle })
		hl(0, "FloatTitle", { fg = palette.lavender, bg = palette.mantle, bold = true })
	else
		hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
		hl(0, "FloatBorder", { bg = "NONE", ctermbg = "NONE" })
	end

	-- ── Pmenu (completion menu) ──────────────────────────────────────────
	hl(0, "Pmenu", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "PmenuSbar", { bg = "NONE", ctermbg = "NONE" })

	-- ── Telescope ────────────────────────────────────────────────────────
	hl(0, "TelescopeNormal", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "TelescopePreviewNormal", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "TelescopeResultsNormal", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "TelescopePromptNormal", { bg = "NONE", ctermbg = "NONE" })

	-- ── StatusLine ───────────────────────────────────────────────────────
	hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
	hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })
end

autocmd({ "VimEnter", "ColorScheme" }, {
	group = augroup("GlassHighlights", { clear = true }),
	callback = apply_glass,
	desc = "Apply and re-apply glass (transparent) highlight overrides",
})

-- ============================================================================
-- Format on save (conform)
-- ============================================================================
augroup("FormatOnSave", { clear = true })
autocmd("BufWritePre", {
	group = "FormatOnSave",
	callback = function(args)
		-- Skip if buffer is not writable or is a special buffer
		if vim.g.disable_format_on_save then
			return
		end
		if not vim.bo[args.buf].modifiable or vim.bo[args.buf].readonly then
			return
		end
		-- Only format if conform actually has a formatter for this filetype
		local conform = require("conform")
		local formatters = conform.list_formatters(args.buf)
		if #formatters == 0 then
			return
		end
		conform.format({
			bufnr = args.buf,
			timeout_ms = 500,
			lsp_fallback = true,
		})
	end,
})

autocmd("FileType", {
	pattern = { "gitcommit", "gitrebase" },
	callback = function()
		require("persistence").stop()
	end,
})

augroup("AutoRoot", { clear = true })
autocmd("LspAttach", {
	group = "AutoRoot",
	callback = function()
		local root = vim.lsp.buf.list_workspace_folders()[1]
		if root then
			vim.fn.chdir(root)
		end
	end,
})
