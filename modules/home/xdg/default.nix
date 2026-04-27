# XDG Configuration
# User directories and config file symlinks (all except nvim, which lives in editor/)
{ lib, config, ... }:

let
  cfg = config.modules.home.xdg;
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Config directories to symlink (nvim handled by modules/home/editor)
  configs = {
    kitty = "kitty";
    niri = "niri";
    fastfetch = "fastfetch";
    btop = "btop";
    wallpapers = "wallpapers";
    eza = "eza";
    quickshell = "quickshell";
  };
in
{
  options.modules.home.xdg.enable = lib.mkEnableOption "XDG user dirs and config/ symlinks";

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = true; # keep legacy behavior (stateVersion < 26.05)
      };
    };

    # Symlink config directories
    xdg.configFile = builtins.mapAttrs (_name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    }) configs;
  };
}
