# Git Configuration
{ ... }:

{
  sops.secrets.git_email = {
    sopsFile = ../../secrets/user.yaml;
  }

  programs.git = {
    enable = true;
    settings = {
      user.name = "Harsh Singh";
      user.email = config.sops.secrets.git_email.path;
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
