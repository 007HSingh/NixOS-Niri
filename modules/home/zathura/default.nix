# Zathura — PDF/EPUB viewer
# Colors: managed by Stylix (Catppuccin Mocha, matches system theme)
# This module adds: Vim-style keybinds, UX polish, performance tuning, MIME defaults
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
        # ── Status bar ────────────────────────────────────────────────────────
        statusbar-h-padding = 8;
        statusbar-v-padding = 4;
        statusbar-basename = true; # show filename only, not full path
        statusbar-page-percent = true;
        window-title-basename = true;
        window-title-page = true;

        # ── Page / layout ─────────────────────────────────────────────────────
        pages-per-row = 1;
        first-page-column = "1:1";
        adjust-open = "best-fit";

        # ── Scroll & zoom ─────────────────────────────────────────────────────
        scroll-step = 50;
        scroll-page-aware = true;
        scroll-full-overlap = "0.1";
        zoom-step = 10;
        zoom-min = 10;
        zoom-max = 1000;

        # ── Recolour (dark-mode PDF inversion) ────────────────────────────────
        # Colors sourced from Stylix; toggle with <A-r>
        recolor = false;
        recolor-keephue = true; # preserve colour hue when inverting

        # ── UX ────────────────────────────────────────────────────────────────
        font = "Maple Mono NF 11"; # matches Stylix monospace font
        guioptions = ""; # hide all GUI chrome (menu, scrollbars, toolbar)
        incremental-search = true; # search while typing
        selection-clipboard = "clipboard"; # yank to system clipboard

        # ── Sandbox ───────────────────────────────────────────────────────────
        sandbox = "normal";
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
