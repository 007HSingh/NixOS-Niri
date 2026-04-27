# System Programs
# Programs enabled via NixOS programs.* options
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.system.programs;
in
{
  options.modules.system.programs.enable =
    lib.mkEnableOption "system programs (niri, steam, thunar, zsh, etc.)";

  config = lib.mkIf cfg.enable {
    programs = {
      niri.enable = true;

      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };

      nix-ld.enable = true;

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
  };
}
