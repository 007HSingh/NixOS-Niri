# Host: nixos (primary laptop)
# This is the main configuration for this specific machine
{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware.nix
  ];

  # Machine identity
  networking.hostName = "nixos";

  # NixOS version - DO NOT CHANGE without migration
  system.stateVersion = "25.11";

  # Noctalia shell package (system-level)
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
