_:

{
  programs.nixvim = {
    plugins = {
      # ============================================================================
      # AUTO-PAIRS - Bracket/quote pairing
      # ============================================================================
      nvim-autopairs = {
        enable = true;
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
          # Removed fast_wrap to avoid Lua parsing issues
        };
      };

      # ============================================================================
      # COMMENT - Comment toggle
      # ============================================================================
      comment = {
        enable = true;
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
      nvim-surround = {
        enable = true;
      };

      # ============================================================================
      # TODO-COMMENTS - Highlight TODO comments
      # ============================================================================
      todo-comments = {
        enable = true;
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
      which-key = {
        enable = true;
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
            {
              __unkeyed-1 = "<leader>o";
              group = "Obsidian";
            }
            {
              __unkeyed-1 = "<leader>d";
              group = "Debugger";
            }
          ];
        };
      };

      # ============================================================================
      # FLASH - Quick navigation with labels
      # ============================================================================
      flash = {
        enable = true;
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
      mini = {
        enable = true;
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
      illuminate = {
        enable = true;
        settings = {
          filetypes_denylist = [
            "alpha"
            "dashboard"
            "NvimTree"
            "Trouble"
            "toggleterm"
          ];
        };
      };

      # ============================================================================
      # TOGGLETERM - Terminal integration
      # ============================================================================
      toggleterm = {
        enable = true;
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
  };
}
