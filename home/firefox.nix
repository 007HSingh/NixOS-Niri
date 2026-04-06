# Zen Browser Configuration
# Declarative Zen (Firefox-based) setup via Home Manager + Catppuccin Mocha userChrome.css
{ pkgs, ... }:

{
  # Stylix auto-enables the Firefox target via autoEnable = true in system/stylix.nix.
  # Disable it here since theming is handled manually via userChrome below.
  stylix.targets.firefox.enable = false;

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      # Extensions — sourced from NUR rycee's Firefox addon set
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        darkreader
        stylus
        keepassxc-browser
      ];

      # Declarative search engine
      search = {
        force = true;
        default = "ddg";
      };

      # Privacy, UX, and performance settings
      settings = {
        # Extensions: prevent Zen auto-disabling Nix-installed extensions
        "extensions.autoDisableScopes" = 0;
        "extensions.enabledScopes" = 5;

        # New tab — no sponsored/algorithmic content
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;

        # Privacy / network hardening
        "network.dns.disablePrefetch" = true;
        "network.http.speculative-parallel-limit" = 0;
        "network.prefetch-next" = false;
        "media.peerconnection.ice.default_address_only" = true;

        # DRM (Widevine) — needed for Netflix etc.
        "media.eme.enabled" = true;

        # Clear form data on shutdown
        "privacy.clearOnShutdown_v2.formdata" = true;

        # Telemetry opt-outs
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        "datareporting.healthreport.uploadEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;

        # Enable userChrome.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Vertical tabs sidebar (native feature in Zen)
        "sidebar.verticalTabs" = true;
      };
    };
  };
}
