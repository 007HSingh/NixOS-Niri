-- ============================================================================
-- OBSIDIAN — Note-taking integration
-- ============================================================================
return {
	"obsidian-nvim/obsidian.nvim",
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
					[" "] = { order = 1, char = "󰄱", hl_group = "ObsidianTodo" },
					["x"] = { order = 2, char = "", hl_group = "ObsidianDone" },
					[">"] = { order = 3, char = "", hl_group = "ObsidianRightArrow" },
					["~"] = { order = 4, char = "󰰱", hl_group = "ObsidianTilde" },
				},
				bullets = { char = "•", hl_group = "ObsidianBullet" },
			},
			attachments = {
				img_folder = "assets/imgs",
				img_text_func = function(client, path)
					local link_path
					local vault_relative = client:vault_relative_path(path)
					if vault_relative ~= nil then
						link_path = tostring(vault_relative)
					else
						link_path = tostring(path)
					end
					local display_name = vim.fs.basename(tostring(path))
					return string.format("![%s](%s)", display_name, link_path)
				end,
				confirm_img_paste = true,
			},
		})
	end,
}
