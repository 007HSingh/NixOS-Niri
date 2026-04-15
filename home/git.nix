# Git Configuration
{ config, ... }:

{
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
}
