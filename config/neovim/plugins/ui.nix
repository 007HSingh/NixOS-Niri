_:

{
  programs.nixvim = {
    plugins = {
      # ============================================================================
      # WEB DEVICONS - Icons for UI components
      # ============================================================================
      web-devicons.enable = true;

      # ============================================================================
      # DASHBOARD - Startup dashboard
      # ============================================================================
      dashboard = {
        enable = true;
        settings = {
          theme = "doom";
          config = {
            header = [
              "                                                     "
              "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
              "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
              "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
              "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
              "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
              "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
              "                                                     "
            ];
            center = [
              {
                icon = "  ";
                icon_hl = "Title";
                desc = "Find File";
                desc_hl = "String";
                key = "f";
                key_hl = "Number";
                key_format = " %s";
                action = "Telescope find_files";
              }
              {
                icon = "  ";
                icon_hl = "Title";
                desc = "New File";
                desc_hl = "String";
                key = "n";
                key_hl = "Number";
                key_format = " %s";
                action = "ene | startinsert";
              }
              {
                icon = "  ";
                icon_hl = "Title";
                desc = "Recent Files";
                desc_hl = "String";
                key = "r";
                key_hl = "Number";
                key_format = " %s";
                action = "Telescope oldfiles";
              }
              {
                icon = "  ";
                icon_hl = "Title";
                desc = "Find Text";
                desc_hl = "String";
                key = "g";
                key_hl = "Number";
                key_format = " %s";
                action = "Telescope live_grep";
              }
              {
                icon = "  ";
                icon_hl = "Title";
                desc = "Configuration";
                desc_hl = "String";
                key = "c";
                key_hl = "Number";
                key_format = " %s";
                action = "cd ~/nixos-config | Telescope find_files";
              }
              {
                icon = "  ";
                icon_hl = "Title";
                desc = "Quit";
                desc_hl = "String";
                key = "q";
                key_hl = "Number";
                key_format = " %s";
                action = "qa";
              }
            ];
            footer = [
              ""
              "🚀 Happy Coding!"
            ];
          };
        };
      };

      # ============================================================================
      # LUALINE - Status line
      # ============================================================================
      lualine = {
        enable = true;
        settings = {
          options = {
            # Dynamic — inherits Catppuccin/Stylix active colorscheme (no hardcoded colors)
            theme = "auto";
            icons_enabled = true;

            # Rounded pill/bubble section separators
            section_separators = {
              left = "";
              right = "";
            };

            # Soft inner component separators
            component_separators = {
              left = "";
              right = "";
            };

            globalstatus = true;
            disabled_filetypes = {
              statusline = [ "alpha" ];
            };
          };

          sections = {
            lualine_a = [
              {
                __unkeyed-1 = "mode";
                icon = "";
                padding = {
                  left = 2;
                  right = 2;
                };
              }
            ];
            lualine_b = [
              {
                __unkeyed-1 = "branch";
                icon = "";
                padding = {
                  left = 2;
                  right = 1;
                };
              }
              {
                __unkeyed-1 = "diff";
                padding = {
                  left = 1;
                  right = 1;
                };
              }
              {
                __unkeyed-1 = "diagnostics";
                padding = {
                  left = 1;
                  right = 2;
                };
              }
            ];
            lualine_c = [
              {
                __unkeyed-1 = "filename";
                file_status = true;
                path = 1;
                padding = {
                  left = 2;
                  right = 2;
                };
              }
            ];
            lualine_x = [
              {
                __unkeyed-1 = "encoding";
                padding = {
                  left = 2;
                  right = 1;
                };
              }
              {
                __unkeyed-1 = "fileformat";
                symbols = {
                  unix = "";
                  dos = "";
                  mac = "";
                };
                padding = {
                  left = 1;
                  right = 1;
                };
              }
              {
                __unkeyed-1 = "filetype";
                padding = {
                  left = 1;
                  right = 2;
                };
              }
            ];
            lualine_y = [
              {
                __unkeyed-1 = "progress";
                padding = {
                  left = 2;
                  right = 1;
                };
              }
            ];
            lualine_z = [
              {
                __unkeyed-1 = "location";
                padding = {
                  left = 1;
                  right = 2;
                };
              }
            ];
          };

          inactive_sections = {
            lualine_a = [ ];
            lualine_b = [ ];
            lualine_c = [ "filename" ];
            lualine_x = [ "location" ];
            lualine_y = [ ];
            lualine_z = [ ];
          };
        };
      };

      # ============================================================================
      # BUFFERLINE - Buffer tabs
      # ============================================================================
      bufferline = {
        enable = true;
        settings = {
          options = {
            mode = "buffers";
            numbers = "none";
            close_command = "bdelete! %d";
            right_mouse_command = "bdelete! %d";
            left_mouse_command = "buffer %d";
            middle_mouse_command = null;
            indicator = {
              style = "icon";
              icon = "▎";
            };
            buffer_close_icon = "󰅖";
            modified_icon = "●";
            close_icon = "";
            left_trunc_marker = "";
            right_trunc_marker = "";
            diagnostics = "nvim_lsp";
            diagnostics_indicator = ''
              function(count, level, diagnostics_dict, context)
                local icon = level:match("error") and " " or " "
                return " " .. icon .. count
              end
            '';
            separator_style = "thin";
            show_buffer_close_icons = true;
            show_close_icon = false;
            always_show_bufferline = true;
            offsets = [
              {
                filetype = "NvimTree";
                text = "File Explorer";
                text_align = "center";
                separator = true;
              }
            ];
          };
        };
      };

      # ============================================================================
      # NVIM-TREE - File explorer (sidebar, disabled on startup)
      # ============================================================================
      # NOTE: Coexists with oil.nvim below. Oil is buffer-based (default disabled),
      # nvim-tree is sidebar-based (also disabled on startup). This allows both
      # workflows. nvim-tree disables netrw, but oil also hijacks it — UFOn picks
      # whichever best matches the use case. Toggle nvim-tree with :NvimTreeToggle
      nvim-tree = {
        enable = true;
        openOnSetup = false;
        settings = {
          auto_reload_on_write = true;
          disable_netrw = true;
          hijack_cursor = true;
          sync_root_with_cwd = true;
          update_focused_file = {
            enable = true;
            update_root = false;
          };
          view = {
            width = 35;
            side = "left";
            preserve_window_proportions = true;
          };
          renderer = {
            highlight_git = true;
            root_folder_label = false;
            indent_markers = {
              enable = true;
            };
            icons = {
              git_placement = "after";
              show = {
                file = true;
                folder = true;
                folder_arrow = true;
                git = true;
              };
              glyphs = {
                default = "";
                symlink = "";
                folder = {
                  arrow_closed = "";
                  arrow_open = "";
                  default = "";
                  open = "";
                  empty = "";
                  empty_open = "";
                  symlink = "";
                  symlink_open = "";
                };
              };
            };
          };
          filters = {
            dotfiles = false;
            custom = [
              ".git"
              "node_modules"
              ".cache"
            ];
          };
          actions = {
            open_file = {
              quit_on_open = false;
              window_picker = {
                enable = true;
              };
            };
          };
        };
      };

      # ============================================================================
      # INDENT BLANKLINE - Indent guides
      # ============================================================================
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
          };
          scope = {
            enabled = true;
            show_start = false;
            show_end = false;
          };
          exclude = {
            filetypes = [
              "help"
              "alpha"
              "dashboard"
              "nvim-tree"
              "Trouble"
              "lazy"
              "mason"
              "notify"
              "toggleterm"
            ];
          };
        };
      };

      # ============================================================================
      # SCROLLBAR - Visual scrollbar
      # ============================================================================
      nvim-scrollbar = {
        enable = true;
        settings = {
          handle = {
            color = "#45475a";
          };
          marks = {
            Search = {
              color = "#f9e2af";
            };
            Error = {
              color = "#f38ba8";
            };
            Warn = {
              color = "#fab387";
            };
            Info = {
              color = "#89dceb";
            };
            Hint = {
              color = "#94e2d5";
            };
            Misc = {
              color = "#cba6f7";
            };
          };
        };
      };

      # ============================================================================
      # COLORIZER - Highlight colors
      # ============================================================================
      nvim-colorizer = {
        enable = true;
        userDefaultOptions = {
          RGB = true;
          RRGGBB = true;
          names = false;
          RRGGBBAA = true;
          rgb_fn = true;
          hsl_fn = true;
          mode = "background";
        };
      };

      # ============================================================================
      # NOICE - Enhanced UI
      # ============================================================================
      noice = {
        enable = true;
        settings = {
          lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
            progress = {
              enabled = true;
            };
            hover = {
              enabled = true;
            };
            signature = {
              enabled = true;
            };
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = true; # pairs with inc-rename.nvim
            lsp_doc_border = true;
          };
          views = {
            cmdline_popup = {
              position = {
                row = 5;
                col = "50%";
              };
              size = {
                width = 60;
                height = "auto";
              };
            };
            popupmenu = {
              relative = "editor";
              position = {
                row = 8;
                col = "50%";
              };
              size = {
                width = 60;
                height = 10;
              };
              border = {
                style = "rounded";
                padding = [
                  0
                  1
                ];
              };
              win_options = {
                winhighlight = {
                  Normal = "Normal";
                  FloatBorder = "DiagnosticInfo";
                };
              };
            };
          };
        };
      };

      # ============================================================================
      # NOTIFY - Better notifications
      # ============================================================================
      notify = {
        enable = true;
        settings = {
          background_colour = "#1e1e2e";
          fps = 60;
          icons = {
            DEBUG = "";
            ERROR = "";
            INFO = "";
            TRACE = "✎";
            WARN = "";
          };
          level = 2;
          minimum_width = 50;
          render = "compact";
          stages = "fade_in_slide_out";
          timeout = 3000;
          top_down = true;
        };
      };

      # ============================================================================
      # DRESSING - Better UI for inputs/selects
      # ============================================================================
      dressing = {
        enable = true;
        settings = {
          input = {
            enabled = true;
            default_prompt = "➤ ";
            win_options = {
              winblend = 0;
            };
          };
          select = {
            enabled = true;
            backend = [
              "telescope"
              "builtin"
            ];
          };
        };
      };

      # ============================================================================
      # NAVIC - Breadcrumbs
      # ============================================================================
      # ============================================================================
      # CELLULAR-AUTOMATON - Fun buffer animations
      # ============================================================================
      cellular-automaton = {
        enable = true;
      };

      navic = {
        enable = true;
        settings = {
          icons = {
            File = " ";
            Module = " ";
            Namespace = " ";
            Package = " ";
            Class = " ";
            Method = " ";
            Property = " ";
            Field = " ";
            Constructor = " ";
            Enum = " ";
            Interface = " ";
            Function = " ";
            Variable = " ";
            Constant = " ";
            String = " ";
            Number = " ";
            Boolean = " ";
            Array = " ";
            Object = " ";
            Key = " ";
            Null = " ";
            EnumMember = " ";
            Struct = " ";
            Event = " ";
            Operator = " ";
            TypeParameter = " ";
          };
          highlight = true;
          separator = " > ";
          depth_limit = 0;
          depth_limit_indicator = "..";
        };
      };
    };
  };
}
