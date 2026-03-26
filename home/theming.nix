# GTK, QT, and Cursor Theming
# Managed by Stylix now
{ config, pkgs, ... }:

{
  # Stylix handles all GTK, QT, and cursor theming automatically.
  # Do not add manual theme overrides here unless you want to bypass Stylix.

  # Silence GTK4 theme warning: keep legacy behavior until stateVersion >= 26.05
  gtk.gtk4.theme = config.gtk.theme;
}
