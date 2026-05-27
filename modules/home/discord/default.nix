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
      settings = {
        splashTheming = true;
        checkUpdates = false;
        customTitleBar = false;
        hardwareAcceleration = true;
        discordBranch = "stable";
        minimizeToTray = false;
      };
      vencord = {
        useSystem = false;
        settings = {
          notifyAboutUpdates = false;
          autoUpdate = false;
          useQuickCss = false;
        };
      };
    };

    catppuccin.vesktop = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
    };
  };
}
