# NVIDIA GPU Configuration
# Note: Prime bus IDs are machine-specific and live in hosts/predator/hardware.nix
{ lib, config, ... }:

let
  cfg = config.modules.system.nvidia;
in
{
  options.modules.system.nvidia.enable = lib.mkEnableOption "NVIDIA GPU with prime sync";

  config = lib.mkIf cfg.enable {
    # X server with NVIDIA driver
    services.xserver = {
      enable = true;
      videoDrivers = [
        "modesetting"
        "nvidia"
      ];
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      nvidiaSettings = true;
    };

    specialisation.on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      hardware.nvidia.prime = {
        offload = {
          enable = lib.mkForce true;
          enableOffloadCmd = lib.mkForce true;
        };
        sync.enable = lib.mkForce false;
      };
    };
  };
}
