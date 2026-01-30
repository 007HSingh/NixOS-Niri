# User: harsh
# Primary user configuration combining all home modules
{ ... }:

{
  # Import all home modules
  imports = [
    ../../home
  ];

  # User identity
  home.username = "harsh";
  home.homeDirectory = "/home/harsh";

  # Home Manager version - DO NOT CHANGE without migration
  home.stateVersion = "25.11";
}
