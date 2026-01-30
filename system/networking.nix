# Networking Configuration
{ stable, ... }:

{
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
}
