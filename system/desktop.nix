# Desktop Environment
# Display manager, compositor, portals, audio
{ pkgs, ... }:

{
  # ly display manager (TUI)
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      clock = "%c";

    };
  };

  # Disable SDDM
  services.displayManager.sddm.enable = false;

  # Keyboard layout
  services.xserver.xkb.layout = "us";

  # Libinput for touchpad/input
  services.libinput.enable = true;

  # XDG portals for Wayland integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # PipeWire audio stack
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Wayland session variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
