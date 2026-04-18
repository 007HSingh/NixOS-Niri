# Home Manager Modules Index
# Imports all home-manager modules
{ ... }:

{
  imports = [
    ./audio.nix
    ./clipboard.nix
    ./firefox.nix
    ./git.nix
    ./idle.nix
    ./noctalia.nix
    ./packages.nix
    ./quickshell.nix
    ./shell.nix
    ./spicetify.nix
    ./theming.nix
    ./vscode.nix
    ./wofi.nix
    ./xdg.nix
    ./termipedia.nix
  ];
}
