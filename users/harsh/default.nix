# User: harsh
# Primary user configuration combining all home modules
{ ... }:

{
  # Import all home modules
  imports = [
    ../../home
  ];

  # User identity and Home Manager version
  home = {
    username = "harsh";
    homeDirectory = "/home/harsh";
    # Home Manager version - DO NOT CHANGE without migration
    stateVersion = "25.11";
  };
}
