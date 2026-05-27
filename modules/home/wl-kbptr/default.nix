{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.wl-kbptr;

  ctp = {
    base = "#1e1e2e";
    mantle = "#181825";
    surface0 = "#313244";
    surface1 = "#45475a";
    overlay0 = "#6c7086";
    text = "#cdd6f4";
    subtext0 = "#a6adc8";
    mauve = "#cba6f7";
    blue = "#89b4fa";
    lavender = "#b4befe";
  };
in
{
  options.modules.home.wl-kbptr.enable = lib.mkEnableOption "wl-kbptr keyboard-driven mouse pointer";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wl-kbptr ];

    xdg.configFile."wl-kbptr/config" = {
      text = ''
        hint_chars=asdfghjklqwertyuiopzxcvbnm

        font_family=Maple Mono NF
        font_size=14
        font_bold=true

        background_color=${ctp.mantle}e0

        hint_background_color=${ctp.surface0}

        hint_foreground_color=${ctp.subtext0}

        hint_active_foreground_color=${ctp.mauve}

        border_color=${ctp.mauve}
        border_width=2
        border_radius=6

        action=click
        click_button=left
      '';
    };
  };
}
