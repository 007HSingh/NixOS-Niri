# Noctalia Shell
{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.modules.home.bar;
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
        avatar_path = "~/.face"

        [shell.panel]
        transparency_mode = "glass"

        [wallpaper]
        enabled = true
        fill_mode = "crop"
        directory = "~/Pictures/Wallpapers"
        transition = ["fade", "wipe", "disc", "stripes", "zoom", "honeycomb"]
        transition_duration = 1500

        [wallpaper.automation]
        enabled = false

        [backdrop]
        enabled = false

        [theme]
        mode = "dark"
        source = "builtin"
        builtin = "Catppuccin"

        [bar.main]
        position = "left"
      '';
    };
  };
}
