# Flake-parts module: NixOS Configurations
# Defines all nixosConfigurations outputs
{ inputs, ... }:

let
  lib = import ../lib { inherit inputs; };
in
{
  flake.nixosConfigurations = {
    predator = lib.mkHost {
      hostname = "predator";
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
