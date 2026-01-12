{ config, lib, ... }:

{
  programs.nixvim = {
    # ============================================================================
    # AUTO-PAIRS - Bracket/quote pairing
    # ============================================================================
    plugins.nvim-autopairs = {
      enable = lib.mkDefault true;
      settings = {
        check_ts = true;
        ts_config = {
          lua = [
            "string"
            "source"
          ];
          javascript = [
            "string"
            "template_string"
          ];
        };
        disable_filetype = [
          "TelescopePrompt"
          "vim"
        ];
        fast_wrap = {
          map = "<M-e>";
          chars = [
            "{"
            "["
            "("
            "\""
            "'"
          ];
          pattern = "([%'%\"%>%]%)%}%,])[^%)%]%}%,]*";
          offset = 0;
          end_key = "$";
          keys = "qwertyuiopzxcvbnmasdfghjkl";
          check_comma = true;
          highlight = "PmenuSel";
          highlight_grey = "LineNr";
        };
      };
    };

    # ============================================================================
    # COMMENT - Comment toggle
    # ============================================================================
    plugins.comment = {
      enable = lib.mkDefault true;
      settings = {
        toggler = {
          line = "gcc";
          block = "gbc";
        };
        opleader = {
          line = "gc";
          block = "gb";
        };
        extra = {
          above = "gcO";
          below = "gco";
          eol = "gcA";
        };
      };
    };

    # ============================================================================
    # SURROUND - Surround text objects
    # ============================================================================
    plugins.nvim-surround = {
      enable = lib.mkDefault true;
    };

    # ============================================================================
    # TODO-COMMENTS - Highlight TODO comments
    # ============================================================================
    plugins.todo-comments = {
      enable = lib.mkDefault true;
      settings = {
        signs = true;
        keywords = {
          FIX = {
            icon = " ";
            color = "error";
            alt = [
              "FIXME"
              "BUG"
              "FIXIT"
              "ISSUE"
            ];
          };
          TODO = {
            icon = " ";
            color = "info";
          };
          HACK = {
            icon = " ";
            color = "warning";
          };
          WARN = {
            icon = " ";
            color = "warning";
            alt = [
              "WARNING"
              "XXX"
            ];
          };
          PERF = {
            icon = " ";
            alt = [
              "OPTIM"
              "PERFORMANCE"
              "OPTIMIZE"
            ];
          };
          NOTE = {
            icon = " ";
            color = "hint";
            alt = [ "INFO" ];
          };
        };
      };
    };

    # ============================================================================
    # WHICH-KEY - Keybinding hints
    # ============================================================================
    plugins.which-key = {
      enable = lib.mkDefault true;
      settings = {
        delay = 300;
        icons = {
          breadcrumb = "»";
          separator = "➜";
          group = "+";
        };
        spec = [
          {
            __unkeyed-1 = "<leader>f";
            group = "Find";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "Git";
          }
          {
            __unkeyed-1 = "<leader>h";
            group = "Git Hunk";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
          }
          {
            __unkeyed-1 = "<leader>b";
            group = "Buffer";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "Split";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "Terminal/Toggle";
          }
          {
            __unkeyed-1 = "<leader>x";
            group = "Diagnostics";
          }
        ];
      };
    };

    # ============================================================================
    # FLASH - Quick navigation with labels
    # ============================================================================
    plugins.flash = {
      enable = lib.mkDefault true;
      settings = {
        labels = "asdfghjklqwertyuiopzxcvbnm";
        modes = {
          search = {
            enabled = true;
          };
          char = {
            enabled = false;
          };
        };
      };
    };

    # ============================================================================
    # MINI.AI - Better text objects
    # ============================================================================
    plugins.mini = {
      enable = lib.mkDefault true;
      modules = {
        ai = {
          n_lines = 500;
        };
        move = { };
      };
    };

    # ============================================================================
    # ILLUMINATE - Highlight word under cursor
    # ============================================================================
    plugins.illuminate = {
      enable = lib.mkDefault true;
      filetypesDenylist = [
        "alpha"
        "dashboard"
        "NvimTree"
        "Trouble"
        "toggleterm"
      ];
    };

    # ============================================================================
    # TOGGLETERM - Terminal integration
    # ============================================================================
    plugins.toggleterm = {
      enable = lib.mkDefault true;
      settings = {
        direction = "float";
        float_opts = {
          border = "curved";
          width = 130;
          height = 30;
        };
        open_mapping = "[[<C-\\>]]";
        shade_terminals = true;
        start_in_insert = true;
      };
    };
  };
}
