# Nixvim Configuration
# Neovim configuration via nixvim
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Import plugin configurations from config/neovim (preserved from original)
  imports = [
    ../../config/neovim/options.nix
    ../../config/neovim/keymaps.nix
    ../../config/neovim/plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # ============================================================================
    # COLORSCHEME
    # ============================================================================
    # Managed by Stylix automatically

    # ============================================================================
    # GLOBALS
    # ============================================================================
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # ============================================================================
    # EXTRA CONFIG - Additional settings for transparency
    # ============================================================================
    extraConfigLua = ''
      -- Additional transparency settings
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

      -- Make telescope transparent
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })

      -- Notify setup with nvim-notify
      vim.notify = require("notify")
    '';

    # ============================================================================
    # EXTRA PACKAGES
    # ============================================================================
    extraPackages = with pkgs; [
      nil
      lua-language-server
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
      dockerfile-language-server
      docker-compose-language-service
      pyright
      rust-analyzer
      bash-language-server
      jdt-language-server
      clang-tools
      marksman

      # Formatters
      nixfmt
      stylua
      prettier
      black
      rustfmt
      shfmt
      kdlfmt

      # Essential tools
      ripgrep
      fd
      tree-sitter
    ];

    # ============================================================================
    # PERFORMANCE
    # ============================================================================
    performance = {
      byteCompileLua = {
        enable = true;
        configs = true;
        initLua = true;
        nvimRuntime = true;
        plugins = true;
      };
    };
  };
}
