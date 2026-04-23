# Boot Configuration
# Bootloader, kernel, plymouth, zram
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
  options.modules.system.boot.enable = lib.mkEnableOption "boot configuration (GRUB, plymouth, zram)";

  config = lib.mkIf cfg.enable {
    boot = {
      # Plymouth for graphical boot
      plymouth.enable = true;

      # Quiet boot with minimal logging
      kernelParams = [
        "quiet"
        "loglevel=3"
        "rd.systemd.show_status=0"
        "udev.log_level=3"
        "acpi_backlight=native"
      ];

      # GRUB bootloader with EFI support
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
        };
      };

      # Use latest kernel
      kernelPackages = pkgs.linuxPackages_latest;

      # Kernel tuning for responsiveness
      kernel.sysctl = {
        "vm.swappiness" = 10;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_ratio" = 10;
        "vm.dirty_background_ratio" = 5;
      };
    };

    # ZRAM swap for better memory management
    zramSwap = {
      enable = true;
      memoryPercent = 50;
      algorithm = "lz4";
      priority = 100;
    };
  };
}
