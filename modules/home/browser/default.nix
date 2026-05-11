# Zen Browser Configuration
# Declarative Zen (Firefox-based) setup via Home Manager
# CSS fully managed here — Stylix zen-browser target disabled in favour of hand-crafted
# Catppuccin Mocha theming with animations, blur, and sidebar polish.
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
  options.modules.home.browser.enable = lib.mkEnableOption "Zen browser (Firefox-based)";

  config = lib.mkIf cfg.enable {
    # Disable Stylix's auto-generated CSS — we own userChrome/userContent fully
    stylix.targets.firefox.enable = false;
    stylix.targets.zen-browser.enable = false;

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

          # Hide title bar buttons (Zen/Firefox)
          "browser.tabs.drawInTitlebar" = true;
        };

        # ── userChrome.css ───────────────────────────────────────────────────
        # Full Catppuccin Mocha theming with animations, sidebar transitions,
        # pill tabs, blur effects, scrollbar polish, and compact URL bar.
        userChrome = ''
          /* ═══════════════════════════════════════════════════════════════
             Zen Browser — Catppuccin Mocha userChrome
             Managed declaratively via Nix home-manager
             ═══════════════════════════════════════════════════════════════ */

          /* ── 1. Catppuccin Mocha Design Tokens ──────────────────────── */
          :root {
            --ctp-base:      #1e1e2e;
            --ctp-mantle:    #181825;
            --ctp-crust:     #11111b;
            --ctp-surface0:  #313244;
            --ctp-surface1:  #45475a;
            --ctp-surface2:  #585b70;
            --ctp-overlay0:  #6c7086;
            --ctp-overlay1:  #7f849d;
            --ctp-overlay2:  #9399b2;
            --ctp-text:      #cdd6f4;
            --ctp-subtext1:  #bac2de;
            --ctp-subtext0:  #a6adc8;
            --ctp-blue:      #89b4fa;
            --ctp-lavender:  #b4befe;
            --ctp-mauve:     #cba6f7;
            --ctp-pink:      #f5c2e7;
            --ctp-red:       #f38ba8;
            --ctp-maroon:    #eba0ac;
            --ctp-peach:     #fab387;
            --ctp-yellow:    #f9e2af;
            --ctp-green:     #a6e3a1;
            --ctp-teal:      #94e2d5;
            --ctp-sky:       #89dceb;
            --ctp-sapphire:  #74c7ec;
            --ctp-flamingo:  #f2cdcd;
            --ctp-rosewater: #f5e0dc;

            /* ── Zen variable mappings ── */
            --zen-colors-primary:                  var(--ctp-surface1) !important;
            --zen-primary-color:                   var(--ctp-blue) !important;
            --zen-colors-secondary:                var(--ctp-surface1) !important;
            --zen-colors-tertiary:                 var(--ctp-surface0) !important;
            --zen-colors-border:                   color-mix(in srgb, var(--ctp-surface2) 60%, transparent) !important;

            /* ── Text ── */
            --lwt-text-color:                      var(--ctp-text) !important;
            --toolbar-field-color:                 var(--ctp-text) !important;
            --tab-selected-textcolor:              var(--ctp-text) !important;
            --toolbar-field-focus-color:           var(--ctp-text) !important;
            --toolbar-color:                       var(--ctp-text) !important;
            --newtab-text-primary-color:           var(--ctp-text) !important;
            --arrowpanel-color:                    var(--ctp-text) !important;
            --sidebar-text-color:                  var(--ctp-text) !important;
            --lwt-sidebar-text-color:              var(--ctp-text) !important;
            --toolbarbutton-icon-fill:             var(--ctp-subtext1) !important;

            /* ── Backgrounds ── */
            --arrowpanel-background:               var(--ctp-surface0) !important;
            --toolbar-bgcolor:                     var(--ctp-mantle) !important;
            --newtab-background-color:             var(--ctp-base) !important;
            --zen-themed-toolbar-bg:               var(--ctp-mantle) !important;
            --zen-main-browser-background:         var(--ctp-base) !important;
            --toolbox-bgcolor-inactive:            var(--ctp-surface0) !important;
            --zen-themed-toolbar-bg-transparent:   var(--ctp-surface0) !important;
            --lwt-sidebar-background-color:        var(--ctp-mantle) !important;

            /* ── Panels ── */
            --arrowpanel-border-color:             var(--ctp-surface2) !important;
            --arrowpanel-border-radius:            12px !important;
            --panel-shadow-margin:                 8px !important;

            /* ── Rounding & Motion ── */
            --toolbarbutton-border-radius:         8px !important;
            --zen-transition-speed:                180ms;
            --zen-transition-ease:                 cubic-bezier(0.4, 0, 0.2, 1);
          }

          /* ── 2. Workspace text ───────────────────────────────────────── */
          zen-workspace {
            --toolbox-textcolor: var(--ctp-text) !important;
          }

          /* ── 3. Sidebar ──────────────────────────────────────────────── */
          #sidebar-box {
            background-color: var(--ctp-mantle) !important;
            transition: width var(--zen-transition-speed) var(--zen-transition-ease) !important;
            border-right: 1px solid color-mix(in srgb, var(--ctp-surface2) 40%, transparent) !important;
          }
          .sidebar-placesTree {
            background-color: var(--ctp-mantle) !important;
          }

          /* ── 4. URL Bar ──────────────────────────────────────────────── */
          .urlbar-background {
            background-color: var(--ctp-surface0) !important;
            border-radius: 10px !important;
            border: 1px solid color-mix(in srgb, var(--ctp-surface2) 70%, transparent) !important;
            transition:
              border-color var(--zen-transition-speed) var(--zen-transition-ease),
              box-shadow   var(--zen-transition-speed) var(--zen-transition-ease) !important;
          }
          #urlbar[focused] .urlbar-background {
            border-color: var(--ctp-mauve) !important;
            box-shadow: 0 0 0 2px color-mix(in srgb, var(--ctp-mauve) 25%, transparent) !important;
          }
          .urlbarView-url {
            color: var(--ctp-blue) !important;
          }
          #urlbar-input::selection {
            background-color: var(--ctp-mauve) !important;
            color: var(--ctp-base) !important;
          }

          /* ── 5. Toolbar Buttons ──────────────────────────────────────── */
          toolbar .toolbarbutton-1 {
            border-radius: var(--toolbarbutton-border-radius) !important;
            transition:
              background-color var(--zen-transition-speed) var(--zen-transition-ease),
              color            var(--zen-transition-speed) var(--zen-transition-ease) !important;
          }
          toolbar .toolbarbutton-1:hover
            > :is(.toolbarbutton-icon, .toolbarbutton-text, .toolbarbutton-badge-stack) {
            color: var(--ctp-blue) !important;
            fill:  var(--ctp-blue) !important;
          }
          toolbar .toolbarbutton-1:not([disabled]):is([open],[checked])
            > :is(.toolbarbutton-icon, .toolbarbutton-text, .toolbarbutton-badge-stack) {
            fill: var(--ctp-base) !important;
          }

          /* ── 6. Workspaces Button ────────────────────────────────────── */
          #zen-workspaces-button {
            background-color: transparent !important;
            border-radius: 8px !important;
            transition: background-color var(--zen-transition-speed) var(--zen-transition-ease) !important;
          }
          #zen-workspaces-button:hover {
            background-color: color-mix(in srgb, var(--ctp-blue) 15%, transparent) !important;
          }

          /* ── 7. Tabs — pill indicator, fade close button ─────────────── */
          .tab-line {
            border-radius: 2px !important;
            background-color: var(--ctp-mauve) !important;
          }
          .tab-close-button {
            opacity: 0 !important;
            transition: opacity var(--zen-transition-speed) var(--zen-transition-ease) !important;
          }
          .tabbrowser-tab:hover .tab-close-button {
            opacity: 1 !important;
          }

          /* ── 8. Arrow Panels / Dropdowns — blur glass ────────────────── */
          .panel-arrowcontent {
            background-color: var(--ctp-surface0) !important;
            backdrop-filter: blur(12px) !important;
            -moz-backdrop-filter: blur(12px) !important;
            border-radius: 12px !important;
            border: 1px solid color-mix(in srgb, var(--ctp-surface2) 60%, transparent) !important;
            box-shadow: 0 8px 32px color-mix(in srgb, var(--ctp-crust) 60%, transparent) !important;
          }

          /* ── 9. Toolbar backgrounds ──────────────────────────────────── */
          #zen-toolbar-background {
            --zen-main-browser-background-toolbar: var(--ctp-mantle) !important;
          }
          #zen-browser-background {
            --zen-main-browser-background: var(--ctp-base) !important;
          }

          /* ── 10. Media controls ──────────────────────────────────────── */
          #zen-media-controls-toolbar #zen-media-progress-bar::-moz-range-track {
            background: var(--ctp-surface1) !important;
          }
          #zen-media-controls-toolbar #zen-media-progress-bar::-moz-range-progress {
            background: var(--ctp-blue) !important;
          }
          #zen-media-controls-toolbar #zen-media-progress-bar::-moz-range-thumb {
            background: var(--ctp-lavender) !important;
          }

          /* ── 11. Thin scrollbar ──────────────────────────────────────── */
          scrollbar { width: 6px !important; height: 6px !important; }
          scrollbar thumb {
            background-color: var(--ctp-surface2) !important;
            border-radius: 4px !important;
          }
          scrollbar thumb:hover {
            background-color: var(--ctp-overlay1) !important;
          }
          scrollbar track { background-color: transparent !important; }

          /* ── 12. Bookmarks panel ─────────────────────────────────────── */
          #zenEditBookmarkPanelFaviconContainer {
            background: var(--ctp-surface0) !important;
            border-radius: 8px !important;
          }

          /* ── 13. Swipe arrows ────────────────────────────────────────── */
          #historySwipeAnimationPreviousArrow,
          #historySwipeAnimationNextArrow {
            --swipe-nav-icon-primary-color: var(--ctp-blue) !important;
            --swipe-nav-icon-accent-color:  var(--ctp-base) !important;
          }

          /* ── 14. Permissions icon ────────────────────────────────────── */
          #permissions-granted-icon { color: var(--ctp-text) !important; }

          /* ── 15. Dialog boxes ────────────────────────────────────────── */
          #commonDialog {
            background-color: var(--ctp-surface0) !important;
            border-radius: 12px !important;
            border: 1px solid var(--ctp-surface2) !important;
          }

          /* ── 16. Context menus ───────────────────────────────────────── */
          menu, menuitem, menupopup { color: var(--ctp-text) !important; }
          menupopup {
            background-color: var(--ctp-surface0) !important;
            border-radius: 10px !important;
            border: 1px solid var(--ctp-surface2) !important;
            box-shadow: 0 4px 20px color-mix(in srgb, var(--ctp-crust) 50%, transparent) !important;
            padding: 4px !important;
          }
          menuitem:hover {
            background-color: var(--ctp-surface1) !important;
            border-radius: 6px !important;
          }

          /* ── 17. Content shortcuts ───────────────────────────────────── */
          .content-shortcuts {
            background-color: var(--ctp-surface0) !important;
            border: 1px solid color-mix(in srgb, var(--ctp-surface2) 60%, transparent) !important;
            border-radius: 10px !important;
          }

          /* ── 18. Container / identity tab colors ─────────────────────── */
          .identity-color-blue      { --identity-tab-color: #89b4fa !important; --identity-icon-color: #89b4fa !important; }
          .identity-color-turquoise { --identity-tab-color: #94e2d5 !important; --identity-icon-color: #94e2d5 !important; }
          .identity-color-green     { --identity-tab-color: #a6e3a1 !important; --identity-icon-color: #a6e3a1 !important; }
          .identity-color-yellow    { --identity-tab-color: #f9e2af !important; --identity-icon-color: #f9e2af !important; }
          .identity-color-orange    { --identity-tab-color: #fab387 !important; --identity-icon-color: #fab387 !important; }
          .identity-color-red       { --identity-tab-color: #f38ba8 !important; --identity-icon-color: #f38ba8 !important; }
          .identity-color-pink      { --identity-tab-color: #cba6f7 !important; --identity-icon-color: #cba6f7 !important; }
          .identity-color-purple    { --identity-tab-color: #f2cdcd !important; --identity-icon-color: #f2cdcd !important; }
        '';

        # ── userContent.css ──────────────────────────────────────────────────
        # Themes all about:* internal pages consistently with Catppuccin Mocha.
        userContent = ''
          /* ═══════════════════════════════════════════════════════════════
             Zen Browser — Catppuccin Mocha userContent
             Managed declaratively via Nix home-manager
             ═══════════════════════════════════════════════════════════════ */

          /* ── Global selection ───────────────────────────────────────── */
          ::selection {
            background-color: color-mix(in srgb, #cba6f7 40%, transparent) !important;
            color: #cdd6f4 !important;
          }

          /* ── All about: pages ───────────────────────────────────────── */
          @-moz-document url-prefix("about:") {
            :root {
              --in-content-page-color:       #cdd6f4 !important;
              --color-accent-primary:        #89b4fa !important;
              --color-accent-primary-hover:  #b4befe !important;
              --color-accent-primary-active: #cba6f7 !important;
              --in-content-page-background:  #1e1e2e !important;
              background-color:              #1e1e2e !important;
            }
          }

          /* ── about:newtab / about:home ──────────────────────────────── */
          @-moz-document url("about:newtab"), url("about:home") {
            :root {
              --newtab-background-color:            #1e1e2e !important;
              --newtab-background-color-secondary:  #313244 !important;
              --newtab-element-hover-color:         #45475a !important;
              --newtab-text-primary-color:          #cdd6f4 !important;
              --newtab-wordmark-color:              #cdd6f4 !important;
              --newtab-primary-action-background:   #89b4fa !important;
            }
            .icon { color: #89b4fa !important; }
            .search-wrapper .logo-and-wordmark .logo {
              display: inline-block !important;
              height: 82px !important;
              width: 82px !important;
              background-size: 82px !important;
            }
            @media (max-width: 609px) {
              .search-wrapper .logo-and-wordmark .logo {
                background-size: 64px !important;
                height: 64px !important;
                width: 64px !important;
              }
            }
            .card-outer:is(:hover,:focus,.active):not(.placeholder) .card-title {
              color: #89b4fa !important;
            }
            .top-site-outer .search-topsite { background-color: #89b4fa !important; }
            .compact-cards .card-outer .card-context .card-context-icon.icon-download {
              fill: #a6e3a1 !important;
            }
          }

          /* ── about:preferences ──────────────────────────────────────── */
          @-moz-document url-prefix("about:preferences") {
            :root {
              --zen-colors-tertiary:              #313244 !important;
              --in-content-text-color:            #cdd6f4 !important;
              --link-color:                       #89b4fa !important;
              --link-color-hover:                 #b4befe !important;
              --zen-colors-primary:               #45475a !important;
              --in-content-box-background:        #313244 !important;
              --in-content-box-background-hover:  #45475a !important;
              --zen-primary-color:                #89b4fa !important;
              --in-content-page-background:       #1e1e2e !important;
            }
            groupbox, moz-card {
              background: #1e1e2e !important;
              border-radius: 10px !important;
            }
            button, groupbox menulist {
              background: #45475a !important;
              color: #cdd6f4 !important;
              border-radius: 6px !important;
            }
            .main-content { background-color: #1e1e2e !important; }
          }

          /* ── about:addons ───────────────────────────────────────────── */
          @-moz-document url-prefix("about:addons") {
            :root {
              --zen-dark-color-mix-base: #313244 !important;
              --background-color-box:    #1e1e2e !important;
              --color-accent-primary:    #89b4fa !important;
            }
          }

          /* ── about:protections ──────────────────────────────────────── */
          @-moz-document url-prefix("about:protections") {
            :root {
              --zen-primary-color:      #1e1e2e !important;
              --social-color:           #cba6f7 !important;
              --coockie-color:          #89b4fa !important;
              --fingerprinter-color:    #f9e2af !important;
              --cryptominer-color:      #f2cdcd !important;
              --tracker-color:          #a6e3a1 !important;
              --in-content-primary-button-background:       #45475a !important;
              --in-content-primary-button-text-color:       #cdd6f4 !important;
              --in-content-primary-button-background-hover: #585b70 !important;
              --in-content-primary-button-text-color-hover: #cdd6f4 !important;
            }
            .card {
              background-color: #313244 !important;
              border-radius: 10px !important;
            }
          }
        '';
      };
    };
  };
}
