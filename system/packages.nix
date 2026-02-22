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
        with vscode-extensions;
        [
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          jnoortheen.nix-ide
          ms-python.vscode-pylance
          ms-python.python
          ms-python.debugpy
          ms-python.flake8
          ms-vscode.cpptools-extension-pack
          redhat.java
          vscjava.vscode-java-pack
          vscjava.vscode-spring-initializr
          ms-vscode-remote.remote-containers
          docker.docker
          ms-azuretools.vscode-docker
          eamodio.gitlens
        ]
        ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-containers";
            publisher = "ms-azuretools";
            version = "2.4.1";
            sha256 = "02zqkdxazzppmj7pg9g0633fn1ima2qrb4jpb6pwir5maljlj31v";
          }
          {
            name = "copilot-chat";
            publisher = "Github";
            version = "0.37";
            sha256 = "0fzrw766g7ssjgjwb8j406s6yy89l6x5708ncdryshnpqvvvd66p";
          }
        ];
    })
  ];
}
