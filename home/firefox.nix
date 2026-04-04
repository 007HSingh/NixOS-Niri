# Firefox Browser Configuration
# Declarative Firefox setup via Home Manager + Stylix theming
{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      # Must match the actual profile directory name on disk
      # Current profile: i0jt3qf7.default → id = "default" maps to that dir
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

      # Privacy, UX, and performance settings (captured from active prefs.js)
      settings = {
        # Search
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.suggest.searches" = false;

        # New tab — no sponsored/algorithmic content
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;

        # Privacy / network hardening
        "network.dns.disablePrefetch" = true;
        "network.http.speculative-parallel-limit" = 0;
        "network.prefetch-next" = false;
        "media.peerconnection.ice.default_address_only" = true; # WebRTC IP leak

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

        # Enable userChrome.css (required for Stylix to inject its theme CSS)
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Vertical tabs sidebar (native Firefox feature)
        "sidebar.verticalTabs" = true;
        "sidebar.main.tools" = "aivichat,syncedtabs,history";
      };
    };
  };

  # Stylix themes the Firefox UI using your existing Catppuccin Mocha scheme.
  # This generates a userChrome.css that colors toolbars, tabs, sidebars, and menus.
  # Replaces Pywalfox — no daemon required.
  stylix.targets.firefox = {
    enable = true;
    profileNames = [ "default" ];
  };
}
