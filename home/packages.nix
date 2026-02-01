# User Packages
# Packages installed via Home Manager
{ pkgs, stable, ... }:

{
  home.packages = with pkgs; [
    # Audio visualization
    cava
    poppler
    resvg

    # CLI tools
    eza
    bat
    ripgrep
    fd
    fzf
    lazygit
    zoxide
    unzip
    zip
    p7zip
    jq
    yq
    hyperfine
    tokei
    gnumake
    nix-index

    # Applications
    obsidian
    stable.keepassxc
    libreoffice-qt
    vesktop
    mpv

    # Wayland utilities
    wl-clipboard
    playerctl

    # Languages
    javaPackages.compiler.temurin-bin.jdk-25
    racket

    # Git tools
    git-absorb
    git-lfs
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitiytools.d";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
