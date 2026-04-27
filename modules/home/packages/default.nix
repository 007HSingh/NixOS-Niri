# User Packages
# CLI tools, build tools, applications, LSP servers, formatters, linters
# Note: neovim + treesitter live in modules/home/editor/
#       obsidian lives in modules/home/notes/
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.modules.home.packages;
in
{
  options.modules.home.packages.enable =
    lib.mkEnableOption "user packages (CLI tools, LSPs, formatters, linters)";

  config = lib.mkIf cfg.enable {
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
      nix-output-monitor
      nix-tree

      # Build tools
      gcc
      pkg-config
      pcre
      cargo

      # Applications
      keepassxc
      (discord.override { withOpenASAR = true; })
      mpv
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default

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

      # LSP servers
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

      # Formatters
      nixfmt
      stylua
      prettier
      black
      rustfmt
      shfmt
      kdlfmt
      google-java-format

      # Linters
      luajitPackages.luacheck
      shellcheck
      python314Packages.flake8
      eslint_d
      markdownlint-cli2
      statix

      # ── Neovim: CLI tools (Telescope, DAP, etc.) ─────────────────────────────
      ripgrep
      fd
      nodejs
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
  };
}
