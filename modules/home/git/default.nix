# Git Configuration
{ lib, config, ... }:

let
  cfg = config.modules.home.git;
in
{
  options.modules.home.git.enable = lib.mkEnableOption "git configuration with SOPS secret email";

  config = lib.mkIf cfg.enable {
    sops.secrets.git_email = { };

    sops.templates."git-credentials".content = ''
      [user]
        email = "${config.sops.placeholder.git_email}"
    '';

    programs.git = {
      enable = true;
      includes = [
        { inherit (config.sops.templates."git-credentials") path; }
      ];
      settings = {
        user.name = "Harsh Singh";
        init.defaultBranch = "main";

        aliases = {
          st = "status";
          co = "checkout";
          br = "branch";
          ci = "commit";
          lg = "log --oneline --graph --decorate";
        };
      };
    };
  };
}
