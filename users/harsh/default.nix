# User: harsh
# Primary user configuration combining all home modules
{ config, inputs, ... }:

{
  # Import all home modules
  imports = [
    inputs.self.homeManagerModules.profile-harsh
  ];

  sops = {
    defaultSopsFile = ../../secrets/user.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };

  # User identity and Home Manager version
  home = {
    username = "harsh";
    homeDirectory = "/home/harsh";
    # Home Manager version - DO NOT CHANGE without migration
    stateVersion = "25.11";
  };
}
