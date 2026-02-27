# System Modules Index
# Imports all system-wide NixOS modules
{ ... }:

{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./fonts.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./nvidia.nix
    ./packages.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./stylix.nix
    ./users.nix
    ./vm.nix
  ];
}
