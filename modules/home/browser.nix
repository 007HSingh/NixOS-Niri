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
      configPath = "${config.xdg.configHome}/mozilla/firefox";

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          darkreader
          stylus
        ];

        search = {
          force = true;
          default = "ddg";
        };

        settings = {
          # Keep Home Manager-managed extensions enabled despite Firefox install-scope checks.
          "extensions.autoDisableScopes" = 0;
          "extensions.enabledScopes" = 5;

          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;

          "network.dns.disablePrefetch" = true;
          "network.http.speculative-parallel-limit" = 0;
          "network.prefetch-next" = false;
          "media.peerconnection.ice.default_address_only" = true;
          "privacy.clearOnShutdown_v2.formdata" = true;

          # Enable playback of DRM-protected media.
          "media.eme.enabled" = true;

          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
          "datareporting.healthreport.uploadEnabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;

          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          "sidebar.verticalTabs" = true;
          "browser.tabs.drawInTitlebar" = true;
        };

        userChrome = ''
          /* Vertical tabs replace Firefox's horizontal tab strip. */
          #TabsToolbar {
            display: none !important;
          }

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
