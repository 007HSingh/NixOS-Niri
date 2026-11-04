{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.system.boot;
in
{
  options.modules.system.boot.enable = lib.mkEnableOption "boot configuration";

  config = lib.mkIf cfg.enable {
    boot = {
      plymouth.enable = true;

      kernelParams = [
        "quiet"
        "loglevel=3"
        "rd.systemd.show_status=0"
        "udev.log_level=3"
        "acpi_backlight=native"
      ];

      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
          configurationLimit = 10;
        };
      };

      kernelPackages = pkgs.linuxPackages_latest;

      kernel.sysctl = {
        "vm.swappiness" = 10;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_ratio" = 10;
        "vm.dirty_background_ratio" = 5;
      };

      blacklistedKernelModules = [ "uvcvideo" ];
    };
  };
}
