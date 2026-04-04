# Firefox Browser Configuration
# Declarative Firefox setup via Home Manager + Catppuccin Mocha userChrome.css
{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

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

      # Privacy, UX, and performance settings
      settings = {
        # Extensions: prevent Firefox auto-disabling Nix-installed extensions
        "extensions.autoDisableScopes" = 0;
        "extensions.enabledScopes" = 5;

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

        # Vertical tabs sidebar
        "sidebar.verticalTabs" = true;
        "sidebar.main.tools" = "aivichat,syncedtabs,history";
      };

      # Catppuccin Mocha userChrome.css
      # Applied to the browser UI (toolbar, tabs, sidebar, URL bar)
      userChrome = ''
        /* ═══════════════════════════════════════════════
           Catppuccin Mocha — Firefox userChrome.css
           ═══════════════════════════════════════════════ */

        :root {
          /* Palette */
          --ctp-base:     #1e1e2e;
          --ctp-mantle:   #181825;
          --ctp-crust:    #11111b;
          --ctp-surface0: #313244;
          --ctp-surface1: #45475a;
          --ctp-surface2: #585b70;
          --ctp-overlay0: #6c7086;
          --ctp-overlay1: #7f849c;
          --ctp-text:     #cdd6f4;
          --ctp-subtext1: #bac2de;
          --ctp-subtext0: #a6adc8;
          --ctp-mauve:    #cba6f7;
          --ctp-blue:     #89b4fa;
          --ctp-lavender: #b4befe;

          /* Override Firefox LWT variables */
          --lwt-accent-color:               var(--ctp-mantle)   !important;
          --lwt-text-color:                 var(--ctp-text)      !important;
          --toolbar-bgcolor:                var(--ctp-mantle)    !important;
          --toolbar-color:                  var(--ctp-text)      !important;
          --toolbarbutton-hover-background: var(--ctp-surface0)  !important;
          --toolbarbutton-active-background:var(--ctp-surface1)  !important;
          --tab-selected-bgcolor:           var(--ctp-base)      !important;
          --tab-selected-color:             var(--ctp-text)      !important;
          --urlbar-box-bgcolor:             var(--ctp-surface0)  !important;
          --urlbar-box-focus-bgcolor:       var(--ctp-surface0)  !important;
          --urlbar-box-hover-bgcolor:       var(--ctp-surface1)  !important;
          --urlbar-box-active-bgcolor:      var(--ctp-surface1)  !important;
          --urlbar-separator-color:         var(--ctp-surface1)  !important;
          --urlbar-popup-bgcolor:           var(--ctp-base)      !important;
          --urlbar-popup-color:             var(--ctp-text)      !important;
          --input-bgcolor:                  var(--ctp-surface0)  !important;
          --input-color:                    var(--ctp-text)      !important;
          --panel-background:               var(--ctp-base)      !important;
          --panel-color:                    var(--ctp-text)      !important;
          --panel-border-color:             var(--ctp-surface0)  !important;
        }

        /* Navigator toolbox (top chrome area) */
        #navigator-toolbox {
          background-color: var(--ctp-mantle) !important;
          border-bottom: 1px solid var(--ctp-surface0) !important;
        }

        /* Tab bar */
        #TabsToolbar {
          background-color: var(--ctp-mantle) !important;
        }

        .tab-background {
          background-color: transparent !important;
          border-radius: 6px !important;
        }

        .tabbrowser-tab[selected] .tab-background {
          background-color: var(--ctp-base) !important;
          box-shadow: none !important;
        }

        .tabbrowser-tab:not([selected]):hover .tab-background {
          background-color: var(--ctp-surface0) !important;
        }

        .tab-label {
          color: var(--ctp-subtext1) !important;
        }

        .tabbrowser-tab[selected] .tab-label {
          color: var(--ctp-text) !important;
          font-weight: 500 !important;
        }

        /* URL bar */
        #urlbar-background {
          background-color: var(--ctp-surface0) !important;
          border: 1px solid var(--ctp-surface1) !important;
          border-radius: 8px !important;
        }

        #urlbar[focused] #urlbar-background {
          border-color: var(--ctp-mauve) !important;
          box-shadow: 0 0 0 1px var(--ctp-mauve) !important;
        }

        #urlbar-input {
          color: var(--ctp-text) !important;
        }

        /* Toolbar buttons */
        .toolbarbutton-1 {
          color: var(--ctp-subtext1) !important;
          border-radius: 6px !important;
        }

        .toolbarbutton-1:hover {
          background-color: var(--ctp-surface0) !important;
          color: var(--ctp-text) !important;
        }

        .toolbarbutton-1:active,
        .toolbarbutton-1[open="true"] {
          background-color: var(--ctp-surface1) !important;
        }

        /* Sidebar (vertical tabs + sidebar panel) */
        #sidebar-box {
          background-color: var(--ctp-mantle) !important;
          border-right: 1px solid var(--ctp-surface0) !important;
        }

        #sidebar {
          background-color: var(--ctp-mantle) !important;
          color: var(--ctp-text) !important;
        }

        /* Context menus & panels */
        menupopup,
        panel {
          --panel-background: var(--ctp-base) !important;
          --panel-color: var(--ctp-text) !important;
          --panel-border-color: var(--ctp-surface0) !important;
          border-radius: 8px !important;
        }

        menuitem:hover {
          background-color: var(--ctp-surface0) !important;
          color: var(--ctp-text) !important;
        }

        /* New tab button */
        #new-tab-button:hover {
          background-color: var(--ctp-surface0) !important;
          border-radius: 6px !important;
        }
      '';
    };
  };
}
