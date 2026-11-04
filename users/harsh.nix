{ config, inputs, ... }:

{
  imports = [
    inputs.self.homeManagerModules.profile-harsh
  ];

  sops = {
    defaultSopsFile = ../secrets/user.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };

  home = {
    username = "harsh";
    homeDirectory = "/home/harsh";
    stateVersion = "25.11";
  };
}
