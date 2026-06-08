# Noctalia Shell
{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.modules.home.noctalia;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.modules.home.noctalia.enable = lib.mkEnableOption "noctalia status bar";

  config = lib.mkIf cfg.enable {
    programs.noctalia = {
      enable = true;
      settings = ''
        [shell]
        font_family = "Inter"

        [shell.panel]
        transparency_mode = "glass"

        [wallpaper]
        enabled = true
        fill_mode = "crop"
        directory = "~/.config/wallpapers"
        transition = ["fade", "wipe", "disc", "stripes", "zoom", "honeycomb"]
        transition_duration = 1500
        transition_on_startup = true

        [wallpaper.default]
        path = "~/.config/wallpapers/wallpaper-38.png"

        [wallpaper.automation]
        enabled = false

        [backdrop]
        enabled = true

        [theme]
        mode = "dark"
        source = "builtin"
        builtin = "Catppuccin"

        [bar]
        order = ["main"]

        [bar.main]
        position = "top"
        thickness = 25
        background_opacity = 0.60
        margin_edge = 5
        margin_ends = 20
        radius = 12
        padding = 10
        widget_spacing = 10
        scale = 0.85
        capsule = false
        shadow = true
        reserve_space = true
        auto_hide = false
        start = ["control-center", "wallpaper", "network", "bluetooth", "bongo-cat", "launcher"]
        center = ["audio-visualizer", "workspaces", "clock", "media", "temperature"]
        end = ["clipboard", "caffeine","volume", "brightness", "battery", "date", "weather", "session"]

        [nightlight]
        enabled = true
        temperature_day = 6500
        temperature_night = 3000

        [location]
        address = "Kolkata, India"

        [dock]
        enabled = false

        [notification]
        layer = "overlay"
        background_opacity = 0.85
        offset_x = 15
        offset_y = 8

        [weather]
        enabled = true
        unit = "celsius"
      '';
    };
  };
}
