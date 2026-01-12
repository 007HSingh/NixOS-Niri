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
    ./plugins
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
        transparent_background = false;
        term_colors = true;
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          telescope.enabled = true;
          lsp_trouble = true;
          which_key = true;
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
    # EXTRA PACKAGES
    # ============================================================================
    extraPackages = with pkgs; [
      nil
      lua-language-server
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
      dockerfile-language-server-nodejs
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
