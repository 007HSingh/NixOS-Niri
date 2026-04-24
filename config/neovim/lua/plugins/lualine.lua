-- ============================================================================
-- LUALINE — Informative statusline with Catppuccin integration
-- ============================================================================
return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"catppuccin",
	},
	config = function()
		local function mode_icon()
			local icons = {
				n = "󰋜",
				i = "󰏫",
				v = "󰒉",
				V = "󰒉",
				["\22"] = "󰒉",
				c = "󰞷",
				s = "󰒅",
				S = "󰒅",
				R = "󰊄",
				r = "󰊄",
				["!"] = "󰆍",
				t = "",
			}
			return icons[vim.fn.mode()] or "󰋜"
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
			return #clients > 0 and "󰒋" or ""
		end

		local function macro_recording()
			local reg = vim.fn.reg_recording()
			if reg == "" then
				return ""
			end
			return "󰑋 @" .. reg
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
		local lualine = require("lualine")

		-- ── Setup ─────────────────────────────────────────────────────────────
		lualine.setup({
			options = {
				theme = build_theme(),
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				globalstatus = true,
				refresh = { statusline = 100 },
			},

			sections = {
				lualine_a = {
					{
						mode_icon,
						padding = { left = 1, right = 1 },
					},
				},

				lualine_b = {
					{
						"branch",
						icon = "",
						color = { fg = palette.mauve, gui = "bold" },
					},
					{
						"diff",
						source = diff_source,
						symbols = { added = " ", modified = " ", removed = " " },
						padding = { left = 1, right = 1 },
					},
				},

				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = {
							modified = "●",
							readonly = "󰌾",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
						color = { fg = palette.text, gui = "bold" },
						padding = { left = 1, right = 1 },
					},
					{
						macro_recording,
						color = { fg = palette.peach, gui = "bold,italic" },
					},
				},

				lualine_x = {
					{
						search_count,
						color = { fg = palette.yellow, gui = "bold" },
					},
					{
						"diagnostics",
						symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
					},
					{
						lsp_clients,
						color = { fg = palette.green },
					},
				},

				lualine_y = {},

				lualine_z = {
					{
						"location",
						color = function()
							return { fg = palette.base, bg = mode_color(), gui = "bold" }
						end,
					},
				},
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
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
