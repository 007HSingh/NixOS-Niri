-- TELESCOPE — Fuzzy finder with extensions
return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
	},
	cmd = "Telescope",
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				prompt_prefix = "   ",
				selection_caret = " ",
				entry_prefix = " ",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = { prompt_position = "top", preview_width = 0.55 },
					vertical = { prompt_position = "top" },
					width = 0.87,
					height = 0.80,
				},
				mappings = {
					n = { ["q"] = require("telescope.actions").close },
				},
				sorting_strategy = "ascending",
				border = true,
				preview = { timeout = 200 },
			},
			pickers = {
				find_files = { theme = "dropdown", previewer = false },
				live_grep = { theme = "dropdown" },
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				file_browser = { hijack_netrw = true },
				ui_select = { require("telescope.themes").get_dropdown({}) },
			},
		})
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
		telescope.load_extension("file_browser")
	end,
}
