{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.system.services;
in
{
  options.modules.system.services.enable = lib.mkEnableOption "system services";

  config = lib.mkIf cfg.enable {
    time.timeZone = "Asia/Kolkata";
    i18n.defaultLocale = "en_US.UTF-8";

    services = {
      blueman.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
      fstrim.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
      udisks2.enable = true;
      gnome.gnome-keyring.enable = true;
    };

    systemd.oomd.enable = true;

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };
}
