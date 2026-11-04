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
  options.modules.system.fonts.enable = lib.mkEnableOption "system fonts";

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      maple-mono.NF
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      comfortaa
      font-awesome
      material-design-icons
    ];

    fonts.fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      subpixel.rgba = "rgb";
    };
  };
}
