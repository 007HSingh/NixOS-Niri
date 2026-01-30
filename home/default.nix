# Home Manager Modules Index
# Imports all home-manager modules
{ ... }:

{
  imports = [
    ./git.nix
    ./nixvim
    ./noctalia.nix
    ./packages.nix
    ./shell.nix
    ./spicetify.nix
    ./theming.nix
    ./xdg.nix
    ./yazi.nix
    ./zathura.nix
  ];
}
