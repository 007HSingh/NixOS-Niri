# GTK decoration button removal and gtk4 theme compatibility shim.
{ lib, config, ... }:

let
  cfg = config.modules.home.theming;
in
{
  options.modules.home.theming.enable = lib.mkEnableOption "GTK window button removal and gtk4 theme compatibility";

  config = lib.mkIf cfg.enable {
    gtk = {
      # Propagates the Stylix-managed theme into the gtk4 slot to silence the
      # stateVersion >= 26.05 deprecation warning emitted by home-manager.
      gtk4.theme = config.gtk.theme;

      gtk3.extraConfig.gtk-decoration-layout = ":";
      gtk4.extraConfig.gtk-decoration-layout = ":";
    };

    # Libadwaita apps ignore gtk4 settings.ini and read the button layout
    # exclusively from dconf; this entry is required to affect those apps.
    dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":";
  };
}
