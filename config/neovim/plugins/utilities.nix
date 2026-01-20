{ config, lib, ... }:

{
  programs.nixvim = {
    # ============================================================================
    # PERSISTENCE - Session management
    # ============================================================================
    plugins.persistence = {
      enable = lib.mkDefault true;
    };

    # ============================================================================
    # PROJECT - Project management
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
        auto_close = 1;
        auto_start = 0;
        browser = "firefox";
        port = "8080";
        theme = "dark";
      };
    };

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

    # ============================================================================
    # OIL - File navigation like a buffer
    # ============================================================================
    plugins.oil = {
      enable = lib.mkDefault true;
      settings = {
        columns = [ "icon" ];
        view_options = {
          show_hidden = true;
        };
      };
    };

    # ============================================================================
    # SPECTRE - Search and replace
    # ============================================================================
    plugins.spectre = {
      enable = lib.mkDefault true;
    };

    # ============================================================================
    # HARPOON - Quick file navigation
    # ============================================================================
    plugins.harpoon = {
      enable = lib.mkDefault true;
      enableTelescope = true;
    };

    # ============================================================================
    # NVIM-UFO - Better folds
    # ============================================================================
    plugins.nvim-ufo = {
      enable = lib.mkDefault true;
    };
  };
}
