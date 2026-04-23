# Termipedia - Wikipedia for the terminal
# Packages the upstream shell script as a Nix derivation.
# Source: https://github.com/kantiankant/Termipedia
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.termipedia;

  termipedia = pkgs.callPackage ./_package.nix { };
in
{
  options.modules.home.termipedia.enable = lib.mkEnableOption "termipedia CLI Wikipedia tool";

  config = lib.mkIf cfg.enable {
    home.packages = [ termipedia ];
  };
}
