-- ============================================================================
-- UI PLUGINS — bufferline, nvim-tree, noice, notify, dressing, navic,
--              indent-blankline, colorizer, scrollbar, web-devicons, dashboard
-- ============================================================================
return {
  -- ── Icons ─────────────────────────────────────────────────────────────────
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ── Bufferline ────────────────────────────────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "BufReadPost",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          theme = "catppuccin",
          separator_style = "slant",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = false,
          offsets = {
            { filetype = "NvimTree", text = "File Explorer", padding = 1 },
          },
        },
      })
    end,
  },

  -- ── NvimTree ──────────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30, side = "left" },
        renderer = {
          icons = { show = { file = true, folder = true, folder_arrow = true, git = true } },
        },
        filters = { dotfiles = false },
        git = { enable = true },
        diagnostics = { enable = true },
      })
    end,
  },

  -- ── Notify ────────────────────────────────────────────────────────────────
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "fade",
        timeout = 3000,
        render = "compact",
        -- NONE lets notify inherit the terminal's transparent background;
        -- avoids a solid dark rectangle breaking the glass aesthetic.
        background_colour = "NONE",
      })
      vim.notify = notify
    end,
  },

  -- ── Noice ─────────────────────────────────────────────────────────────────
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
        },
      })
    end,
  },

  -- ── Dressing (better select/input UI) ────────────────────────────────────
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input  = { enabled = true },
        select = { enabled = true, backend = { "telescope", "builtin" } },
      })
    end,
  },

  -- ── Navic (breadcrumbs) ───────────────────────────────────────────────────
  {
    "SmiteshP/nvim-navic",
    event = "LspAttach",
    config = function()
      require("nvim-navic").setup({
        lsp = { auto_attach = true },
        highlight = true,
        separator = "  ",
        depth_limit = 5,
      })
    end,
  },

  -- ── Indent blankline ──────────────────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope  = { enabled = true },
      })
    end,
  },

  -- ── Colorizer ─────────────────────────────────────────────────────────────
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB = true, RRGGBB = true, names = false, css = true,
      })
    end,
  },

  -- ── Scrollbar ─────────────────────────────────────────────────────────────
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      require("scrollbar").setup()
    end,
  },

  -- ── Dashboard / Alpha ─────────────────────────────────────────────────────
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha   = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file",   ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent",      ":Telescope oldfiles<CR>"),
        dashboard.button("g", "  Grep",        ":Telescope live_grep<CR>"),
        dashboard.button("s", "  Restore session", ":lua require('persistence').load()<CR>"),
        dashboard.button("q", "  Quit",        ":qa<CR>"),
      }
      alpha.setup(dashboard.config)
    end,
  },
}
