# Host: predator (primary laptop — Acer Predator with Intel + NVIDIA)
{
  inputs,
  ...
}:

{
  imports = [
    ./hardware.nix
    inputs.self.nixosModules.profile-predator
  ];

  # Machine identity
  networking.hostName = "predator";

  # NixOS version - DO NOT CHANGE without migration
  system.stateVersion = "25.11";
}
