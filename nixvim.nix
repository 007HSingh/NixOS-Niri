{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Import all module configurations
  imports = [
    ./config/neovim/options.nix
    ./config/neovim/keymaps.nix
    ./config/neovim/plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # ============================================================================
    # COLORSCHEME - Catppuccin Mocha
    # ============================================================================
    colorschemes.catppuccin = {
      enable = lib.mkDefault true;
      settings = {
        flavour = "mocha";
        transparent_background = true;
        term_colors = true;
        dim_inactive = {
          enabled = true;
          shade = "dark";
          percentage = 0.15;
        };
        styles = {
          comments = [ "italic" ];
          conditionals = [ "italic" ];
          loops = [ ];
          functions = [ ];
          keywords = [ ];
          strings = [ ];
          variables = [ ];
          numbers = [ ];
          booleans = [ ];
          properties = [ ];
          types = [ ];
          operators = [ ];
        };
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          telescope.enabled = true;
          lsp_trouble = true;
          which_key = true;
          noice = true;
          notify = true;
          navic = {
            enabled = true;
            custom_bg = "NONE";
          };
          indent_blankline = {
            enabled = true;
            colored_indent_levels = false;
          };
          native_lsp = {
            enabled = true;
            virtual_text = {
              errors = [ "italic" ];
              hints = [ "italic" ];
              warnings = [ "italic" ];
              information = [ "italic" ];
            };
            underlines = {
              errors = [ "underline" ];
              hints = [ "underline" ];
              warnings = [ "underline" ];
              information = [ "underline" ];
            };
          };
        };
      };
    };

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
