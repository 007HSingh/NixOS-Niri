# User Packages
# Packages installed via Home Manager
{ pkgs, stable, ... }:

let
  vesktop-wrapped = pkgs.vesktop.override {
    withVencord = true;
  };
in
{
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
    nix-index

    # Applications
    obsidian
    stable.keepassxc
    vesktop-wrapped
    mpv
    libxcrypt
    glib

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
    git-lfs
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitiytools.d";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    PULSE_RUNTIME_PATH = "/run/user/1000/pulse";
    PIPEWIRE_RUNTIME_DIR = "/run/user/1000";
  };
}
