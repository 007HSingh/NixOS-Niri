# Audio tweaks
# Systemd user service that boosts the default sink volume to 200% on login
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.audio;
in
{
  options.modules.home.audio.enable =
    lib.mkEnableOption "audio tweaks (volume-boost systemd service)";

  config = lib.mkIf cfg.enable {
    systemd.user.services.audio-volume-boost = {
      Unit = {
        Description = "Boost default audio sink volume to 200%";
        After = [ "wireplumber.service" ];
        Wants = [ "wireplumber.service" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
