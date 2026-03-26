# Stylix System-wide Theming
# Single source of truth for colors, fonts, and wallpapers
{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = true;

    # Color scheme: Catppuccin Mocha
    # Can also be set to path from base16-schemes if desired
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    # Polarity must be set to either "dark" or "light"
    polarity = "dark";

    # Icon Theme
    icons = {
      enable = true;
      package = pkgs.catppuccin-papirus-folders;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    # Cursor Theme
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    # Font Configuration
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };

      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };

      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        terminal = 12;
        applications = 11;
        desktop = 11;
        popups = 11;
      };
    };

    # Opacity settings — synced with Niri per-window rules and kitty config
    opacity = {
      applications = 0.95;
      terminal = 0.85;     # matches kitty background_opacity
      desktop = 1.0;
      popups = 0.92;
    };

    # Target-specific Overrides
    targets = {
      # We will let Stylix handle most things automatically
      # Explicitly enable/disable as needed
      nixvim.enable = false;
      gnome.enable = false;
      gtk.enable = true;
    };
  };
}
