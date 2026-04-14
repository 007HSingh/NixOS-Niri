-- ============================================================================
-- INIT.LUA — Vanilla Neovim entry point
-- ============================================================================

-- Polyfill for intrusive LSP position_encoding warnings (Neovim 0.11+)
-- This "solves" the issue by providing the required parameter if a plugin forgets it.
local original_make_range_params = vim.lsp.util.make_range_params
vim.lsp.util.make_range_params = function(winid, encoding)
	if not encoding then
		local bufnr = vim.api.nvim_win_get_buf(winid or 0)
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
			if client.offset_encoding then
				encoding = client.offset_encoding
				break
			end
		end
	end
	return original_make_range_params(winid, encoding)
end

-- Refined Polyfill for vim.validate deprecation (Neovim 1.0+)
-- Intercepts the old { name = { value, type, optional } } syntax and converts it to the new positional syntax.
local original_validate = vim.validate
---@diagnostic disable-next-line: duplicate-set-field
vim.validate = function(opt, ...)
	-- Only intercept if it's a single table argument and smells like the old syntax
	if type(opt) == "table" and select("#", ...) == 0 and next(opt) ~= nil then
		local is_old_syntax = true
		for _, v in pairs(opt) do
			if type(v) ~= "table" or type(v[2]) ~= "string" then
				is_old_syntax = false
				break
			end
		end

		if is_old_syntax then
			for k, v in pairs(opt) do
				original_validate(k, v[1], v[2], v[3])
			end
			return
		end
	end
	return original_validate(opt, ...)
end

-- Polyfill for vim.lsp.buf_get_clients (removed in Neovim 0.12)
-- Used by project.nvim and other legacy plugins.
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf_get_clients = function(bufnr)
	return vim.lsp.get_clients({ bufnr = bufnr or 0 })
end

-- Leader keys must be set BEFORE lazy.nvim is loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- GUI font (Maple Mono Nerd Font)
vim.o.guifont = "MapleMono NF:h13"

-- ============================================================================
-- BOOTSTRAP lazy.nvim
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- CORE MODULES (options, keymaps, autocmds — no plugins needed)
-- ============================================================================
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- ============================================================================
-- PLUGINS via lazy.nvim
-- ============================================================================
require("lazy").setup("plugins", {
	defaults = { lazy = true },
	install = { colorscheme = { "catppuccin-mocha", "habamax" } },
	checker = { enabled = false },
	performance = {
		rtp = {
			-- Disable unused built-in plugins for faster startup
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = { border = "rounded" },
})
