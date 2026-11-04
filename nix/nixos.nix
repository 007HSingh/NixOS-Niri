{ inputs, ... }:

let
  lib = import ./lib.nix { inherit inputs; };
in
{
  flake.nixosConfigurations = {
    predator = lib.mkHost {
      hostname = "predator";
      system = "x86_64-linux";
      users = [ "harsh" ];
    };

  };
}
