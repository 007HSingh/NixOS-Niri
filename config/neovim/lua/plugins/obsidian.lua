-- ============================================================================
-- OBSIDIAN — Note-taking integration
-- ============================================================================
return {
	"epwalsh/obsidian.nvim",
	version = "*",
	ft = "markdown",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("obsidian").setup({
			workspaces = {
				{ name = "personal", path = "~/Notes" },
			},
			notes_subdir = "inbox",
			daily_notes = {
				folder = "dailies",
				date_format = "%Y-%m-%d",
			},
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},
			mappings = {}, -- keymaps are in core/keymaps.lua
			ui = {
				enable = true,
				checkboxes = {
					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
					["x"] = { char = "", hl_group = "ObsidianDone" },
					[">"] = { char = "", hl_group = "ObsidianRightArrow" },
					["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
				},
				bullets = { char = "•" },
			},
			attachments = { img_folder = "assets/imgs" },
		})
	end,
}
