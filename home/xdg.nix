# XDG Configuration
# User directories and config file symlinks
{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Config directories to symlink
  configs = {
    kitty = "kitty";
    niri = "niri";
    fastfetch = "fastfetch";
    btop = "btop";
    wallpapers = "wallpapers";
  };
in
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Symlink config directories
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}
