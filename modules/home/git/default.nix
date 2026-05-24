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

        diff.colorMoved = "default";

        aliases = {
          st = "status";
          co = "checkout";
          br = "branch";
          ci = "commit";
          lg = "log --oneline --graph --decorate";
        };
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        side-by-side = true;
        line-numbers = true;
        navigate = true; # n/N to jump between diff sections
        hyperlinks = true;
      };
    };

    catppuccin.delta = {
      enable = true;
      flavor = "mocha";
    };
  };
}
