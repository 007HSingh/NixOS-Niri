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

    # Gaming
    mangohud
    protonup-ng

    # VsCode Extensions
    (vscode-with-extensions.override {
      vscodeExtensions =
        with scode-extensions;
        [
        ]
        ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-containers";
            publisher = "ms-azuretools";
            version = "2.4.0";
            sha256 = "0q6c65qh96nl7qdmk58hm2sipcsv3xj9vvfvrvhl4w36k9zbar4q";
          }
        ];
    })
  ];
}
