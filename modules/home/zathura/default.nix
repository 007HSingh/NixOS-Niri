# Zathura — PDF/EPUB viewer
# Colors: explicit Catppuccin Mocha tokens (independent of Stylix base16 mapping)
# This module adds: Vim-style keybinds, full colour theming, UX polish, MIME defaults
{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.home.zathura;
in
{
  options.modules.home.zathura.enable = lib.mkEnableOption "zathura PDF viewer";

  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;

      options = {
        # ── Catppuccin Mocha colour palette ───────────────────────────────────
        # lib.mkForce required: Stylix sets these via its base16 zathura target.
        # We take full ownership of all colour values.

        # Page / viewer
        default-bg = lib.mkForce "#1e1e2e"; # base
        default-fg = lib.mkForce "#cdd6f4"; # text

        # Status bar
        statusbar-bg = lib.mkForce "#181825"; # mantle
        statusbar-fg = lib.mkForce "#a6adc8"; # subtext0

        # Input bar (command / search entry)
        inputbar-bg = lib.mkForce "#313244"; # surface0
        inputbar-fg = lib.mkForce "#cdd6f4"; # text

        # Notifications
        notification-bg = lib.mkForce "#45475a"; # surface1
        notification-fg = lib.mkForce "#cdd6f4"; # text
        notification-error-bg = lib.mkForce "#f38ba8"; # red
        notification-error-fg = lib.mkForce "#1e1e2e"; # base
        notification-warning-bg = lib.mkForce "#f9e2af"; # yellow
        notification-warning-fg = lib.mkForce "#1e1e2e"; # base

        # Completion menu
        completion-bg = lib.mkForce "#313244"; # surface0
        completion-fg = lib.mkForce "#89b4fa"; # blue
        completion-highlight-bg = lib.mkForce "#45475a"; # surface1
        completion-highlight-fg = lib.mkForce "#cdd6f4"; # text
        completion-group-bg = lib.mkForce "#181825"; # mantle
        completion-group-fg = lib.mkForce "#7f849d"; # overlay1

        # Search highlights
        highlight-color = lib.mkForce "rgba(249,226,175,0.5)"; # yellow @50%
        highlight-active-color = lib.mkForce "rgba(250,179,135,0.8)"; # peach  @80%

        # Recolour (dark-mode PDF inversion) — toggle with <A-r>
        recolor = true;
        recolor-keephue = true;
        recolor-lightcolor = lib.mkForce "#1e1e2e"; # base  → page background
        recolor-darkcolor = lib.mkForce "#cdd6f4"; # text  → page text

        # Loading indicator
        render-loading = true;
        render-loading-bg = lib.mkForce "#1e1e2e"; # base
        render-loading-fg = lib.mkForce "#89b4fa"; # blue

        # ── Status bar layout ─────────────────────────────────────────────────
        statusbar-h-padding = 10;
        statusbar-v-padding = 5;
        statusbar-basename = true; # filename only, not full path
        statusbar-page-percent = true;
        window-title-basename = true;
        window-title-page = true;

        # ── Page / layout ─────────────────────────────────────────────────────
        pages-per-row = 1;
        first-page-column = "1:1";
        adjust-open = "best-fit";

        # ── Scroll & zoom ─────────────────────────────────────────────────────
        scroll-step = 60;
        scroll-page-aware = true;
        scroll-full-overlap = "0.1";
        zoom-step = 10;
        zoom-min = 10;
        zoom-max = 1000;

        # ── UX ────────────────────────────────────────────────────────────────
        font = "Maple Mono NF 11"; # matches system monospace font
        guioptions = ""; # hide all GUI chrome
        incremental-search = true; # search while typing
        selection-clipboard = "clipboard"; # yank to system clipboard

        # ── History / persistence ─────────────────────────────────────────────
        database = "sqlite"; # persistent jump-list, bookmarks & page history

      };

      mappings = {
        # ── Navigation — Vim-style ────────────────────────────────────────────
        "j" = "scroll down";
        "k" = "scroll up";
        "h" = "scroll left";
        "l" = "scroll right";

        # Page jumps
        "J" = "navigate next";
        "K" = "navigate previous";
        "<C-d>" = "scroll half-down";
        "<C-u>" = "scroll half-up";
        "<C-f>" = "scroll full-down";
        "<C-b>" = "scroll full-up";
        "gg" = "goto top";
        "G" = "goto bottom";

        # ── Zoom ─────────────────────────────────────────────────────────────
        "+" = "zoom in";
        "-" = "zoom out";
        "a" = "adjust_window best-fit";
        "s" = "adjust_window width";

        # ── Rotation ─────────────────────────────────────────────────────────
        "r" = "rotate rotate-cw";
        "R" = "rotate rotate-ccw";

        # ── Recolour toggle ───────────────────────────────────────────────────
        "<A-r>" = "recolor";

        # ── Search ───────────────────────────────────────────────────────────
        "n" = "search forward";
        "N" = "search backward";

        # ── TOC / index ───────────────────────────────────────────────────────
        "<Tab>" = "toggle_index";

        # ── Miscellaneous ─────────────────────────────────────────────────────
        "f" = "follow"; # follow links
        "<C-r>" = "reload";
        "q" = "quit";
      };
    };

    # ── XDG MIME: make zathura the default for PDF/EPUB/DJVU/CBZ ─────────────
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "application/epub+zip" = "org.pwmt.zathura.desktop";
        "image/vnd.djvu" = "org.pwmt.zathura.desktop";
        "image/vnd.djvu+multipage" = "org.pwmt.zathura.desktop";
        "application/x-cbz" = "org.pwmt.zathura.desktop";
        "application/x-cbr" = "org.pwmt.zathura.desktop";
      };
    };
  };
}
