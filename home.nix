{ config, pkgs, inputs, ... }: 

{
  home.username = "harsh";
  home.homeDirectory = "/home/harsh";
  home.stateVersion = "25.11";

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };  

  programs.git = {
    enable = true;
    settings = {
      user.name = "Harsh Singh";
      user.email = "singhharsh25032008@gmail.com";
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

  programs.zsh = {
    enable = true;
    initContent = ''
      eval "$(zoxide init zsh)"

      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
    '';
    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
    };
  };

  programs.spicetify =
    let 
      spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
	hidePodcasts
	shuffle
	playlistIcons
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
	ncsVisualizer
      ];
      enabledSnippets = with spicePkgs.snippets; [
        rotatingCoverart
	pointer
      ];
      theme = spicePkgs.themes.dymanicDribblish;
    };
}
