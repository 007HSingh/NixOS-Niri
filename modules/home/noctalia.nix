# Noctalia Shell
{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.modules.home.noctalia;
  dotfiles = "${config.home.homeDirectory}/nixos-config/dotfiles";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.modules.home.noctalia.enable = lib.mkEnableOption "noctalia status bar";

  config = lib.mkIf cfg.enable {
    stylix.targets.noctalia.enable = false;

    programs.noctalia.enable = true;

    xdg.configFile."noctalia/config.toml".source = create_symlink "${dotfiles}/noctalia/config.toml";
  };
}
