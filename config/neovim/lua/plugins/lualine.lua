return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"catppuccin/nvim",
		"SmiteshP/nvim-navic",  -- LSP symbol context for winbar
	},
	config = function()
		local p = require("catppuccin.palettes").get_palette("mocha")

		-- navic: configure to match catppuccin palette
		require("nvim-navic").setup({
			highlight = true,
			separator = "  ",
			depth_limit = 6,
			depth_limit_indicator = "…",
			safe_output = true,
		})

		local bg = p.mantle  -- flat statusline background

		local theme = {
			normal   = { a = { fg = p.mauve,    bg = bg, gui = "bold" }, b = { fg = p.subtext1, bg = bg }, c = { fg = p.subtext1, bg = bg } },
			insert   = { a = { fg = p.green,    bg = bg, gui = "bold" }, b = { fg = p.subtext1, bg = bg }, c = { fg = p.subtext1, bg = bg } },
			visual   = { a = { fg = p.lavender, bg = bg, gui = "bold" }, b = { fg = p.subtext1, bg = bg }, c = { fg = p.subtext1, bg = bg } },
			replace  = { a = { fg = p.red,      bg = bg, gui = "bold" }, b = { fg = p.subtext1, bg = bg }, c = { fg = p.subtext1, bg = bg } },
			command  = { a = { fg = p.peach,    bg = bg, gui = "bold" }, b = { fg = p.subtext1, bg = bg }, c = { fg = p.subtext1, bg = bg } },
			terminal = { a = { fg = p.teal,     bg = bg, gui = "bold" }, b = { fg = p.subtext1, bg = bg }, c = { fg = p.subtext1, bg = bg } },
			inactive = { a = { fg = p.overlay0, bg = bg }, b = { fg = p.overlay0, bg = bg }, c = { fg = p.overlay0, bg = bg } },
		}

		local function diff_source()
			local g = vim.b.gitsigns_status_dict
			if g then return { added = g.added, modified = g.changed, removed = g.removed } end
		end

		local function macro_recording()
			local reg = vim.fn.reg_recording()
			return reg ~= "" and ("󰑋 @" .. reg) or ""
		end

		local function search_count()
			if vim.v.hlsearch == 0 then return "" end
			local ok, r = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 50 })
			if not ok or r.total == 0 then return "" end
			return ("󰍉 %d/%d"):format(r.current, r.total)
		end

		local function lsp_clients()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then return "" end
			return "󰒋 " .. table.concat(vim.tbl_map(function(c) return c.name end, clients), ", ")
		end

		-- Winbar: file path breadcrumb + LSP symbol context
		local function winbar_breadcrumb()
			local path = vim.fn.expand("%:p")
			if path == "" then return "" end
			-- skip special buffers (terminal, nvim-tree, etc.)
			local bt = vim.bo.buftype
			if bt ~= "" and bt ~= "acwrite" then return "" end
			local cwd = vim.uv.cwd() or vim.fn.getcwd()
			local rel = path:gsub("^" .. vim.pesc(cwd) .. "/", "")
			local parts = vim.split(rel, "/", { plain = true, trimempty = true })
			if #parts == 0 then return "" end
			local icon, icon_hl = "", "Normal"
			local ok, devicons = pcall(require, "nvim-web-devicons")
			if ok then
				local i, h = devicons.get_icon(parts[#parts], vim.fn.expand("%:e"), { default = true })
				icon = (i or "") .. " "
				icon_hl = h or icon_hl
			end
			-- dim parent dirs, highlight filename
			local dirs = {}
			for i = 1, #parts - 1 do
				dirs[#dirs + 1] = "%#Comment#" .. parts[i] .. "%#Normal#"
			end
			local file = "%#" .. icon_hl .. "#" .. icon .. parts[#parts] .. "%#Normal#"
			local modified = vim.bo.modified and " %#DiagnosticWarn#●%#Normal#" or ""
			local sep = "%#Comment# > %#Normal#"
			local result = table.concat(dirs, sep)
			if #dirs > 0 then result = result .. sep end
			result = result .. file .. modified
			-- append navic context if available
			if package.loaded["nvim-navic"] then
				local navic = require("nvim-navic")
				if navic.is_available() then
					local loc = navic.get_location()
					if loc and loc ~= "" then
						result = result .. "  " .. loc
					end
				end
			end
			return result
		end

		require("lualine").setup({
			options = {
				theme = theme,
				section_separators = "",
				component_separators = "",
				globalstatus = true,
				refresh = { statusline = 100, winbar = 100 },
			},
			sections = {
				lualine_a = { { "mode" } },
				lualine_b = {
					{ "branch", icon = "" },
					{ "diff", source = diff_source, symbols = { added = " ", modified = " ", removed = " " } },
				},
				lualine_c = {
					{ macro_recording, color = { fg = p.peach,  gui = "bold" } },
					{ search_count,    color = { fg = p.yellow } },
				},
				lualine_x = {
					{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " } },
					{ lsp_clients, color = { fg = p.subtext0 } },
				},
				lualine_y = { { "filetype" } },
				lualine_z = { { "location" } },
			},
			inactive_sections = {
				lualine_c = {},
				lualine_x = { "location" },
			},
			winbar = {
				lualine_c = { { winbar_breadcrumb } },
			},
			inactive_winbar = {
				lualine_c = { { winbar_breadcrumb, color = { fg = p.overlay0 } } },
			},
			extensions = { "neo-tree", "trouble", "quickfix", "lazy" },
		})

		local timer = vim.uv.new_timer()
		timer:start(0, 60000, vim.schedule_wrap(function()
			if package.loaded["lualine"] then require("lualine").refresh() end
		end))
	end,
}
