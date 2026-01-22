{ config, lib, ... }:

{
  programs.nixvim = {
    # ============================================================================
    # HARPOON - File navigation
    # ============================================================================
    plugins.harpoon = {
      enable = lib.mkDefault true;
      enableTelescope = true;
    };

    # ============================================================================
    # SPECTRE - Search and replace
    # ============================================================================
    plugins.spectre = {
      enable = lib.mkDefault true;
    };

    # ============================================================================
    # OIL - File explorer
    # ============================================================================
    plugins.oil = {
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
    plugins.undotree = {
      enable = lib.mkDefault true;
      settings = {
        autoOpenDiff = true;
        focusOnToggle = true;
      };
    };

    # ============================================================================
    # PERSISTENCE - Session management
    # ============================================================================
    plugins.persistence = {
      enable = lib.mkDefault true;
    };

    # ============================================================================
    # PROJECT-NVIM - Project management
    # ============================================================================
    plugins.project-nvim = {
      enable = lib.mkDefault true;
      enableTelescope = true;
    };

    # ============================================================================
    # MARKDOWN-PREVIEW - Preview markdown files
    # ============================================================================
    plugins.markdown-preview = {
      enable = lib.mkDefault true;
      settings = {
        theme = "dark";
      };
    };

    # ============================================================================
    # UFO - Better folding
    # ============================================================================
    plugins.nvim-ufo = {
      enable = lib.mkDefault true;
    };
  };
}
