# Stylix System-wide Theming
# Single source of truth for colors, fonts, and wallpapers
{
  lib,
  config,
  pkgs,
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
      base16Scheme = {
        base00 = "1e1e2e"; # bg
        base01 = "313244"; # surface0
        base02 = "45475a"; # surface1
        base03 = "585b70"; # surface2
        base04 = "6c7086"; # overlay0
        base05 = "cdd6f4"; # text
        base06 = "f5f5f5"; # rosewater
        base07 = "ffffff"; # white
        base08 = "f38ba8"; # red
        base09 = "fab387"; # peach
        base0A = "f9e2af"; # yellow
        base0B = "a6e3a1"; # green
        base0C = "94e2d5"; # teal
        base0D = "89b4fa"; # blue
        base0E = "cba6f7"; # mauve
        base0F = "f2cdcd"; # flamingo
      };

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

      # Target-specific Overrides
      targets = {
        # We will let Stylix handle most things automatically
        # Explicitly enable/disable as needed
        nixvim.enable = false;
        gnome.enable = false;
        gtk.enable = true;
      };
    };
  };
}
