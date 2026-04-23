# User Account Definitions
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.system.users;
in
{
  options.modules.system.users.enable = lib.mkEnableOption "system user accounts";

  config = lib.mkIf cfg.enable {
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
  };
}
