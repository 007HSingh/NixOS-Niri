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

  gtk = {
    enable = true;

    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "teal" ];
        size = "standard";
        variant = "mocha";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = pkgs.catppuccin-kvantum.override {
        accent = "teal";
        variant = "mocha";
      };
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };  
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
    dotDir = "${config.xdg.configHome}/zsh"; 
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
      theme = spicePkgs.themes.starryNight;
    };

    programs.nnn = {
      enable = true;
      package = pkgs.nnn.override { withNerdIcons = true; };
    };

    home.file = {
      ".config/kitty".source = ./config/kitty;
      "Pictures/Wallpapers".source = ./config/wallpapers;
      ".config/nvim" = {
        source = ./config/neovim;
        recursive = true;
      };
    };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kvantum";
    QT_STYLE_OVERRIDE = "kvantum";
  };
}
