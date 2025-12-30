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

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client, bufnr)
      -- Your on_attach function here
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  }
end

-- read :h vim.lsp.config for changing options of lsp servers 
