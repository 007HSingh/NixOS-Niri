# Desktop Environment
# Display manager, compositor, portals, audio
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
    # Display manager, keyboard, input, and audio services
    services = {
      # ly display manager (TUI)
      displayManager.ly = {
        enable = true;
        settings = {
          animation = "matrix";
          clock = "%c";
        };
      };

      # Disable SDDM
      displayManager.sddm.enable = false;

      # Keyboard layout
      xserver.xkb.layout = "us";

      # Libinput for touchpad/input
      libinput.enable = true;

      # PipeWire audio stack
      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        jack.enable = true;
        wireplumber.enable = true;
      };
    };

    # XDG portals for Wayland integration
    # Note: wlr portal NOT used — Niri is Smithay-based, not Wlroots.
    # GTK portal handles file pickers; GNOME portal provides the screencast UI.
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    # Wayland session variables
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
