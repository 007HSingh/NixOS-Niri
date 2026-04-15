# System Services
# Blueman, power management, Docker, misc services
{ pkgs, ... }:

{
  # Locale and timezone
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # Bluetooth manager, power management, SSD TRIM, and other services
  services = {
    blueman.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    udisks2.enable = true;
    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
    };
  };

  # Memory-management
  systemd.oomd.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      experimental = true;
      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ];
    };
  };
}
