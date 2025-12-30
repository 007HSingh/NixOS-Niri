local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" },
    python = { "black" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    java = { "google-java-format" }
  },

  format_on_save = {
  --   -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
