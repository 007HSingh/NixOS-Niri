# Stylix System-wide Theming
# Single source of truth for colors, fonts, and wallpapers
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.modules.system.stylix;
in
{
  options.modules.system.stylix.enable =
    lib.mkEnableOption "Stylix system-wide theming (Catppuccin Mocha)";

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;

      # Color scheme: Catppuccin Mocha (defined inline)
      base16Scheme = "${inputs.catppuccin}/base16/mocha.yaml";

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
        size = 32;
      };

      # Font Configuration
      fonts = {
        monospace = {
          package = pkgs.maple-mono.NF;
          name = "Maple Mono NF";
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
        terminal = 0.85; # matches kitty background_opacity
        desktop = 1.0;
        popups = 0.92;
      };
    };
  };
}
