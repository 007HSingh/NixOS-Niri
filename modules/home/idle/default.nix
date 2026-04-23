# Idle / Auto-Lock Daemon (swayidle)
# Dims screen → locks → powers off monitors on inactivity
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.idle;
in
{
  options.modules.home.idle.enable = lib.mkEnableOption "idle management via swayidle";

  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      timeouts = [
        # 4 min: dim screen to 20% as an early warning
        {
          timeout = 240;
          command = "${pkgs.brightnessctl}/bin/brightnessctl --save set 20%";
          resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl --restore";
        }
        # 5 min: lock screen
        {
          timeout = 300;
          command = "${pkgs.niri}/bin/niri msg action spawn -- bash -c 'loginctl lock-session'";
        }
        # 8 min: power off monitors
        {
          timeout = 480;
          command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        }
      ];
      events = {
        # Lock immediately on suspend/sleep
        before-sleep = "${pkgs.niri}/bin/niri msg action spawn -- bash -c 'loginctl lock-session'";
      };
    };

    # Register swayidle with the graphical session
    systemd.user.services.swayidle = {
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
