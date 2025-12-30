require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers = { 
  "nil_ls",
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "bashls",
  "clangd",
  "jdtls"
}

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
