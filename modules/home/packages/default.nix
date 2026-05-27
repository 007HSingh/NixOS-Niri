# User Packages
{
  lib,
  config,
  pkgs,
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

      (writeShellScriptBin "niri-scratch" ''
        #!/usr/bin/env bash

        SCRATCH_APP_ID="kitty-scratch"
        SCRATCH_WS="scratch"

        WINDOWS=$(niri msg --json windows 2>/dev/null)
        SCRATCH_EXISTS=$(echo "$WINDOWS" | ${pkgs.jq}/bin/jq -e \
          "[.[] | select(.app_id == \"$SCRATCH_APP_ID\")] | length > 0" 2>/dev/null)

        CURRENT_WS=$(niri msg --json workspaces 2>/dev/null | \
          ${pkgs.jq}/bin/jq -r '.[] | select(.is_focused == true) | .name // ""')

        if [ "$SCRATCH_EXISTS" = "false" ]; then
          niri msg action focus-workspace "$SCRATCH_WS" 2>/dev/null || true
          kitty --app-id "$SCRATCH_APP_ID" &
        elif [ "$CURRENT_WS" = "$SCRATCH_WS" ]; then
          niri msg action focus-workspace-previous
        else
          niri msg action focus-workspace "$SCRATCH_WS"
        fi
      '')
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
