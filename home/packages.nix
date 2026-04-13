# User Packages
# Packages installed via Home Manager
{ pkgs, stable, ... }:

{
  programs.nix-index-database.comma.enable = true;

  home.packages = with pkgs; [
    # Audio visualization
    poppler
    resvg

    # Editor
    neovim

    # CLI tools
    unzip
    zip
    p7zip
    jq
    yq
    hyperfine
    tokei
    gnumake
    nix-output-monitor

    # Build tools
    gcc
    pkg-config
    pcre

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

    # ── Neovim: LSP servers ─────────────────────────────────────────────────
    nixd
    lua-language-server
    typescript-language-server
    vscode-langservers-extracted # html, css, json, eslint
    yaml-language-server
    dockerfile-language-server
    docker-compose-language-service
    pyright
    rust-analyzer
    bash-language-server
    jdt-language-server
    clang-tools
    marksman

    # ── Neovim: Formatters ──────────────────────────────────────────────────
    nixfmt
    stylua
    prettier
    black
    rustfmt
    shfmt
    kdlfmt
    google-java-format

    # ── Neovim: CLI tools (Telescope, DAP, etc.) ────────────────────────────
    ripgrep
    fd
    tree-sitter
    nodejs # required by markdown-preview.nvim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "zen-beta";
    TERMINAL = "kitty";
    NH_FLAKE = "/home/harsh/nixos-config";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
