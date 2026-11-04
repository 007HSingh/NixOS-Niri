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
