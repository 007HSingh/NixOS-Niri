{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.system.desktop;
in
{
  options.modules.system.desktop.enable =
    lib.mkEnableOption "desktop environment (ly, niri, pipewire, portals)";

  config = lib.mkIf cfg.enable {
    services = {
      displayManager.ly = {
        enable = true;
        settings = {
          animation = "matrix";
          clock = "%c";
        };
      };

      xserver.xkb.layout = "us";

      libinput.enable = true;

      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        jack.enable = true;
        wireplumber.enable = true;
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config = {
        common.default = [ "gnome" ];
        niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Access" = "gtk";
          "org.freedesktop.impl.portal.Notification" = "gtk";
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
          "org.freedesktop.portal.ScreenCast" = "gnome";
          "org.freedesktop.impl.portal.Camera" = "gnome";
        };
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
  };
}
