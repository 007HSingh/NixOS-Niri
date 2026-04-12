_:

{
  programs.nixvim = {
    plugins = {
      # ============================================================================
      # OBSIDIAN - Note-taking with Obsidian vaults
      # ============================================================================
      obsidian = {
        enable = true;
        settings = {
          workspaces = [
            {
              name = "notes";
              path = "~/Notes";
            }
          ];

          # Disable legacy commands (ObsidianBacklinks → Obsidian backlinks)
          legacy_commands = false;

          # Completion via nvim-cmp
          completion = {
            nvim_cmp = true;
            min_chars = 2;
          };

          # Note naming: timestamp + title slug
          note_id_func.__raw = ''
            function(title)
              local suffix = ""
              if title ~= nil then
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
              else
                for _ = 1, 4 do
                  suffix = suffix .. string.char(math.random(65, 90))
                end
              end
              return tostring(os.time()) .. "-" .. suffix
            end
          '';

          new_notes_location = "current_dir";

          picker = {
            name = "telescope.nvim";
          };

          # Checkbox cycle order (replaces old ui.checkboxes ordering)
          checkbox = {
            order = [
              " "
              "x"
              ">"
              "~"
            ];
          };

          # UI disabled — render-markdown.nvim handles all rendering.
          # Enabling both causes a conflict error on startup.
          ui.enable = false;

          # attachments.img_folder → attachments.folder (renamed in 3.x)
          attachments.folder = "assets/imgs";

          daily_notes = {
            folder = "daily";
            date_format = "%Y-%m-%d";
            alias_format = "%B %-d, %Y";
            template = null;
          };

          templates = {
            folder = "templates";
            date_format = "%Y-%m-%d";
            time_format = "%H:%M";
          };

          # follow_url_func removed — vim.ui.open is the default in 3.x
        };
      };
    };

    # ============================================================================
    # OBSIDIAN KEYMAPS
    # ============================================================================
    keymaps = [
      {
        mode = "n";
        key = "<leader>on";
        action = ":Obsidian new<CR>";
        options = {
          silent = true;
          desc = "New note";
        };
      }
      {
        mode = "n";
        key = "<leader>oo";
        action = ":Obsidian open<CR>";
        options = {
          silent = true;
          desc = "Open in Obsidian app";
        };
      }
      {
        mode = "n";
        key = "<leader>of";
        action = ":Obsidian quick_switch<CR>";
        options = {
          silent = true;
          desc = "Find note";
        };
      }
      {
        mode = "n";
        key = "<leader>os";
        action = ":Obsidian search<CR>";
        options = {
          silent = true;
          desc = "Search notes";
        };
      }
      {
        mode = "n";
        key = "<leader>ob";
        action = ":Obsidian backlinks<CR>";
        options = {
          silent = true;
          desc = "Show backlinks";
        };
      }
      {
        mode = "n";
        key = "<leader>ol";
        action = ":Obsidian links<CR>";
        options = {
          silent = true;
          desc = "Show links";
        };
      }
      {
        mode = "n";
        key = "<leader>od";
        action = ":Obsidian today<CR>";
        options = {
          silent = true;
          desc = "Daily note (today)";
        };
      }
      {
        mode = "n";
        key = "<leader>oy";
        action = ":Obsidian yesterday<CR>";
        options = {
          silent = true;
          desc = "Daily note (yesterday)";
        };
      }
      {
        mode = "n";
        key = "<leader>ot";
        action = ":Obsidian template<CR>";
        options = {
          silent = true;
          desc = "Insert template";
        };
      }
      {
        mode = "n";
        key = "<leader>op";
        action = ":Obsidian paste_img<CR>";
        options = {
          silent = true;
          desc = "Paste image";
        };
      }
      {
        mode = "n";
        key = "<leader>or";
        action = ":Obsidian rename<CR>";
        options = {
          silent = true;
          desc = "Rename note";
        };
      }
      {
        mode = "n";
        key = "<leader>oc";
        action = ":Obsidian toggle_checkbox<CR>";
        options = {
          silent = true;
          desc = "Toggle checkbox";
        };
      }
      {
        mode = "v";
        key = "<leader>ol";
        action = ":Obsidian link<CR>";
        options = {
          silent = true;
          desc = "Link selection";
        };
      }
      {
        mode = "v";
        key = "<leader>on";
        action = ":Obsidian link_new<CR>";
        options = {
          silent = true;
          desc = "Link to new note";
        };
      }
      {
        mode = "n";
        key = "gf";
        action = ":Obsidian follow_link<CR>";
        options = {
          silent = true;
          desc = "Follow Obsidian link";
        };
      }
    ];
  };
}
