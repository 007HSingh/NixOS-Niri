-- NvChad UI config read by nvchad/ui, and base46 cache loader.
local M = {}

M.base46 = {
	theme = "catppuccin",
	integrations = {
		"notify",
		"trouble",
		"flash",
		"neogit",
		"gitsigns",
		"diffview",
		"dap",
		"neotest",
		"grug_far",
		"render-markdown",
		"rainbowdelimiters",
		"vim-illuminate",
		"todo",
		"snacks",
		"semantic_tokens",
	},
}

M.ui = {
	statusline = { theme = "default", separator_style = "default" },
	tabufline = { enabled = true, lazyload = true },
	cmp = { style = "default" },
	telescope = { style = "borderless" },
}

M.nvdash = { load_on_startup = false }
M.colorify = { enabled = false } -- handled by nvim-colorizer and blink.cmp
M.lsp = { signature = false }

local function mtime(path)
	local stat = vim.uv.fs_stat(path)
	return stat and stat.mtime.sec or 0
end

--- Sources the compiled base46 highlight cache; rebuilds if chadrc is newer.
function M.load()
	local cache = vim.g.base46_cache
	local this = vim.fn.stdpath("config") .. "/lua/chadrc.lua"

	if mtime(this) > mtime(cache .. "defaults") then
		if pcall(require, "base46") then
			require("base46").load_all_highlights()
			return
		end
	end

	if mtime(cache .. "defaults") == 0 then
		return
	end

	dofile(cache .. "defaults")
	for _, file in ipairs(vim.fn.readdir(cache)) do
		if file ~= "defaults" then
			dofile(cache .. file)
		end
	end
end

M.plugins = {
	"nvim-lua/plenary.nvim",

	--- Compiles theme highlights to a binary cache; regenerated after updates.
	{
		"nvchad/base46",
		lazy = true,
		build = function()
			require("base46").load_all_highlights()
		end,
	},

	--- Tabufline, statusline, and blink.cmp menu skin.
	{
		"nvchad/ui",
		lazy = false,
		dependencies = { "nvchad/base46", "nvzone/volt" },
		config = function()
			require("nvchad")
		end,
	},

	{ "nvzone/volt", lazy = true },

	--- File-type icons, overridden with NvChad's icon set.
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = function()
			return { override = require("nvchad.icons.devicons") }
		end,
	},

	--- Sidebar file explorer.
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
		opts = {
			filters = { dotfiles = false },
			disable_netrw = true,
			hijack_cursor = true,
			sync_root_with_cwd = true,
			update_focused_file = { enable = true, update_root = false },
			view = { width = 30, preserve_window_proportions = true },
			renderer = {
				root_folder_label = false,
				highlight_git = true,
				indent_markers = { enable = true },
				icons = {
					glyphs = {
						default = "",
						folder = { default = "", empty = "", empty_open = "", open = "", symlink = "" },
						git = { unmerged = "" },
					},
				},
			},
		},
	},
}

return M
