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

-- Set 2 spaces for languages where it is the norm
augroup("TwoSpaceIndent", { clear = true })
autocmd("FileType", {
	group = "TwoSpaceIndent",
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
		local formatter_names = table.concat(
			vim.tbl_map(function(f)
				return f.name
			end, formatters),
			", "
		)

		conform.format({
			bufnr = args.buf,
			timeout_ms = 500,
			lsp_fallback = true,
			callback = function(err, did_format)
				if err then
					vim.notify("Format failed (" .. formatter_names .. ")\n" .. tostring(err), vim.log.levels.WARN, {
						title = "conform.nvim",
						icon = " ",
					})
				elseif did_format then
					vim.notify(
						"Formatted with " .. formatter_names,
						vim.log.levels.INFO,
						{ title = "conform.nvim", icon = "󰸞 ", timeout = 1500 }
					)
				end
			end,
		})
	end,
})

-- ============================================================================
-- nvim-lint feedback — notify when linting fails to run
-- ============================================================================
augroup("LintFeedback", { clear = true })
autocmd("User", {
	group = "LintFeedback",
	pattern = "NvimLintRequestComplete",
	callback = function(args)
		local linters = args.data and args.data.linters or {}
		for _, linter in ipairs(linters) do
			if linter.exit_code and linter.exit_code > 1 then
				vim.notify(
					linter.name .. " exited with code " .. linter.exit_code,
					vim.log.levels.WARN,
					{ title = "nvim-lint", icon = " " }
				)
			end
		end
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
