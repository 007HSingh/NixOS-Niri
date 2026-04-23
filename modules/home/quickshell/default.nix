# Quickshell Configuration
# Wallpaper picker and other shell widgets
{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.quickshell;
in
{
  options.modules.home.quickshell.enable = lib.mkEnableOption "quickshell (wallpaper picker)";

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
