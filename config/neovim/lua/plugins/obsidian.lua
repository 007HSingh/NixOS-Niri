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
			notes_subdir = "fleeting",
			new_notes_location = "notes_subdir",
			daily_notes = {
				folder = "dailies",
				date_format = "%Y-%m-%d",
				template = "daily.md",
			},
			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
			-- Zettelkasten ID generation: YYYYMMDDHHMM-title
			note_id_func = function(title)
				local suffix = ""
				if title ~= nil then
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.date("%Y%m%d%H%M")) .. "-" .. suffix
			end,
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},
			-- Specify how to handle attachments
			attachments = {
				folder = "assets/imgs",
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
			-- Disable UI features as we use render-markdown.nvim
			ui = { enable = false },
			-- Disable legacy commands to remove warnings
			legacy_commands = false,
		})
	end,
}
