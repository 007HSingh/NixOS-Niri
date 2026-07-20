vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.wrap = false
opt.splitbelow = true
opt.splitright = true
opt.showmode = false
opt.smoothscroll = true

opt.updatetime = 250
opt.timeoutlen = 300

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000

opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- folding managed by nvim-ufo
opt.foldenable = false
opt.foldlevel = 99
opt.foldlevelstart = 99

opt.conceallevel = 0
opt.fileencoding = "utf-8"
opt.iskeyword:append("-")
opt.cmdheight = 1
opt.ruler = false
opt.pumheight = 10
opt.fillchars = { eob = " " } -- hide end-of-buffer ~

-- global float border (Neovim 0.11+)
vim.o.winborder = "rounded"

-- gui
vim.o.guifont = "JetBrainsMono NF:h13"
