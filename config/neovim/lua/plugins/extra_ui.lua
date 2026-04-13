-- ============================================================================
-- EXTRA UI — rainbow-delimiters, illuminate, vim-illuminate, lspsaga, markdown-preview
-- ============================================================================
return {
  -- ── Rainbow delimiters ────────────────────────────────────────────────────
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow = require("rainbow-delimiters")
      require("rainbow-delimiters.setup").setup({
        strategy = { [""] = rainbow.strategy["global"] },
        query    = { [""] = "rainbow-delimiters" },
      })
    end,
  },

  -- ── Illuminate (highlight word under cursor) ──────────────────────────────
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 200,
        under_cursor = true,
      })
    end,
  },

  -- ── Lspsaga ───────────────────────────────────────────────────────────────
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lspsaga").setup({
        ui = { border = "rounded", code_action = "💡" },
        symbol_in_winbar = { enable = true },
        lightbulb = { enable = true, virtual_text = false },
        finder = { keys = { toggle_or_open = "o", quit = "q" } },
        code_action = { keys = { quit = "q", exec = "<CR>" } },
        rename    = { keys = { quit = "<C-c>", exec = "<CR>" } },
        diagnostic = { show_code_action = true },
      })
    end,
  },

  -- ── Markdown Preview ──────────────────────────────────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_theme      = "dark"
    end,
  },

  -- ── Trouble ───────────────────────────────────────────────────────────────
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({ use_diagnostic_signs = true })
    end,
  },
}
