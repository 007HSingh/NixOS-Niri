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
    boot.kernel.sysctl = {
      "net.ipv4.conf.all.accept_redirects" = false;
      "net.ipv4.conf.default.accept_redirects" = false;
      "net.ipv6.conf.all.accept_redirects" = false;
      "net.ipv6.conf.default.accept_redirects" = false;
      "net.ipv4.conf.all.send_redirects" = false;
      "net.ipv4.conf.default.send_redirects" = false;
      "net.ipv4.conf.all.accept_source_route" = false;
      "net.ipv4.conf.default.accept_source_route" = false;
      "net.ipv6.conf.all.accept_source_route" = false;
      "net.ipv6.conf.default.accept_source_route" = false;
      "net.ipv4.icmp_ignore_bogus_error_responses" = true;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.tcp_syncookies" = true;
      "net.ipv4.tcp_max_syn_backlog" = 4096;

      "kernel.yama.ptrace_scope" = 1;
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.sysrq" = 1;
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.bpf_jit_harden" = 2;
      "kernel.perf_event_paranoid" = 2;
      "fs.suid_dumpable" = 0;
      "kernel.randomize_va_space" = 2;
      "fs.protected_symlinks" = 1;
      "fs.protected_hardlinks" = 1;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
    };

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
