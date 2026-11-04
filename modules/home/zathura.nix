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
    stylix.targets.zathura.enable = false;

    catppuccin.zathura = {
      enable = true;
      flavor = "mocha";
    };

    programs.zathura = {
      enable = true;

      options = {
        recolor = true;
        recolor-keephue = true;

        render-loading = true;

        statusbar-h-padding = 10;
        statusbar-v-padding = 5;
        statusbar-basename = true;
        statusbar-page-percent = true;
        window-title-basename = true;
        window-title-page = true;

        pages-per-row = 1;
        first-page-column = "1:1";
        adjust-open = "best-fit";

        scroll-step = 60;
        scroll-page-aware = true;
        scroll-full-overlap = "0.1";
        zoom-step = 10;
        zoom-min = 10;
        zoom-max = 1000;

        font = "Maple Mono NF 11";
        guioptions = "";
        incremental-search = true;
        selection-clipboard = "clipboard";

        database = "sqlite";

      };

      mappings = {
        "j" = "scroll down";
        "k" = "scroll up";
        "h" = "scroll left";
        "l" = "scroll right";

        "J" = "navigate next";
        "K" = "navigate previous";
        "<C-d>" = "scroll half-down";
        "<C-u>" = "scroll half-up";
        "<C-f>" = "scroll full-down";
        "<C-b>" = "scroll full-up";
        "gg" = "goto top";
        "G" = "goto bottom";

        "+" = "zoom in";
        "-" = "zoom out";
        "a" = "adjust_window best-fit";
        "s" = "adjust_window width";

        "r" = "rotate rotate-cw";
        "R" = "rotate rotate-ccw";

        "<A-r>" = "recolor";

        "n" = "search forward";
        "N" = "search backward";

        "<Tab>" = "toggle_index";

        "f" = "follow";
        "<C-r>" = "reload";
        "q" = "quit";
      };
    };

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
