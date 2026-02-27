{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  users.users.harsh.extraGroups = [ "libvirtd" ];

  boot.kernelModules = [ "kvm_intel" ];
}