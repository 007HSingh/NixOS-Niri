# Audio tweaks
{ pkgs, ... }:

{
  systemd.user.services.audio-volume-boost = {
    Unit = {
      Description = "Boost default audio sink volume to 150%";
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
}
