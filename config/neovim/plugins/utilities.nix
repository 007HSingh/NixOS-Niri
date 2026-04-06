{ config, lib, ... }:

{
  programs.nixvim = {
    plugins = {
      # ============================================================================
      # HARPOON - File navigation
      # ============================================================================
      harpoon = {
        enable = lib.mkDefault true;
        enableTelescope = true;
      };

      # ============================================================================
      # SPECTRE - Search and replace
      # ============================================================================
      spectre = {
        enable = lib.mkDefault true;
      };

      # ============================================================================
      # OIL - File explorer
      # ============================================================================
      oil = {
        enable = lib.mkDefault true;
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
        enable = lib.mkDefault true;
        settings = {
          autoOpenDiff = true;
          focusOnToggle = true;
        };
      };

      # ============================================================================
      # PERSISTENCE - Session management
      # ============================================================================
      persistence = {
        enable = lib.mkDefault true;
      };

      # ============================================================================
      # PROJECT-NVIM - Project management
      # ============================================================================
      project-nvim = {
        enable = lib.mkDefault true;
        enableTelescope = true;
      };

      # ============================================================================
      # MARKDOWN-PREVIEW - Preview markdown files
      # ============================================================================
      markdown-preview = {
        enable = lib.mkDefault true;
        settings = {
          theme = "dark";
        };
      };

      # ============================================================================
      # UFO - Better folding
      # ============================================================================
      nvim-ufo = {
        enable = lib.mkDefault true;
      };
    };
  };
}
