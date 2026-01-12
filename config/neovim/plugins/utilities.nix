{ config, lib, ... }:

{
  programs.nixvim = {
    # ============================================================================
    # PERSISTENCE - Session management
    # ============================================================================
    plugins.persistence = {
      enable = lib.mkDefault true;
    };

    # Add persistence keymaps
    keymaps = [
      {
        mode = "n";
        key = "<leader>qs";
        action.__raw = ''
          function()
            require("persistence").load()
          end
        '';
        options = {
          silent = true;
          desc = "Restore session";
        };
      }
      {
        mode = "n";
        key = "<leader>ql";
        action.__raw = ''
          function()
            require("persistence").load({ last = true })
          end
        '';
        options = {
          silent = true;
          desc = "Restore last session";
        };
      }
      {
        mode = "n";
        key = "<leader>qd";
        action.__raw = ''
          function()
            require("persistence").stop()
          end
        '';
        options = {
          silent = true;
          desc = "Don't save session";
        };
      }
    ];

    # ============================================================================
    # PROJECT - Project management
    # ============================================================================
    plugins.project-nvim = {
      enable = lib.mkDefault true;
      enableTelescope = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>fp";
        action = ":Telescope projects<CR>";
        options = {
          silent = true;
          desc = "Find projects";
        };
      }
    ];

    # ============================================================================
    # MARKDOWN-PREVIEW - Preview markdown files
    # ============================================================================
    plugins.markdown-preview = {
      enable = lib.mkDefault true;
      settings = {
        auto_close = 1;
        auto_start = 0;
        browser = "firefox";
        port = "8080";
        theme = "dark";
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>mp";
        action = ":MarkdownPreview<CR>";
        options = {
          silent = true;
          desc = "Markdown preview";
        };
      }
      {
        mode = "n";
        key = "<leader>ms";
        action = ":MarkdownPreviewStop<CR>";
        options = {
          silent = true;
          desc = "Stop markdown preview";
        };
      }
    ];

    # ============================================================================
    # UNDOTREE - Visualize undo history
    # ============================================================================
    plugins.undotree = {
      enable = lib.mkDefault true;
      settings = {
        autoOpenDiff = true;
        focusOnToggle = true;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>u";
        action = ":UndotreeToggle<CR>";
        options = {
          silent = true;
          desc = "Toggle undotree";
        };
      }
    ];

    # ============================================================================
    # OIL - File navigation like a buffer
    # ============================================================================
    plugins.oil = {
      enable = lib.mkDefault false; # Optional - alternative to nvim-tree
      settings = {
        columns = [ "icon" ];
        view_options = {
          show_hidden = true;
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>o";
        action = ":Oil<CR>";
        options = {
          silent = true;
          desc = "Open oil";
        };
      }
    ];

    # ============================================================================
    # SPECTRE - Search and replace
    # ============================================================================
    plugins.spectre = {
      enable = lib.mkDefault true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>sr";
        action = ":lua require('spectre').open()<CR>";
        options = {
          silent = true;
          desc = "Search and replace";
        };
      }
      {
        mode = "n";
        key = "<leader>sw";
        action = ":lua require('spectre').open_visual({select_word=true})<CR>";
        options = {
          silent = true;
          desc = "Search current word";
        };
      }
      {
        mode = "v";
        key = "<leader>sw";
        action = ":lua require('spectre').open_visual()<CR>";
        options = {
          silent = true;
          desc = "Search selection";
        };
      }
      {
        mode = "n";
        key = "<leader>sp";
        action = ":lua require('spectre').open_file_search({select_word=true})<CR>";
        options = {
          silent = true;
          desc = "Search in current file";
        };
      }
    ];

    # ============================================================================
    # HARPOON - Quick file navigation
    # ============================================================================
    plugins.harpoon = {
      enable = lib.mkDefault true;
      enableTelescope = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ha";
        action = ":lua require('harpoon.mark').add_file()<CR>";
        options = {
          silent = true;
          desc = "Harpoon add file";
        };
      }
      {
        mode = "n";
        key = "<leader>hm";
        action = ":lua require('harpoon.ui').toggle_quick_menu()<CR>";
        options = {
          silent = true;
          desc = "Harpoon menu";
        };
      }
      {
        mode = "n";
        key = "<leader>1";
        action = ":lua require('harpoon.ui').nav_file(1)<CR>";
        options = {
          silent = true;
          desc = "Harpoon file 1";
        };
      }
      {
        mode = "n";
        key = "<leader>2";
        action = ":lua require('harpoon.ui').nav_file(2)<CR>";
        options = {
          silent = true;
          desc = "Harpoon file 2";
        };
      }
      {
        mode = "n";
        key = "<leader>3";
        action = ":lua require('harpoon.ui').nav_file(3)<CR>";
        options = {
          silent = true;
          desc = "Harpoon file 3";
        };
      }
      {
        mode = "n";
        key = "<leader>4";
        action = ":lua require('harpoon.ui').nav_file(4)<CR>";
        options = {
          silent = true;
          desc = "Harpoon file 4";
        };
      }
    ];

    # ============================================================================
    # NVIM-UFO - Better folds
    # ============================================================================
    plugins.nvim-ufo = {
      enable = lib.mkDefault true;
    };

    keymaps = [
      {
        mode = "n";
        key = "zR";
        action = ":lua require('ufo').openAllFolds()<CR>";
        options = {
          silent = true;
          desc = "Open all folds";
        };
      }
      {
        mode = "n";
        key = "zM";
        action = ":lua require('ufo').closeAllFolds()<CR>";
        options = {
          silent = true;
          desc = "Close all folds";
        };
      }
    ];
  };
}
