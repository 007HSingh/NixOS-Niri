-- ============================================================================
-- COLORSCHEMES — Kanagawa, Tokyo Night + Telescope picker
-- ============================================================================
return {
	-- ── Kanagawa ──────────────────────────────────────────────────────────────
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		priority = 900,
		opts = {
			compile = false,
			undercurl = true,
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false,
			dimInactive = false,
			terminalColors = true,
			colors = { theme = {}, palette = {} },
			overrides = function()
				return {}
			end,
			theme = "wave", -- wave | dragon | lotus
			background = {
				dark = "wave",
				light = "lotus",
			},
		},
	},

	-- ── Tokyo Night ───────────────────────────────────────────────────────────
	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 900,
		opts = {
			style = "night", -- night | storm | day | moon
			light_style = "day",
			transparent = false,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
				sidebars = "dark",
				floats = "dark",
			},
			sidebars = { "qf", "help", "terminal", "nvimtree" },
			day_brightness = 0.3,
			hide_inactive_statusline = false,
			dim_inactive = false,
			lualine_bold = true,
		},
	},

	-- ── Colorscheme Picker ────────────────────────────────────────────────────
	-- A Telescope-based picker that previews and persists the chosen scheme.
	-- The list includes all schemes available in your config.
	-- Keybind: <leader>tc  (replaces the old generic Telescope colorscheme)
	{
		"NTBBloodbath/doom-one.nvim", -- tiny dep-free plugin; only used for the picker wrapper
		enabled = false, -- disabled — we only want the picker logic below
	},
	{
		-- Use a small dedicated picker plugin
		"zaldih/themery.nvim",
		cmd = "Themery",
		keys = {
			{ "<leader>tc", "<cmd>Themery<cr>", desc = "Colorscheme picker (Themery)" },
		},
		opts = {
			-- Each entry: { name = "Label", colorscheme = "vim-name" }
			-- Variants are listed separately so you can preview them individually.
			themes = {
				-- ── Catppuccin ───────────────────────────────────────────────
				{ name = "Catppuccin Mocha (default)", colorscheme = "catppuccin-mocha" },
				{ name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
				{ name = "Catppuccin Frappe", colorscheme = "catppuccin-frappe" },
				{ name = "Catppuccin Latte", colorscheme = "catppuccin-latte" },

				-- ── Kanagawa ─────────────────────────────────────────────────
				{
					name = "Kanagawa Wave",
					colorscheme = "kanagawa-wave",
					before = [[require("kanagawa").setup({ theme = "wave" })]],
				},
				{
					name = "Kanagawa Dragon",
					colorscheme = "kanagawa-dragon",
					before = [[require("kanagawa").setup({ theme = "dragon" })]],
				},
				{
					name = "Kanagawa Lotus",
					colorscheme = "kanagawa-lotus",
					before = [[require("kanagawa").setup({ theme = "lotus" })]],
				},

				-- ── Tokyo Night ───────────────────────────────────────────────
				{
					name = "Tokyo Night",
					colorscheme = "tokyonight-night",
					before = [[require("tokyonight").setup({ style = "night" })]],
				},
				{
					name = "Tokyo Night Storm",
					colorscheme = "tokyonight-storm",
					before = [[require("tokyonight").setup({ style = "storm" })]],
				},
				{
					name = "Tokyo Night Moon",
					colorscheme = "tokyonight-moon",
					before = [[require("tokyonight").setup({ style = "moon" })]],
				},
				{
					name = "Tokyo Night Day",
					colorscheme = "tokyonight-day",
					before = [[require("tokyonight").setup({ style = "day" })]],
				},
			},
			-- Persist the last-chosen theme across sessions via stdpath("data")
			livePreview = true,
		},
	},
}
