# User Packages
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
    services.wluma.enable = true;

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
      typioca

      # Build tools
      gcc
      pkg-config
      pcre
      cargo
      quickshell

      # Applications
      (discord.override { withOpenASAR = true; })
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Wayland utilities
      wl-clipboard
      playerctl

      # Languages
      javaPackages.compiler.temurin-bin.jdk-21
      racket
      python314
      python314Packages.pip

      # Git tools
      git-absorb
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "zen-beta";
      TERMINAL = "kitty";
      NH_FLAKE = "/home/harsh/nixos-config";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      JAVA_HOME = "${pkgs.javaPackages.compiler.temurin-bin.jdk-21}";
    };
  };
}
