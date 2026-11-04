{
  lib,
  config,
  pkgs,
  flakePath,
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
      poppler
      resvg

      (discord.override {
        withVencord = true;
      })

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
      evtest
      ffmpeg

      gcc
      pkg-config
      pcre2

      wl-clipboard
      playerctl

      git-absorb
    ];

    home = {
      pointerCursor.enable = true;

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        BROWSER = "firefox";
        TERMINAL = "kitty";
        NH_FLAKE = flakePath;
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };
    };
  };
}
