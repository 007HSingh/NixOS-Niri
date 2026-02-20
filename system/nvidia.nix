# NVIDIA GPU Configuration
{ config, ... }:

{
  # X server with NVIDIA driver
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
    # Note: prime configuration is in hosts/nixos/hardware.nix
    # since bus IDs are machine-specific
  };
}
