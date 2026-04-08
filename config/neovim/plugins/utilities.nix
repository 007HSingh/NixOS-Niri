_:

{
  programs.nixvim = {
    plugins = {
      # ============================================================================
      # HARPOON - File navigation
      # ============================================================================
      harpoon = {
        enable = true;
        enableTelescope = true;
      };

      # ============================================================================
      # SPECTRE - Search and replace
      # ============================================================================
      spectre = {
        enable = true;
      };

      # ============================================================================
      # OIL - File explorer (buffer-based, disabled by default)
      # ============================================================================
      # NOTE: Coexists with nvim-tree in ui.nix. Oil provides buffer-based file
      # browsing (better for quick edits), nvim-tree provides sidebar browsing.
      # Both disabled on startup; use per-workflow preference.
      oil = {
        enable = true;
        settings = {
          default_file_explorer = false;
          columns = [
            "icon"
            "permissions"
            "size"
            "mtime"
          ];
          view_options = {
            show_hidden = true;
          };
        };
      };

      # ============================================================================
      # UNDOTREE - Undo history visualizer
      # ============================================================================
      undotree = {
        enable = true;
        settings = {
          autoOpenDiff = true;
          focusOnToggle = true;
        };
      };

      # ============================================================================
      # PERSISTENCE - Session management
      # ============================================================================
      persistence = {
        enable = true;
      };

      # ============================================================================
      # PROJECT-NVIM - Project management
      # ============================================================================
      project-nvim = {
        enable = true;
        enableTelescope = true;
      };

      # ============================================================================
      # MARKDOWN-PREVIEW - Preview markdown files
      # ============================================================================
      markdown-preview = {
        enable = true;
        settings = {
          theme = "dark";
        };
      };

      # ============================================================================
      # UFO - Better folding
      # ============================================================================
      nvim-ufo = {
        enable = true;
      };
    };
  };
}
