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
    p7zip
    jq
    yq
    hyperfine
    tokei
    gnumake
    nix-index

    # Development
    gcc
    nil
    lua-language-server
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
    dockerfile-language-server
    docker-compose-language-service
    tree-sitter
    rust-analyzer
    pyright
    bash-language-server
    jdt-language-server
    clang-tools
    marksman

    # Formatters
    nixfmt
    stylua
    prettier
    black
    rustfmt
    shfmt

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

    google-chrome
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
