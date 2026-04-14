-- ============================================================================
-- LUALINE — Bubbly style with catppuccin integration
-- ============================================================================
return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
	config = function()
		local utils = require("lualine.utils.utils")
		local modes = {
			"normal",
			"insert",
			"visual",
			"replace",
			"command",
			"inactive",
			"terminal",
		}
		local expand_mode = {
			["n"] = "normal",
			["no"] = "normal",
			["nov"] = "normal",
			["noV"] = "normal",
			["no\22"] = "normal",
			["niI"] = "insert",
			["niR"] = "replace",
			["niV"] = "replace",
			["v"] = "visual",
			["V"] = "visual",
			["\22"] = "visual",
			["s"] = "visual",
			["S"] = "visual",
			["\19"] = "visual",
			["i"] = "insert",
			["ic"] = "insert",
			["ix"] = "insert",
			["R"] = "replace",
			["Rc"] = "replace",
			["Rx"] = "replace",
			["Rv"] = "replace",
			["c"] = "command",
			["cv"] = "command",
			["ce"] = "command",
			["r"] = "command",
			["rm"] = "command",
			["r?"] = "command",
			["!"] = "command",
			["t"] = "terminal",
		}
		local function bufferinfo()
			local bufs = vim.fn.getbufinfo({ buflisted = 1 })
			local current_buf = vim.api.nvim_get_current_buf()
			for index, buf in ipairs(bufs) do
				if buf.bufnr == current_buf then
					return { index = index, count = #bufs }
				end
			end
		end

		-- Adjust theme ----------------------------------------------------------------

		local function custom_mocha_theme()
			local cp = require("catppuccin.palettes").get_palette("mocha")
			local transparent_bg = "NONE"

			return {
				normal = {
					a = { fg = cp.base, bg = cp.blue },
					b = { fg = cp.text, bg = cp.surface0 },
					c = { fg = cp.text, bg = transparent_bg },
				},
				insert = {
					a = { fg = cp.base, bg = cp.green },
					b = { fg = cp.text, bg = cp.surface0 },
					c = { fg = cp.text, bg = transparent_bg },
				},
				visual = {
					a = { fg = cp.base, bg = cp.mauve },
					b = { fg = cp.text, bg = cp.surface0 },
					c = { fg = cp.text, bg = transparent_bg },
				},
				replace = {
					a = { fg = cp.base, bg = cp.red },
					b = { fg = cp.text, bg = cp.surface0 },
					c = { fg = cp.text, bg = transparent_bg },
				},
				command = {
					a = { fg = cp.base, bg = cp.peach },
					b = { fg = cp.text, bg = cp.surface0 },
					c = { fg = cp.text, bg = transparent_bg },
				},
				inactive = {
					a = { fg = cp.text, bg = cp.surface0 },
					b = { fg = cp.text, bg = cp.surface0 },
					c = { fg = cp.text, bg = transparent_bg },
				},
			}
		end

		local function adjust_colors()
			-- Kill underlying Neovim statusline backgrounds
			for _, hlname in ipairs({ "StatusLine", "StatusLineNC" }) do
				vim.api.nvim_set_hl(0, hlname, { bg = "NONE", ctermbg = "NONE" })
			end

			-- Repopulate adjusted highlight groups
			for _, modename in ipairs(modes) do
				local base_lualine_a = "lualine_a_" .. modename
				local base_lualine_b = "lualine_b_" .. modename

				vim.api.nvim_set_hl(0, "lualine_b_" .. modename .. "_transparent", {
					fg = utils.extract_highlight_colors(base_lualine_b, "fg"),
					bg = "NONE",
				})

				vim.api.nvim_set_hl(0, "lualineItalicCrumb_" .. modename, {
					fg = utils.extract_highlight_colors(base_lualine_a, "fg"),
					bg = utils.extract_highlight_colors(base_lualine_a, "bg"),
					italic = true,
				})
			end
		end

		vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
			group = vim.api.nvim_create_augroup("LualineTransparentRefresh", { clear = true }),
			callback = function()
				require("lualine").setup({
					options = {
						theme = custom_mocha_theme(),
					},
				})
				adjust_colors()
			end,
		})

		-- Construct the lualine -------------------------------------------------------

		require("lualine").setup({
			options = {
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				always_divide_middle = false,
				ignore_focus = { "help" },
			},
			sections = {
				lualine_a = {
					{
						function()
							local count = math.floor(vim.api.nvim_win_get_width(0) / 8)
							return string.rep(" ", count)
						end,
						color = { fg = "NONE", bg = "NONE" },
					},
					{
						function()
							local count = bufferinfo().index - 1
							return string.rep("", count, " ")
						end,
						color = function()
							local modename = expand_mode[vim.fn.mode()] or "normal"
							return "lualine_b_" .. modename .. "_transparent"
						end,
					},
					{
						function()
							local max_len = math.floor(vim.api.nvim_win_get_width(0) / 3)

							local breadcrumb = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":~:t")
								.. "/"
								.. vim.fn.expand("%:t")

							local ok, navic = pcall(require, "nvim-navic")
							if ok and navic.is_available() then
								local crumb = navic.get_location({ highlight = false })
								if crumb ~= "" then
									-- Truncation Logic
									local total_str = breadcrumb .. " / " .. crumb
									if #total_str > max_len then
										if #crumb > (max_len / 2) then
											crumb = string.sub(crumb, 1, (max_len / 2) - 1) .. "…"
										end
									end

									local modename = expand_mode[vim.fn.mode()] or "normal"
									local hl_name = "%#lualineItalicCrumb_" .. modename .. "#"

									return breadcrumb .. "/" .. hl_name .. crumb
								end
							end
							return breadcrumb
						end,
						separator = { left = "", right = "" },
					},
					{
						function()
							local count = bufferinfo().count - bufferinfo().index
							return string.rep("", count, " ")
						end,
						color = function()
							local modename = expand_mode[vim.fn.mode()] or "normal"
							return "lualine_b_" .. modename .. "_transparent"
						end,
					},
					{ "%=", color = { bg = "NONE" } },
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
					{
						"location",
						fmt = function(str)
							local line, col = str:match("(%d+):(%d+)")
							return string.format(" %s.%s", line, col)
						end,
						separator = { left = " ", right = "  " },
						padding = 0,
						cond = function()
							local mode = vim.fn.mode()
							return not (mode == "v" or mode == "V" or mode == "\22")
								and (vim.v.hlsearch == 0 or vim.fn.getreg("/") == "")
						end,
					},
					{
						"searchcount",
						fmt = function(str)
							if str == "" then
								return ""
							end
							local count, of = str:match("(%d+)/(%d+)")
							return string.format(" %s/%s", count, of)
						end,
						separator = { left = "", right = "  " },
						padding = 0,
						cond = function()
							local mode = vim.fn.mode()
							return vim.v.hlsearch == 1
								and vim.fn.getreg("/") ~= ""
								and not (mode == "v" or mode == "V" or mode == "\22")
						end,
					},
					{
						"selectioncount",
						fmt = function(str)
							if str == "" then
								return ""
							end

							return string.format(" %s", str)
						end,
						padding = 0,
						separator = { left = " ", right = "  " },
					},
				},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {
					{
						function()
							local count = math.floor(vim.api.nvim_win_get_width(0) / 8)
							return string.rep(" ", count)
						end,
						color = { fg = "NONE", bg = "NONE" },
					},
					{
						function()
							local count = bufferinfo().index - 1
							return string.rep("", count, " ")
						end,
						color = function()
							local u = require("lualine.utils.utils")
							return {
								fg = u.extract_highlight_colors("TabLine", "bg"),
								bg = "NONE",
							}
						end,
					},
					{
						"filename",
						file_status = false,
						path = 4,
						symbols = { readonly = "" },
						separator = { left = "", right = "" },
						color = "TabLine",
					},
					{
						function()
							local count = bufferinfo().count - bufferinfo().index
							return string.rep("", count, " ")
						end,
						color = function()
							local u = require("lualine.utils.utils")
							return {
								fg = u.extract_highlight_colors("TabLine", "bg"),
								bg = "NONE",
							}
						end,
					},
					{
						"%=",
						color = { bg = "NONE" },
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {
					{
						"lsp_status",
						icon = "",
						color = "NonText",
						symbols = {
							done = "",
							separator = " ",
						},
						padding = { right = 1 },
					},
					{
						"filetype",
						colored = false,
						icon_only = false,
						icon = { align = "right" },
						separator = { left = "", right = "" },
						color = function()
							local modename = expand_mode[vim.fn.mode()] or "normal"
							return "lualine_b_" .. modename .. "_transparent"
						end,
						padding = 0,
					},
				},
				lualine_y = {},
				lualine_z = {},
			},

			inactive_winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					function()
						return " "
					end,
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
