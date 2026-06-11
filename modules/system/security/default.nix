# Security Configuration
# Polkit, sudo, doas, apparmor
{
  lib,
  config,
  pkgs,
  users,
  ...
}:

let
  cfg = config.modules.system.security;
in
{
  options.modules.system.security.enable =
    lib.mkEnableOption "security (polkit, doas, apparmor, kernel hardening)";

  config = lib.mkIf cfg.enable {
    security = {
      rtkit.enable = true;
      polkit.enable = true;
      sudo.wheelNeedsPassword = true;
      apparmor = {
        enable = true;
        killUnconfinedConfinables = true;
      };
      pam.loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
        {
          domain = "@wheel";
          item = "memlock";
          type = "soft";
          value = "65536";
        }
        {
          domain = "@wheel";
          item = "memlock";
          type = "hard";
          value = "65536";
        }
      ];

      doas = {
        enable = true;
        extraRules = map (u: {
          users = [ u ];
          keepEnv = true;
          persist = true;
        }) users;
      };
    };

    # Polkit authentication agent
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
