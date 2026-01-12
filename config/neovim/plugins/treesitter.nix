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
    # TREESITTER-TEXTOBJECTS - Enhanced text objects
    # ============================================================================
    plugins.treesitter-textobjects = {
      enable = lib.mkDefault true;
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = "@class.inner";
          "aa" = "@parameter.outer";
          "ia" = "@parameter.inner";
        };
      };
      move = {
        enable = true;
        setJumps = true;
        gotoNextStart = {
          "]f" = "@function.outer";
          "]c" = "@class.outer";
        };
        gotoNextEnd = {
          "]F" = "@function.outer";
          "]C" = "@class.outer";
        };
        gotoPreviousStart = {
          "[f" = "@function.outer";
          "[c" = "@class.outer";
        };
        gotoPreviousEnd = {
          "[F" = "@function.outer";
          "[C" = "@class.outer";
        };
      };
      swap = {
        enable = true;
        swapNext = {
          "<leader>a" = "@parameter.inner";
        };
        swapPrevious = {
          "<leader>A" = "@parameter.inner";
        };
      };
    };

    # ============================================================================
    # TREESITTER-CONTEXT - Show code context
    # ============================================================================
    plugins.treesitter-context = {
      enable = lib.mkDefault true;
      settings = {
        enable = true;
        max_lines = 3;
        min_window_height = 0;
        line_numbers = true;
        multiline_threshold = 20;
        trim_scope = "outer";
        mode = "cursor";
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
