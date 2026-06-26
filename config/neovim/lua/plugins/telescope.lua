-- ============================================================================
-- TELESCOPE — Fuzzy finder with extensions
-- ============================================================================
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
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
		{ "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
		{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
		{ "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
		{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		{ "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
		{ "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
		{ "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Vim options" },
		{ "<leader>ft", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
		{ "<leader>fy", "<cmd>YankyRingHistory<cr>", desc = "Yank history" },
		{ "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
		{ "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search buffer" },
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
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
