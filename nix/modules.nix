{ inputs, ... }:

{
  flake = {
    nixosModules = {
      all = inputs.import-tree ../modules/system;

      profile-predator = import ./profiles/predator.nix;
    };

    homeManagerModules = {
      all = inputs.import-tree ../modules/home;

      profile-harsh = import ./profiles/harsh.nix;
    };
  };
}
