_:

{
  programs.nixvim = {
    plugins = {
      # ============================================================================
      # GITLINKER - Copy GitHub/GitLab permalinks to clipboard
      # ============================================================================
      gitlinker = {
        enable = true;
        settings = {
          # Copy URL to clipboard (default action)
          action_callback.__raw = ''
            require("gitlinker.actions").copy_to_clipboard
          '';
          print_url = true;
          # Disable default <leader>gy mapping so we define our own below
          mappings = null;
        };
      };
    };

    # ============================================================================
    # GITLINKER KEYMAPS
    # ============================================================================
    keymaps = [
      {
        mode = "n";
        key = "<leader>gy";
        action.__raw = ''
          function()
            require("gitlinker").get_buf_range_url("n")
          end
        '';
        options = {
          silent = true;
          desc = "Copy git permalink";
        };
      }
      {
        mode = "v";
        key = "<leader>gy";
        action.__raw = ''
          function()
            require("gitlinker").get_buf_range_url("v")
          end
        '';
        options = {
          silent = true;
          desc = "Copy git permalink (selection)";
        };
      }
      # Open in browser instead of copying
      {
        mode = "n";
        key = "<leader>gY";
        action.__raw = ''
          function()
            require("gitlinker").get_buf_range_url(
              "n",
              require("gitlinker.actions").open_in_browser
            )
          end
        '';
        options = {
          silent = true;
          desc = "Open git permalink in browser";
        };
      }
    ];
  };
}
