# GTK decoration button removal and gtk4 theme compatibility shim.
{ lib, config, ... }:

let
  cfg = config.modules.home.theming;
in
{
  options.modules.home.theming.enable = lib.mkEnableOption "GTK window button removal";

  config = lib.mkIf cfg.enable {
    dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":";
  };
}
