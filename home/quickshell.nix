# Quickshell Configuration
# Wallpapers picker and other shell widgets
{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.quickshell.packages.${pkgs.system}.quickshell
  ];
}
