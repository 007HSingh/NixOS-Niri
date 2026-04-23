# Networking Configuration
{
  lib,
  config,
  stable,
  ...
}:

let
  cfg = config.modules.system.networking;
in
{
  options.modules.system.networking.enable =
    lib.mkEnableOption "networking (NetworkManager, firewall)";

  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
      plugins = [
        stable.networkmanager-openvpn
      ];
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
