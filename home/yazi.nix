# Yazi File Manager
# Terminal file manager with Catppuccin theme
{ ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
      preview = {
        tab_size = 2;
        max_width = 1000;
        max_height = 1000;
      };
    };
    theme = {
      manager = {
        cwd = {
          fg = "#89b4fa";
        };
        hovered = {
          fg = "#1e1e2e";
          bg = "#89b4fa";
        };
        preview_hovered = {
          underline = true;
        };
        find_keyword = {
          fg = "#f9e2af";
          italic = true;
        };
        find_position = {
          fg = "#f5c2e7";
          bg = "reset";
          italic = true;
        };
        marker_selected = {
          fg = "#a6e3a1";
          bg = "#a6e3a1";
        };
        marker_copied = {
          fg = "#f9e2af";
          bg = "#f9e2af";
        };
        marker_cut = {
          fg = "#f38ba8";
          bg = "#f38ba8";
        };
        tab_active = {
          fg = "#1e1e2e";
          bg = "#89b4fa";
        };
        tab_inactive = {
          fg = "#cdd6f4";
          bg = "#313244";
        };
        tab_width = 1;
        border_symbol = "│";
        border_style = {
          fg = "#89b4fa";
        };
      };
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = "#313244";
          bg = "#313244";
        };
        mode_normal = {
          fg = "#1e1e2e";
          bg = "#89b4fa";
          bold = true;
        };
        mode_select = {
          fg = "#1e1e2e";
          bg = "#a6e3a1";
          bold = true;
        };
        mode_unset = {
          fg = "#1e1e2e";
          bg = "#f38ba8";
          bold = true;
        };
        progress_label = {
          fg = "#cdd6f4";
          bold = true;
        };
        progress_normal = {
          fg = "#89b4fa";
          bg = "#313244";
        };
        progress_error = {
          fg = "#f38ba8";
          bg = "#313244";
        };
        permissions_t = {
          fg = "#a6e3a1";
        };
        permissions_r = {
          fg = "#f9e2af";
        };
        permissions_w = {
          fg = "#f38ba8";
        };
        permissions_x = {
          fg = "#a6e3a1";
        };
        permissions_s = {
          fg = "#585b70";
        };
      };
      input = {
        border = {
          fg = "#89b4fa";
        };
        title = { };
        value = { };
        selected = {
          reversed = true;
        };
      };
      select = {
        border = {
          fg = "#89b4fa";
        };
        active = {
          fg = "#f5c2e7";
        };
        inactive = { };
      };
      tasks = {
        border = {
          fg = "#89b4fa";
        };
        title = { };
        hovered = {
          underline = true;
        };
      };
      which = {
        mask = {
          bg = "#181825";
        };
        cand = {
          fg = "#94e2d5";
        };
        rest = {
          fg = "#9399b2";
        };
        desc = {
          fg = "#f5c2e7";
        };
        separator = "  ";
        separator_style = {
          fg = "#585b70";
        };
      };
      help = {
        on = {
          fg = "#f5c2e7";
        };
        exec = {
          fg = "#94e2d5";
        };
        desc = {
          fg = "#9399b2";
        };
        hovered = {
          bg = "#585b70";
          bold = true;
        };
        footer = {
          fg = "#313244";
          bg = "#cdd6f4";
        };
      };
      filetype = {
        rules = [
          {
            mime = "image/*";
            fg = "#94e2d5";
          }
          {
            mime = "video/*";
            fg = "#f9e2af";
          }
          {
            mime = "audio/*";
            fg = "#f9e2af";
          }
          {
            mime = "application/zip";
            fg = "#f5c2e7";
          }
          {
            mime = "application/gzip";
            fg = "#f5c2e7";
          }
          {
            mime = "application/x-tar";
            fg = "#f5c2e7";
          }
          {
            mime = "application/x-bzip";
            fg = "#f5c2e7";
          }
          {
            mime = "application/x-7z-compressed";
            fg = "#f5c2e7";
          }
          {
            mime = "application/x-rar";
            fg = "#f5c2e7";
          }
          {
            name = "*";
            fg = "#cdd6f4";
          }
          {
            name = "*/";
            fg = "#89b4fa";
          }
        ];
      };
    };
  };
}
