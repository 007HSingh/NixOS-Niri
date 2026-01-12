{ config, lib, ... }:

{
  programs.nixvim = {
    # ============================================================================
    # TELESCOPE - Fuzzy finder
    # ============================================================================
    plugins.telescope = {
      enable = lib.mkDefault true;

      extensions = {
        fzf-native = {
          enable = true;
          settings = {
            case_mode = "smart_case";
            fuzzy = true;
            override_file_sorter = true;
            override_generic_sorter = true;
          };
        };
        ui-select = {
          enable = true;
        };
        file-browser = {
          enable = true;
        };
      };

      settings = {
        defaults = {
          prompt_prefix = " 🔍 ";
          selection_caret = " ▶ ";
          entry_prefix = "  ";
          path_display = [ "truncate" ];
          sorting_strategy = "ascending";
          layout_strategy = "horizontal";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
              results_width = 0.8;
            };
            vertical = {
              mirror = false;
            };
            width = 0.87;
            height = 0.80;
            preview_cutoff = 120;
          };
          file_ignore_patterns = [
            "^.git/"
            "^node_modules/"
            "^.cache/"
            "%.o"
            "%.a"
            "%.out"
            "%.class"
            "%.pdf"
            "%.mkv"
            "%.mp4"
            "%.zip"
          ];
          mappings = {
            i = {
              "<C-j>" = {
                __raw = "require('telescope.actions').move_selection_next";
              };
              "<C-k>" = {
                __raw = "require('telescope.actions').move_selection_previous";
              };
              "<C-n>" = {
                __raw = "require('telescope.actions').cycle_history_next";
              };
              "<C-p>" = {
                __raw = "require('telescope.actions').cycle_history_prev";
              };
              "<C-c>" = {
                __raw = "require('telescope.actions').close";
              };
              "<Down>" = {
                __raw = "require('telescope.actions').move_selection_next";
              };
              "<Up>" = {
                __raw = "require('telescope.actions').move_selection_previous";
              };
              "<CR>" = {
                __raw = "require('telescope.actions').select_default";
              };
              "<C-x>" = {
                __raw = "require('telescope.actions').select_horizontal";
              };
              "<C-v>" = {
                __raw = "require('telescope.actions').select_vertical";
              };
              "<C-t>" = {
                __raw = "require('telescope.actions').select_tab";
              };
              "<C-u>" = {
                __raw = "require('telescope.actions').preview_scrolling_up";
              };
              "<C-d>" = {
                __raw = "require('telescope.actions').preview_scrolling_down";
              };
            };
            n = {
              "<esc>" = {
                __raw = "require('telescope.actions').close";
              };
              "<CR>" = {
                __raw = "require('telescope.actions').select_default";
              };
              "<C-x>" = {
                __raw = "require('telescope.actions').select_horizontal";
              };
              "<C-v>" = {
                __raw = "require('telescope.actions').select_vertical";
              };
              "<C-t>" = {
                __raw = "require('telescope.actions').select_tab";
              };
              "j" = {
                __raw = "require('telescope.actions').move_selection_next";
              };
              "k" = {
                __raw = "require('telescope.actions').move_selection_previous";
              };
              "H" = {
                __raw = "require('telescope.actions').move_to_top";
              };
              "M" = {
                __raw = "require('telescope.actions').move_to_middle";
              };
              "L" = {
                __raw = "require('telescope.actions').move_to_bottom";
              };
              "gg" = {
                __raw = "require('telescope.actions').move_to_top";
              };
              "G" = {
                __raw = "require('telescope.actions').move_to_bottom";
              };
              "<C-u>" = {
                __raw = "require('telescope.actions').preview_scrolling_up";
              };
              "<C-d>" = {
                __raw = "require('telescope.actions').preview_scrolling_down";
              };
            };
          };
        };
      };

      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Find files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Live grep";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Find buffers";
        };
        "<leader>fh" = {
          action = "help_tags";
          options.desc = "Help tags";
        };
        "<leader>fr" = {
          action = "oldfiles";
          options.desc = "Recent files";
        };
        "<leader>fs" = {
          action = "lsp_document_symbols";
          options.desc = "Document symbols";
        };
        "<leader>fw" = {
          action = "lsp_workspace_symbols";
          options.desc = "Workspace symbols";
        };
        "<leader>fd" = {
          action = "diagnostics";
          options.desc = "Diagnostics";
        };
        "<leader>fc" = {
          action = "commands";
          options.desc = "Commands";
        };
        "<leader>fk" = {
          action = "keymaps";
          options.desc = "Keymaps";
        };
        "<leader>fm" = {
          action = "marks";
          options.desc = "Marks";
        };
        "<leader>fo" = {
          action = "vim_options";
          options.desc = "Vim options";
        };
        "<leader>ft" = {
          action = "colorscheme";
          options.desc = "Colorscheme";
        };
      };
    };

    # Additional telescope keymaps
    keymaps = [
      {
        mode = "n";
        key = "<leader>fe";
        action = ":Telescope file_browser<CR>";
        options = {
          silent = true;
          desc = "File browser";
        };
      }
      {
        mode = "n";
        key = "<leader>/";
        action = ":Telescope current_buffer_fuzzy_find<CR>";
        options = {
          silent = true;
          desc = "Search in current buffer";
        };
      }
      {
        mode = "n";
        key = "<leader><space>";
        action = ":Telescope find_files<CR>";
        options = {
          silent = true;
          desc = "Find files";
        };
      }
    ];
  };
}
