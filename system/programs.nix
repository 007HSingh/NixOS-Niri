# System Programs
# Programs enabled via NixOS programs.* options
{ pkgs, ... }:

{
  programs.firefox.enable = true;

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      jnoortheen.nix-ide
      github.copilot-chat
      eamodio.gitlens
    ];
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
  };

  programs.niri.enable = true;

  programs.starship.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.gpu-screen-recorder.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake /home/harsh/nixos-config#nixos";
      generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      clean = "sudo nix-collect-garbage -d";
    };
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };

  programs.dconf.enable = true;

  programs.evince.enable = true;
}
