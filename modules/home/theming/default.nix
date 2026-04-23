# GTK, QT, and Cursor Theming
# Managed by Stylix — this module silences the GTK4 theme warning only
{ lib, config, ... }:

let
  cfg = config.modules.home.theming;
in
{
  options.modules.home.theming.enable = lib.mkEnableOption "GTK/QT theming compatibility shim";

  config = lib.mkIf cfg.enable {
    # Stylix handles all GTK, QT, and cursor theming automatically.
    # Do not add manual theme overrides here unless you want to bypass Stylix.

    # Silence GTK4 theme warning: keep legacy behavior until stateVersion >= 26.05
    gtk.gtk4.theme = config.gtk.theme;
  };
}
