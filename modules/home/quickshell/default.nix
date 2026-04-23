# Quickshell Configuration
# Wallpaper picker and other shell widgets
# Override quickshell to include QtMultimedia for video wallpaper preview support
{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.quickshell;

  quickshellWithQtMultimedia =
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell.overrideAttrs
      (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.qt6.qtmultimedia ];
        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.qt6.qtmultimedia ];
      });
in
{
  options.modules.home.quickshell.enable =
    lib.mkEnableOption "quickshell (wallpaper picker, QtMultimedia)";

  config = lib.mkIf cfg.enable {
    home.packages = [ quickshellWithQtMultimedia ];
  };
}
