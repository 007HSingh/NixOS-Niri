{
  lib,
  config,
  flakePath,
  ...
}:

let
  cfg = config.modules.home.xdg;
  dotfiles = "${flakePath}/dotfiles";
  # Out-of-store links let edits to the source files take effect without rebuilding.
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    niri = "niri";
    wallpapers = "wallpapers";
    nvim = "neovim";
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
        setSessionVariables = true;
      };
    };

    xdg.configFile = builtins.mapAttrs (_name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    }) configs;
  };
}
