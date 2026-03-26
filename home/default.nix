# Home Manager Modules Index
# Imports all home-manager modules
{ ... }:

{
  imports = [
    ./clipboard.nix
    ./git.nix
    ./idle.nix
    ./nixvim
    ./noctalia.nix
    ./obs.nix
    ./packages.nix
    ./shell.nix
    ./spicetify.nix
    ./theming.nix
    ./vscode.nix
    ./wofi.nix
    ./xdg.nix
  ];
}
