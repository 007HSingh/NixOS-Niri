# Font Configuration
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.system.fonts;
in
{
  options.modules.system.fonts.enable = lib.mkEnableOption "system fonts (Nerd Fonts, Noto, Inter)";

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.meslo-lg
      inter # clean UI typeface, replaces Noto Sans for app chrome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      comfortaa # funky rounded display font for MPRIS widget
      font-awesome
      material-design-icons
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [
          "Inter"
          "Noto Sans"
        ]; # Inter first for UI; Noto Sans fallback
        serif = [ "Noto Serif" ];
      };
      antialias = true;
      hinting.enable = true;
      subpixel.rgba = "rgb";
    };
  };
}
