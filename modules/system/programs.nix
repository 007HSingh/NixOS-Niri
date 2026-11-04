{
  lib,
  config,
  pkgs,
  flakePath,
  ...
}:

let
  cfg = config.modules.system.programs;
in
{
  options.modules.system.programs.enable =
    lib.mkEnableOption "system programs (niri, thunar, zsh)";

  config = lib.mkIf cfg.enable {
    programs = {
      niri = {
        enable = true;
      };

      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 1";
        };
        flake = flakePath;
      };

      nix-ld.enable = true;

      gpu-screen-recorder.enable = true;

      zsh = {
        enable = true;
        shellAliases = {
          generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
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
    };
  };
}
