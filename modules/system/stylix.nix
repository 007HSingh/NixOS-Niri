# Stylix — system-wide base16 theming
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
    catppuccin.cache.enable = true;

    stylix.targets = {
      grub.enable = false;
      plymouth.enable = false;
      kmscon.enable = false;
    };

    catppuccin = {
      enable = true;
      autoEnable = false;
      grub = {
        enable = true;
        flavor = "mocha";
      };
      plymouth = {
        enable = true;
        flavor = "mocha";
      };
    };

    stylix = {
      enable = true;
      autoEnable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      polarity = "dark";

      icons = {
        enable = true;
        package = pkgs.catppuccin-papirus-folders;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 32;
      };

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
        terminal = 0.85;
        desktop = 1.0;
        popups = 0.92;
      };
    };
  };
}
