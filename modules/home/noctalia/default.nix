# Noctalia Shell
{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.modules.home.noctalia;
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.modules.home.noctalia.enable = lib.mkEnableOption "noctalia status bar";

  config = lib.mkIf cfg.enable {
    stylix.targets.noctalia.enable = false;

    programs.noctalia = {
      enable = true;
      settings = "${dotfiles}/noctalia/config.toml";
    };
  };
}
