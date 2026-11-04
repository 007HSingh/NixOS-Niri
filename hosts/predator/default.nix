{
  inputs,
  ...
}:

{
  imports = [
    ./hardware.nix
    inputs.self.nixosModules.profile-predator
  ];

  networking.hostName = "predator";

  system.stateVersion = "25.11";
}
