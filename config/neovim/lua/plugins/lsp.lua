-- ============================================================================
-- LSP — Language Server Protocol configuration (nvim-lspconfig, conform, etc.)
-- ============================================================================
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "jay-babu/mason-null-ls.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    "stevearc/conform.nvim",
    "folke/trouble.nvim",
    "tami5/lspsaga.nvim",
    "ray-x/lsp_signature.nvim",
    "folke/lsp-colors.nvim",
    "folke/neodev.nvim",
  },
  event = "BufReadPre",
  config = function()
    local lspconfig = require("lspconfig")
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local null_ls = require("null-ls")
    local conform = require("conform")

    mason.setup()
    mason_lspconfig.setup({
      ensure_installed = { "lua_ls", "pyright", "tsserver", "rust_analyzer", "gopls", "bashls", "html", "cssls", "jsonls", "yamlls" },
    })

    -- on_attach common mappings
    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local opts = { noremap = true, silent = true }
      -- LSP keymaps (mirroring original config)
      buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      buf_set_keymap('n', '<leader>cr', '<cmd>IncRename <C-r>=expand("<cword>")<CR><CR>', opts)
      buf_set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.format{ async = true }<CR>', opts)
    end

    -- Setup servers with default config + on_attach
    local servers = { "lua_ls", "pyright", "tsserver", "rust_analyzer", "gopls", "bashls", "html", "cssls", "jsonls", "yamlls" }
    for _, name in ipairs(servers) do
      lspconfig[name].setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
    end

    -- Null-ls for formatting / diagnostics (conform integration)
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.eslint,
      },
    })

    -- Conform (fallback formatter) – optional, mirrors original config
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
    })
  end,
}
