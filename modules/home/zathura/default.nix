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
        # Recolour (dark-mode PDF inversion) — toggle with <A-r>
        recolor = true;
        recolor-keephue = true;

        # Loading indicator
        render-loading = true;

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
