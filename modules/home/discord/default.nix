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
          autoUpdateNotification = false;
          useQuickCss = true;
          plugins = {
            NoTrack.enabled = true;
            ClearURLs.enabled = true;
            MessageLinkEmbeds.enabled = true;
            GifPaste.enabled = true;
            PermissionsViewer.enabled = true;
            ShowHiddenChannels.enabled = true;
            BetterRoleContext.enabled = true;
            FakeNitro.enabled = true;
            ClientTheme.enabled = false;
          };
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
