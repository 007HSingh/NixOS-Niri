# System-wide Packages
{ pkgs, ... }:

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
    wayclip
    brightnessctl
    cliphist
    wlsunset
    swww              # smooth animated wallpaper transitions

    # Screenshots
    grim
    slurp
    swappy
    satty

    # Media
    spotify
    vlc
    pwvucontrol

    # System monitoring
    btop
    fastfetch

    # Development
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
    awscli2

    # Gaming
    mangohud
    protonup-ng
  ];
}
