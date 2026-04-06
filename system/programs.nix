# System Programs
# Programs enabled via NixOS programs.* options
{ pkgs, ... }:

{
  programs = {
    niri.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;

    gpu-screen-recorder.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        clean = "sudo nix-collect-garbage -d";
      };
    };

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };

    dconf.enable = true;

    evince.enable = true;
  };
}
