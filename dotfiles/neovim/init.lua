require("options")
require("keymaps")
require("autocmds")

vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.fn.mkdir(vim.fn.stdpath("data") .. "/nvnotify1", "p") -- suppress nvchad welcome popup

-- make lua/chadrc.lua resolvable before lazy sets up rtp
package.path = vim.fn.stdpath("config") .. "/lua/?.lua;" .. package.path

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

local specs = vim.list_extend({ { import = "plugins" } }, require("chadrc").plugins)
require("lazy").setup(specs, {
	defaults = { lazy = true },
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false },
	performance = {
		rtp = {
			disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
		},
	},
	ui = { border = "single" },
})

require("chadrc").load()
