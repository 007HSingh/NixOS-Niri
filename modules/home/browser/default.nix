# Zen Browser — Stylix disabled, CSS theming managed inline
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.browser;
in
{
  options.modules.home.browser.enable = lib.mkEnableOption "Firefox browser";

  config = lib.mkIf cfg.enable {
    stylix.targets.firefox.enable = false;

    catppuccin.firefox = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
      force = true;
    };

    programs.firefox = {
      enable = true;
      package = pkgs.firefox;

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        # Extensions
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          darkreader
          stylus
        ];

        # Search
        search = {
          force = true;
          default = "ddg";
        };

        # Preferences
        settings = {
          # Prevent Firefox from auto-disabling Nix-installed extensions
          "extensions.autoDisableScopes" = 0;
          "extensions.enabledScopes" = 5;

          # New Tab clutter
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;

          # Privacy
          "network.dns.disablePrefetch" = true;
          "network.http.speculative-parallel-limit" = 0;
          "network.prefetch-next" = false;
          "media.peerconnection.ice.default_address_only" = true;
          "privacy.clearOnShutdown_v2.formdata" = true;

          # Widevine (Netflix, Spotify Web, etc.)
          "media.eme.enabled" = true;

          # Telemetry
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
          "datareporting.healthreport.uploadEnabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;

          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Vertical tabs and titlebar integration
          "sidebar.verticalTabs" = true;
          "browser.tabs.drawInTitlebar" = true;
        };

        userChrome = ''
          /* Hide horizontal tab bar when vertical sidebar tabs are active */
          #TabsToolbar {
            display: none !important;
          }

          /* Thin scrollbar to match the system aesthetic */
          scrollbar { width: 6px !important; height: 6px !important; }
          scrollbar thumb {
            background-color: #585b70 !important;
            border-radius: 4px !important;
          }
          scrollbar thumb:hover { background-color: #7f849c !important; }
          scrollbar track        { background-color: transparent !important; }
        '';
      };
    };
  };
}
