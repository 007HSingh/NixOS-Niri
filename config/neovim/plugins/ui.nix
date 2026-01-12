{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.nixvim = {
    # ============================================================================
    # WEB DEVICONS - Icons for UI components
    # ============================================================================
    plugins.web-devicons.enable = lib.mkDefault true;

    # ============================================================================
    # LUALINE - Status line
    # ============================================================================
    plugins.lualine = {
      enable = lib.mkDefault true;
      settings = {
        options = {
          icons_enabled = true;
          theme = "catppuccin";
          component_separators = {
            left = "";
            right = "";
          };
          section_separators = {
            left = "";
            right = "";
          };
          globalstatus = true;
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [
            "branch"
            "diff"
            "diagnostics"
          ];
          lualine_c = [ "filename" ];
          lualine_x = [
            "encoding"
            "fileformat"
            "filetype"
          ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
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
    plugins.bufferline = {
      enable = lib.mkDefault true;
      settings = {
        options = {
          mode = "buffers";
          numbers = "none";
          diagnostics = "nvim_lsp";
          separator_style = "thin";
          show_buffer_close_icons = false;
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
    # NVIM-TREE - File explorer
    # ============================================================================
    plugins.nvim-tree = {
      enable = lib.mkDefault true;
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
    plugins.indent-blankline = {
      enable = lib.mkDefault true;
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
    # ALPHA - Dashboard
    # ============================================================================
    plugins.alpha = {
      enable = lib.mkDefault true;
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          opts = {
            hl = "Type";
            position = "center";
          };
          type = "text";
          val = [
            "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
          ];
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "group";
          val = [
            {
              command = ":Telescope find_files";
              desc = " Find File";
              shortcut = "SPC f f";
            }
            {
              command = ":ene | startinsert";
              desc = " New File";
              shortcut = "SPC n";
            }
            {
              command = ":Telescope oldfiles";
              desc = " Recent Files";
              shortcut = "SPC f r";
            }
            {
              command = ":Telescope live_grep";
              desc = " Find Text";
              shortcut = "SPC f g";
            }
            {
              command = ":qa";
              desc = " Quit";
              shortcut = "SPC q";
            }
          ];
        }
        {
          type = "padding";
          val = 2;
        }
      ];
    };

    # ============================================================================
    # SCROLLBAR - Visual scrollbar
    # ============================================================================
    plugins.nvim-scrollbar = {
      enable = lib.mkDefault true;
    };

    # ============================================================================
    # COLORIZER - Highlight colors
    # ============================================================================
    plugins.nvim-colorizer = {
      enable = lib.mkDefault true;
      userDefaultOptions = {
        RGB = true;
        RRGGBB = true;
        names = false;
        mode = "background";
      };
    };

    # ============================================================================
    # NOICE - Enhanced UI
    # ============================================================================
    plugins.noice = {
      enable = lib.mkDefault false; # Optional - can be overwhelming
      settings = {
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
        };
      };
    };

    # ============================================================================
    # DRESSING - Better UI for inputs/selects
    # ============================================================================
    plugins.dressing = {
      enable = lib.mkDefault true;
    };
  };
}
