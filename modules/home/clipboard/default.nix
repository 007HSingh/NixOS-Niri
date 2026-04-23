# Clipboard Watcher Service
# Pipes wl-paste output into cliphist to build the clipboard history database.
# This runs at graphical-session startup so cliphist list always has entries.
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.clipboard;
in
{
  options.modules.home.clipboard.enable = lib.mkEnableOption "clipboard history via cliphist";

  config = lib.mkIf cfg.enable {
    systemd.user.services = {
      cliphist-text = {
        Unit = {
          Description = "Store text clipboard entries in cliphist";
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      cliphist-image = {
        Unit = {
          Description = "Store image clipboard entries in cliphist";
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
