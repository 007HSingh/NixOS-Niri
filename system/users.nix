# User Account Definitions
{ pkgs, ... }:

{
  users.users.harsh = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Harsh Singh";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "kvm"
      "libvirtd"
    ];
    packages = with pkgs; [
      tree
    ];
  };
}
