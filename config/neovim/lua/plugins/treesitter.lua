-- ============================================================================
-- TREESITTER — Syntax highlighting and incremental selection
-- ============================================================================
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "VeryLazy",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "bash", "c", "cpp", "go", "lua", "python", "javascript", "typescript", "html", "css", "json", "yaml", "markdown", "vim", "vimdoc" },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      indent = { enable = true },
    })
  end,
}
