{ config, lib, ... }:

{
  programs.nixvim = {
    # ============================================================================
    # TREESITTER - Syntax highlighting and text objects
    # ============================================================================
    plugins.treesitter = {
      enable = lib.mkDefault true;
      nixvimInjections = true;

      folding = {
        enable = false;
      };

      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
          disable = [ ];
        };

        indent = {
          enable = true;
          disable = [ ];
        };

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<CR>";
            node_incremental = "<CR>";
            node_decremental = "<BS>";
            scope_incremental = "<TAB>";
          };
        };

        # Auto-install parsers (handled by NixVim)
        auto_install = false;

        # Ensure these parsers are installed
        ensure_installed = [
          "bash"
          "c"
          "cpp"
          "css"
          "dockerfile"
          "git_config"
          "git_rebase"
          "gitattributes"
          "gitcommit"
          "gitignore"
          "html"
          "java"
          "javascript"
          "json"
          "lua"
          "markdown"
          "markdown_inline"
          "nix"
          "python"
          "regex"
          "rust"
          "toml"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "yaml"
        ];
      };
    };

    # ============================================================================
    # RAINBOW-DELIMITERS - Colored brackets
    # ============================================================================
    plugins.rainbow-delimiters = {
      enable = lib.mkDefault true;
    };
  };
}
