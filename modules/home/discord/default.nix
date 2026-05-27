# Vesktop — Discord client with Vencord
{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.home.discord;
in
{
  options.modules.home.discord.enable = lib.mkEnableOption "Vesktop (Discord via Vencord)";

  config = lib.mkIf cfg.enable {
    programs.vesktop = {
      enable = true;
    };

    catppuccin.vesktop = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
    };
  };
}
