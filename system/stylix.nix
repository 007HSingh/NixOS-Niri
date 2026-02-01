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
    iconTheme = {
      enable = true;
      package = pkgs.catppuccin-papirus-folders;
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
        package = pkgs.noto-fonts;
        name = "Noto Sans";
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

    # Opacity settings (optional)
    opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 1.0;
    };

    # Target-specific Overrides
    targets = {
      # We will let Stylix handle most things automatically
      # Explicitly enable/disable as needed
      nixvim.enable = false;
      gnome.enable = false;
    };
  };
}
