-- ============================================================================
-- OPTIONS — Translated from options.nix
-- ============================================================================

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI/UX
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

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.lazyredraw = false

-- Backup and undo
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

-- Mouse support
opt.mouse = "a"

-- Clipboard
opt.clipboard = "unnamedplus"

-- Folding — managed by UFO
opt.foldenable = false
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Misc
opt.conceallevel = 0
opt.fileencoding = "utf-8"
opt.iskeyword:append("-")
opt.showtabline = 2
opt.cmdheight = 1
opt.ruler = false
