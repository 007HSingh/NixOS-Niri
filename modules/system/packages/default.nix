# System-wide Packages
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.system.packages;
in
{
  options.modules.system.packages.enable = lib.mkEnableOption "system-wide packages";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Core utilities
      wget2
      git
      file
      xdg-utils
      file-roller

      # Wayland
      xwayland-satellite
      wayclip
      brightnessctl
      cliphist
      wlsunset

      # Screenshots
      grim
      slurp
      swappy
      satty

      # Media
      spotify
      vlc

      # Development
      docker-compose
      cachix
      devenv
      nh
      nixd

      # Applications
      jetbrains.idea
      antigravity
      chafa
      ffmpegthumbnailer
      mediainfo
    ];
  };
}
