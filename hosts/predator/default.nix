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

  # This is the install-era compatibility baseline, not the current release.
  system.stateVersion = "25.11";
}
