# Flake-parts module: NixOS Configurations
# Defines all nixosConfigurations outputs
{ inputs, ... }:

let
  lib = import ../lib { inherit inputs; };
in
{
  # nixosConfigurations is a flake-level output (not perSystem)
  flake.nixosConfigurations = {
    # Primary laptop configuration
    nixos = lib.mkHost {
      hostname = "nixos";
      system = "x86_64-linux";
      users = [ "harsh" ];
    };

    # To add a new host, copy the pattern above:
    # <hostname> = lib.mkHost {
    #   hostname = "<hostname>";
    #   system = "x86_64-linux";
    #   users = [ "harsh" ];
    # };
  };
}
