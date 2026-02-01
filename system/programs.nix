# System Programs
# Programs enabled via NixOS programs.* options
{ pkgs, ... }:

{
  programs.firefox.enable = true;

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
    autosuggestions = {
      enable = true;
      async = true;
    };
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "starship"
        "colored-man-pages"
        "docker"
        "kubectl"
      ];
    };
    shellAliases = {
      ls = "eza -la --icons";
      cat = "bat";
      update = "sudo nixos-rebuild switch --flake /home/harsh/nixos-config#nixos";
      generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      clean = "sudo nix-collect-garbage -d";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };

  programs.file-roller.enable = true;
}
