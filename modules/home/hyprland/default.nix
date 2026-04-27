# Hyprland User Configuration
{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.home.hyprland;
in
{
  options.modules.home.hyprland.enable = lib.mkEnableOption "hyprland user configuration";

  config = lib.mkIf cfg.enable {
    # We enable the Home Manager module to handle session integration,
    # but we don't let it manage the package (it's in system programs)
    # or the config file (we'll symlink it ourselves).
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
    };
  };
}
