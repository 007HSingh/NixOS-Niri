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
  options.modules.system.fonts.enable = lib.mkEnableOption "system fonts (Maple Mono, Nunito, Noto)";

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      maple-mono.NF
      nunito
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      comfortaa
      font-awesome
      material-design-icons
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Maple Mono NF" ];
        sansSerif = [
          "Nunito"
          "Noto Sans"
        ];
        serif = [ "Noto Serif" ];
      };
      antialias = true;
      hinting.enable = true;
      subpixel.rgba = "rgb";
    };
  };
}
