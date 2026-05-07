-- ============================================================================
-- INIT.LUA — Vanilla Neovim entry point
-- ============================================================================

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
