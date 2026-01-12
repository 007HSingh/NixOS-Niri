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
    ];
  };
}
