# System-wide Packages
{ pkgs, stable, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core utilities
    wget2
    git
    file
    xdg-utils
    file-roller

    # Terminal
    kitty

    # Wayland/Niri
    niri
    xwayland-satellite
    swaylock
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

    # System monitoring
    btop
    fastfetch

    # Development
    lazygit
    starship
    gh
    delta
    docker-compose
    cachix
    devenv

    # Applications
    pywalfox-native
    jetbrains.idea
    android-studio
    android-tools
    chafa
    ffmpegthumbnailer
    mediainfo
    antigravity

    # Gaming
    mangohud
    protonup-ng
  ];
}
