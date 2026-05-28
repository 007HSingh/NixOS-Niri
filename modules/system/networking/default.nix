# Networking Configuration
{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.system.networking;
in
{
  options.modules.system.networking.enable =
    lib.mkEnableOption "networking (NetworkManager, firewall)";

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      nftables.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
        logRefusedConnections = true;
        logRefusedUnicastsOnly = true;
        rejectPackets = true;
        allowPing = true;
        pingLimit = "--limit 1/second --limit-burst 5";
      };
    };
  };
}
