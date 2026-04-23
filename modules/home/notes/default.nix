# Notes: Obsidian package + vault environment variable
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.notes;
in
{
  options.modules.home.notes.enable = lib.mkEnableOption "notes (Obsidian + OBSIDIAN_VAULT env var)";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.obsidian ];

    home.sessionVariables = {
      OBSIDIAN_VAULT = "${config.home.homeDirectory}/Documents/Obsidian";
    };
  };
}
