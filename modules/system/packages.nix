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
    nixpkgs.config.android_sdk.accept_license = true;

    environment.systemPackages = with pkgs; [
      wget2
      git
      file
      xdg-utils
      file-roller
      ddcutil
      ddcutil-service

      xwayland-satellite
      wayclip
      brightnessctl
      cliphist
      wlsunset
      grim
      slurp
      swappy
      satty

      cachix
      devenv
      podman-compose

      jetbrains.idea
      android-studio
      postman
      chafa
      ffmpegthumbnailer
      mediainfo
    ];
  };
}
