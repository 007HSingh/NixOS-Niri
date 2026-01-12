{ config, lib, ... }:

{
  programs.nixvim = {
    keymaps = [
      # ========================================================================
      # GENERAL MAPPINGS
      # ========================================================================

      # Better window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options = {
          silent = true;
          desc = "Move to left window";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options = {
          silent = true;
          desc = "Move to below window";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options = {
          silent = true;
          desc = "Move to above window";
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options = {
          silent = true;
          desc = "Move to right window";
        };
      }

      # Window resizing
      {
        mode = "n";
        key = "<C-Up>";
        action = ":resize -2<CR>";
        options = {
          silent = true;
          desc = "Decrease window height";
        };
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = ":resize +2<CR>";
        options = {
          silent = true;
          desc = "Increase window height";
        };
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = ":vertical resize -2<CR>";
        options = {
          silent = true;
          desc = "Decrease window width";
        };
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = ":vertical resize +2<CR>";
        options = {
          silent = true;
          desc = "Increase window width";
        };
      }

      # Buffer navigation
      {
        mode = "n";
        key = "<S-l>";
        action = ":bnext<CR>";
        options = {
          silent = true;
          desc = "Next buffer";
        };
      }
      {
        mode = "n";
        key = "<S-h>";
        action = ":bprevious<CR>";
        options = {
          silent = true;
          desc = "Previous buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = ":bdelete<CR>";
        options = {
          silent = true;
          desc = "Delete buffer";
        };
      }

      # Better indenting
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options = {
          silent = true;
          desc = "Indent left";
        };
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options = {
          silent = true;
          desc = "Indent right";
        };
      }

      # Move lines up/down
      {
        mode = "n";
        key = "<A-j>";
        action = ":m .+1<CR>==";
        options = {
          silent = true;
          desc = "Move line down";
        };
      }
      {
        mode = "n";
        key = "<A-k>";
        action = ":m .-2<CR>==";
        options = {
          silent = true;
          desc = "Move line up";
        };
      }
      {
        mode = "v";
        key = "<A-j>";
        action = ":m '>+1<CR>gv=gv";
        options = {
          silent = true;
          desc = "Move selection down";
        };
      }
      {
        mode = "v";
        key = "<A-k>";
        action = ":m '<-2<CR>gv=gv";
        options = {
          silent = true;
          desc = "Move selection up";
        };
      }

      # Clear search highlighting
      {
        mode = "n";
        key = "<Esc>";
        action = ":noh<CR>";
        options = {
          silent = true;
          desc = "Clear search highlight";
        };
      }

      # Save and quit
      {
        mode = "n";
        key = "<leader>w";
        action = ":w<CR>";
        options = {
          silent = true;
          desc = "Save file";
        };
      }
      {
        mode = "n";
        key = "<leader>q";
        action = ":q<CR>";
        options = {
          silent = true;
          desc = "Quit";
        };
      }
      {
        mode = "n";
        key = "<leader>Q";
        action = ":qa!<CR>";
        options = {
          silent = true;
          desc = "Quit all without saving";
        };
      }

      # File explorer
      {
        mode = "n";
        key = "<leader>e";
        action = ":NvimTreeToggle<CR>";
        options = {
          silent = true;
          desc = "Toggle file explorer";
        };
      }

      # Better paste in visual mode (doesn't yank replaced text)
      {
        mode = "v";
        key = "p";
        action = ''"_dP'';
        options = {
          silent = true;
          desc = "Paste without yanking";
        };
      }

      # Stay in visual mode after indenting
      {
        mode = "v";
        key = "<Tab>";
        action = ">gv";
        options = {
          silent = true;
          desc = "Indent and stay in visual";
        };
      }
      {
        mode = "v";
        key = "<S-Tab>";
        action = "<gv";
        options = {
          silent = true;
          desc = "Unindent and stay in visual";
        };
      }

      # Split windows
      {
        mode = "n";
        key = "<leader>sv";
        action = ":vsplit<CR>";
        options = {
          silent = true;
          desc = "Split vertically";
        };
      }
      {
        mode = "n";
        key = "<leader>sh";
        action = ":split<CR>";
        options = {
          silent = true;
          desc = "Split horizontally";
        };
      }
      {
        mode = "n";
        key = "<leader>sc";
        action = ":close<CR>";
        options = {
          silent = true;
          desc = "Close split";
        };
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = ":Neogit<CR>";
        options = {
          silent = true;
          desc = "Open Neogit";
        };
      }
      {
        mode = "n";
        key = "<leader>gc";
        action = ":Neogit commit<CR>";
        options = {
          silent = true;
          desc = "Git commit";
        };
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = ":Neogit push<CR>";
        options = {
          silent = true;
          desc = "Git push";
        };
      }
      {
        mode = "n";
        key = "<leader>gl";
        action = ":Neogit pull<CR>";
        options = {
          silent = true;
          desc = "Git pull";
        };
      }
      {
        mode = "n";
        key = "<leader>gd";
        action = ":DiffviewOpen<CR>";
        options = {
          silent = true;
          desc = "Open diff view";
        };
      }
      {
        mode = "n";
        key = "<leader>gx";
        action = ":DiffviewClose<CR>";
        options = {
          silent = true;
          desc = "Close diff view";
        };
      }
      {
        mode = "n";
        key = "<leader>gh";
        action = ":DiffviewFileHistory<CR>";
        options = {
          silent = true;
          desc = "File history";
        };
      }
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
      {
        mode = "n";
        key = "<leader>fp";
        action = ":Telescope projects<CR>";
        options = {
          silent = true;
          desc = "Find projects";
        };
      }
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
      {
        mode = "n";
        key = "<leader>u";
        action = ":UndotreeToggle<CR>";
        options = {
          silent = true;
          desc = "Toggle undotree";
        };
      }
      {
        mode = "n";
        key = "<leader>o";
        action = ":Oil<CR>";
        options = {
          silent = true;
          desc = "Open oil";
        };
      }
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
