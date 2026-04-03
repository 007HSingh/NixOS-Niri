# System Modules Index
# Imports all system-wide NixOS modules
# Note: nvidia.nix lives in hosts/<hostname>/ — it is machine-specific, not universal.
{ ... }:

{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./fonts.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./stylix.nix
    ./users.nix
    ./vm.nix
  ];
}
