# Quickshell Configuration
# Wallpapers picker and other shell widgets
{ inputs, pkgs, ... }:

let
  # Override quickshell to include QtMultimedia for video wallpaper preview support
  quickshellWithQtMultimedia =
    inputs.quickshell.packages.${pkgs.system}.quickshell.overrideAttrs
      (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.qt6.qtmultimedia ];
        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.qt6.qtmultimedia ];
      });
in
{
  home.packages = [ quickshellWithQtMultimedia ];
}
