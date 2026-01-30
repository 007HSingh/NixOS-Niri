# System Services
# Blueman, power management, Docker, misc services
{ ... }:

{
  # Locale and timezone
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # Bluetooth manager
  services.blueman.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # SSD TRIM
  services.fstrim.enable = true;

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

  # Catppuccin system theming
  catppuccin = {
    enable = true;
    cache.enable = true;
  };
}
