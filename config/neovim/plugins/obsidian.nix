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
              path = "~/notes";
            }
          ];

          # Completion via nvim-cmp (already configured in completion.nix)
          completion = {
            nvim_cmp = true;
            min_chars = 2;
          };

          # Note naming: use title-based slugs
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

          # Open notes in current buffer, not a new split
          new_notes_location = "current_dir";

          # Use telescope for search/find (already configured in telescope.nix)
          picker = {
            name = "telescope.nvim";
          };

          # UI enhancements
          ui = {
            enable = true;
            checkboxes = {
              " " = {
                char = "󰄱";
                hl_group = "ObsidianTodo";
              };
              "x" = {
                char = "";
                hl_group = "ObsidianDone";
              };
              ">" = {
                char = "";
                hl_group = "ObsidianRightArrow";
              };
              "~" = {
                char = "󰰱";
                hl_group = "ObsidianTilde";
              };
            };
            bullets = {
              char = "•";
              hl_group = "ObsidianBullet";
            };
            external_link_icon = {
              char = "";
              hl_group = "ObsidianExtLinkIcon";
            };
            reference_text = {
              hl_group = "ObsidianRefText";
            };
            highlight_text = {
              hl_group = "ObsidianHighlightText";
            };
            tags = {
              hl_group = "ObsidianTag";
            };
            block_ids = {
              hl_group = "ObsidianBlockID";
            };
            hl_groups = {
              ObsidianTodo = {
                bold = true;
                fg = "#f0a050";
              };
              ObsidianDone = {
                bold = true;
                fg = "#89b4fa";
              };
              ObsidianRightArrow = {
                bold = true;
                fg = "#f0a050";
              };
              ObsidianTilde = {
                bold = true;
                fg = "#ff5555";
              };
              ObsidianImportant = {
                bold = true;
                fg = "#d73128";
              };
              ObsidianBullet = {
                bold = true;
                fg = "#89b4fa";
              };
              ObsidianRefText = {
                underline = true;
                fg = "#cba6f7";
              };
              ObsidianExtLinkIcon = {
                fg = "#cba6f7";
              };
              ObsidianTag = {
                italic = true;
                fg = "#89b4fa";
              };
              ObsidianBlockID = {
                italic = true;
                fg = "#89b4fa";
              };
              ObsidianHighlightText = {
                bg = "#45475a";
              };
            };
          };

          attachments = {
            img_folder = "assets/imgs";
          };

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

          # Follow URLs with <CR> in normal mode
          follow_url_func.__raw = ''
            function(url)
              vim.fn.jobstart({ "xdg-open", url })
            end
          '';
        };
      };
    };

    # ============================================================================
    # OBSIDIAN KEYMAPS
    # ============================================================================
    keymaps = [
      # Open/find notes
      {
        mode = "n";
        key = "<leader>on";
        action = ":ObsidianNew<CR>";
        options = {
          silent = true;
          desc = "New note";
        };
      }
      {
        mode = "n";
        key = "<leader>oo";
        action = ":ObsidianOpen<CR>";
        options = {
          silent = true;
          desc = "Open in Obsidian app";
        };
      }
      {
        mode = "n";
        key = "<leader>of";
        action = ":ObsidianQuickSwitch<CR>";
        options = {
          silent = true;
          desc = "Find note";
        };
      }
      {
        mode = "n";
        key = "<leader>os";
        action = ":ObsidianSearch<CR>";
        options = {
          silent = true;
          desc = "Search notes";
        };
      }
      {
        mode = "n";
        key = "<leader>ob";
        action = ":ObsidianBacklinks<CR>";
        options = {
          silent = true;
          desc = "Show backlinks";
        };
      }
      {
        mode = "n";
        key = "<leader>ol";
        action = ":ObsidianLinks<CR>";
        options = {
          silent = true;
          desc = "Show links";
        };
      }
      {
        mode = "n";
        key = "<leader>od";
        action = ":ObsidianToday<CR>";
        options = {
          silent = true;
          desc = "Daily note (today)";
        };
      }
      {
        mode = "n";
        key = "<leader>oy";
        action = ":ObsidianYesterday<CR>";
        options = {
          silent = true;
          desc = "Daily note (yesterday)";
        };
      }
      {
        mode = "n";
        key = "<leader>ot";
        action = ":ObsidianTemplate<CR>";
        options = {
          silent = true;
          desc = "Insert template";
        };
      }
      {
        mode = "n";
        key = "<leader>op";
        action = ":ObsidianPasteImg<CR>";
        options = {
          silent = true;
          desc = "Paste image";
        };
      }
      {
        mode = "n";
        key = "<leader>or";
        action = ":ObsidianRename<CR>";
        options = {
          silent = true;
          desc = "Rename note";
        };
      }
      # Toggle checkbox under cursor
      {
        mode = "n";
        key = "<leader>oc";
        action = ":ObsidianToggleCheckbox<CR>";
        options = {
          silent = true;
          desc = "Toggle checkbox";
        };
      }
      # Create link from selection
      {
        mode = "v";
        key = "<leader>ol";
        action = ":ObsidianLink<CR>";
        options = {
          silent = true;
          desc = "Link selection";
        };
      }
      {
        mode = "v";
        key = "<leader>on";
        action = ":ObsidianLinkNew<CR>";
        options = {
          silent = true;
          desc = "Link to new note";
        };
      }
      # Follow link under cursor
      {
        mode = "n";
        key = "gf";
        action = ":ObsidianFollowLink<CR>";
        options = {
          silent = true;
          desc = "Follow Obsidian link";
        };
      }
    ];
  };
}
