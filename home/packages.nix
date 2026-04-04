# User Packages
# Packages installed via Home Manager
{ pkgs, stable, ... }:

{
  programs.nix-index-database.comma.enable = true;

  home.packages = with pkgs; [
    # Audio visualization
    poppler
    resvg

    # CLI tools
    unzip
    zip
    p7zip
    jq
    yq
    hyperfine
    tokei
    gnumake
    nixfmt

    # Applications
    obsidian
    stable.keepassxc
    discord
    mpv
    antigravity-fhs

    # Wayland utilities
    wl-clipboard
    playerctl

    # Languages
    javaPackages.compiler.temurin-bin.jdk-25
    racket
    python314
    python314Packages.pip

    # Git tools
    git-absorb
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "zen-browser";
    TERMINAL = "kitty";
    NH_FLAKE = "/home/harsh/nixos-config";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
