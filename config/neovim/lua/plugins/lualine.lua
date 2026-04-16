-- ============================================================================
-- LUALINE — Informative statusline with Catppuccin integration
-- ============================================================================
return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"catppuccin",
		"SmiteshP/nvim-navic",
	},
	config = function()
		local lualine = require("lualine")
		local navic = require("nvim-navic")

		-- ── Helpers ───────────────────────────────────────────────────────────

		local function mode_icon()
			local icons = {
				n = "󰋜 NORMAL",
				i = "󰏫 INSERT",
				v = "󰒉 VISUAL",
				V = "󰒉 V-LINE",
				["\22"] = "󰒉 V-BLOCK",
				c = "󰞷 COMMAND",
				s = "󰒅 SELECT",
				S = "󰒅 S-LINE",
				R = "󰊄 REPLACE",
				r = "󰊄 REPLACE",
				["!"] = " SHELL",
				t = " TERMINAL",
			}
			return icons[vim.fn.mode()] or "󰋜 NORMAL"
		end

		local function diff_source()
			local gitsigns = vim.b.gitsigns_status_dict
			if gitsigns then
				return {
					added = gitsigns.added,
					modified = gitsigns.changed,
					removed = gitsigns.removed,
				}
			end
		end

		local function lsp_clients()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return ""
			end
			local names = {}
			for _, c in ipairs(clients) do
				if c.name ~= "null-ls" and c.name ~= "copilot" then
					table.insert(names, c.name)
				end
			end
			if #names == 0 then
				return ""
			end
			return "󰒋 " .. table.concat(names, ", ")
		end

		local function macro_recording()
			local reg = vim.fn.reg_recording()
			if reg == "" then
				return ""
			end
			return "󰑋 @" .. reg
		end

		local function file_info()
			local enc = vim.opt.fileencoding:get()
			if enc == "" then
				enc = vim.opt.encoding:get()
			end
			local ff = vim.opt.fileformat:get()
			local ff_icons = { unix = "󰌽 LF", dos = " CRLF", mac = "󰀶 CR" }
			return (enc ~= "utf-8" and enc .. " · " or "") .. (ff_icons[ff] or ff)
		end

		local function indent_info()
			if vim.opt.expandtab:get() then
				return "Spaces: " .. vim.opt.shiftwidth:get()
			else
				return "Tab: " .. vim.opt.tabstop:get()
			end
		end

		local function search_count()
			if vim.v.hlsearch == 0 then
				return ""
			end
			local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 50 })
			if not ok or result.total == 0 then
				return ""
			end
			return ("󰍉 %d/%d"):format(result.current, result.total)
		end

		-- ── Catppuccin palette ────────────────────────────────────────────────
		local ok, cp = pcall(require, "catppuccin.palettes")
		local palette = ok and cp.get_palette("mocha")
			or {
				base = "#1e1e2e",
				mantle = "#181825",
				crust = "#11111b",
				text = "#cdd6f4",
				subtext0 = "#a6adc8",
				overlay0 = "#6c7086",
				surface0 = "#313244",
				surface1 = "#45475a",
				surface2 = "#585b70",
				blue = "#89b4fa",
				green = "#a6e3a1",
				red = "#f38ba8",
				yellow = "#f9e2af",
				peach = "#fab387",
				mauve = "#cba6f7",
				teal = "#94e2d5",
				sky = "#89dceb",
				lavender = "#b4befe",
				pink = "#f5c2e7",
				flamingo = "#f2cdcd",
				rosewater = "#f5e0dc",
			}

		local mode_colors = {
			n = palette.blue,
			i = palette.green,
			v = palette.mauve,
			V = palette.mauve,
			["\22"] = palette.mauve,
			c = palette.peach,
			s = palette.pink,
			S = palette.pink,
			R = palette.red,
			r = palette.red,
			["!"] = palette.red,
			t = palette.teal,
		}

		local function mode_color()
			return mode_colors[vim.fn.mode()] or palette.blue
		end

		-- ── Theme ─────────────────────────────────────────────────────────────
		local function build_theme()
			local mc = mode_color()
			return {
				normal = {
					a = { fg = palette.base, bg = mc, gui = "bold" },
					b = { fg = palette.text, bg = palette.surface1 },
					c = { fg = palette.subtext0, bg = palette.base },
				},
				insert = {
					a = { fg = palette.base, bg = palette.green, gui = "bold" },
					b = { fg = palette.text, bg = palette.surface1 },
					c = { fg = palette.subtext0, bg = palette.base },
				},
				visual = {
					a = { fg = palette.base, bg = palette.mauve, gui = "bold" },
					b = { fg = palette.text, bg = palette.surface1 },
					c = { fg = palette.subtext0, bg = palette.base },
				},
				replace = {
					a = { fg = palette.base, bg = palette.red, gui = "bold" },
					b = { fg = palette.text, bg = palette.surface1 },
					c = { fg = palette.subtext0, bg = palette.base },
				},
				command = {
					a = { fg = palette.base, bg = palette.peach, gui = "bold" },
					b = { fg = palette.text, bg = palette.surface1 },
					c = { fg = palette.subtext0, bg = palette.base },
				},
				terminal = {
					a = { fg = palette.base, bg = palette.teal, gui = "bold" },
					b = { fg = palette.text, bg = palette.surface1 },
					c = { fg = palette.subtext0, bg = palette.base },
				},
				inactive = {
					a = { fg = palette.overlay0, bg = palette.surface0 },
					b = { fg = palette.overlay0, bg = palette.surface0 },
					c = { fg = palette.overlay0, bg = palette.base },
				},
			}
		end

		-- ── Setup ─────────────────────────────────────────────────────────────
		lualine.setup({
			options = {
				theme = build_theme(),
				section_separators = { left = "", right = "" },
				component_separators = { left = "│", right = "│" },
				globalstatus = true,
				refresh = { statusline = 100 },
			},

			sections = {
				-- ── LEFT ──────────────────────────────────────────────────────
				lualine_a = {
					{
						mode_icon,
						separator = { left = "", right = "" },
						padding = { left = 1, right = 1 },
					},
				},

				lualine_b = {
					-- Git branch
					{
						"branch",
						icon = "",
						color = { fg = palette.mauve, bg = palette.surface1, gui = "bold" },
						padding = { left = 1, right = 0 },
					},
					-- Git diff
					{
						"diff",
						source = diff_source,
						symbols = { added = " ", modified = " ", removed = " " },
						diff_color = {
							added = { fg = palette.green },
							modified = { fg = palette.yellow },
							removed = { fg = palette.red },
						},
						padding = { left = 1, right = 1 },
					},
					-- Macro recording (shows when active)
					{
						macro_recording,
						color = { fg = palette.peach, gui = "bold,italic" },
						padding = { left = 1, right = 1 },
					},
				},

				lualine_c = {
					-- File icon + name + modified + readonly
					{
						"filetype",
						icon_only = true,
						padding = { left = 2, right = 0 },
						color = { bg = palette.base },
					},
					{
						"filename",
						path = 1, -- relative path
						symbols = {
							modified = " ●",
							readonly = " 󰌾",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
						color = { fg = palette.text, bg = palette.base, gui = "bold" },
						padding = { left = 0, right = 1 },
					},
					-- Navic breadcrumbs
					{
						function()
							if navic.is_available() then
								local loc = navic.get_location()
								if loc and loc ~= "" then
									return "  " .. loc
								end
							end
							return ""
						end,
						color = { fg = palette.overlay0, bg = palette.base },
						padding = { left = 0, right = 1 },
					},
				},

				-- ── RIGHT ─────────────────────────────────────────────────────
				lualine_x = {
					-- Search count
					{
						search_count,
						color = { fg = palette.yellow, gui = "bold" },
						padding = { left = 1, right = 1 },
					},
					-- Diagnostics
					{
						"diagnostics",
						sources = { "nvim_lsp", "nvim_diagnostic" },
						sections = { "error", "warn", "info", "hint" },
						symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
						diagnostics_color = {
							error = { fg = palette.red },
							warn = { fg = palette.yellow },
							info = { fg = palette.sky },
							hint = { fg = palette.teal },
						},
						padding = { left = 1, right = 1 },
					},
					-- Active LSP clients
					{
						lsp_clients,
						color = { fg = palette.green, gui = "italic" },
						padding = { left = 1, right = 1 },
					},
				},

				lualine_y = {
					-- Indent style
					{
						indent_info,
						color = { fg = palette.subtext0, bg = palette.surface1 },
						padding = { left = 1, right = 1 },
					},
					-- File encoding / line ending
					{
						file_info,
						color = { fg = palette.subtext0, bg = palette.surface1 },
						padding = { left = 1, right = 1 },
					},
					-- File size
					{
						"filesize",
						color = { fg = palette.subtext0, bg = palette.surface1 },
						padding = { left = 1, right = 1 },
					},
				},

				lualine_z = {
					-- Line:Col + progress
					{
						"location",
						separator = { left = "", right = "" },
						color = function()
							return { fg = palette.base, bg = mode_color(), gui = "bold" }
						end,
						padding = { left = 1, right = 0 },
					},
					{
						"progress",
						separator = { left = "", right = "" },
						color = function()
							return { fg = palette.base, bg = mode_color(), gui = "bold" }
						end,
						padding = { left = 0, right = 1 },
					},
					{
						function()
							return os.date("󰥔 %H:%M")
						end,
						color = function()
							return { fg = palette.base, bg = mode_color(), gui = "bold" }
						end,
						padding = { left = 1, right = 1 },
					},
				},
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						path = 1,
						color = { fg = palette.overlay0 },
					},
				},
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},

			-- ── Winbar: breadcrumbs on each split ─────────────────────────────
			winbar = {
				lualine_c = {
					{
						"filetype",
						icon_only = true,
						padding = { left = 2, right = 0 },
						color = { bg = "NONE" },
					},
					{
						"filename",
						path = 1,
						symbols = { modified = " ●", readonly = " 󰌾" },
						color = { fg = palette.text, bg = "NONE", gui = "bold" },
						padding = { left = 0, right = 1 },
					},
					{
						function()
							if navic.is_available() then
								local loc = navic.get_location()
								if loc and loc ~= "" then
									return "  " .. loc
								end
							end
							return ""
						end,
						color = { fg = palette.overlay0, bg = "NONE" },
					},
				},
				lualine_x = {
					{
						"lsp_status",
						icon = "",
						color = { fg = palette.overlay0, bg = "NONE" },
						symbols = { done = "", separator = " " },
						padding = { right = 2 },
					},
				},
			},

			inactive_winbar = {
				lualine_c = {
					{
						"filename",
						path = 1,
						color = { fg = palette.overlay0, bg = "NONE" },
						padding = { left = 2 },
					},
				},
			},
		})

		-- Re-apply on colorscheme change so mode colors stay in sync
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("LualineThemeRefresh", { clear = true }),
			callback = function()
				-- Small delay to let the new theme settle
				vim.defer_fn(function()
					lualine.setup({ options = { theme = build_theme() } })
				end, 10)
			end,
		})

		local timer = vim.uv.new_timer()
		timer:start(
			0,
			60000,
			vim.schedule_wrap(function()
				if package.loaded["lualine"] then
					require("lualine").refresh()
				end
			end)
		)
	end,
}
