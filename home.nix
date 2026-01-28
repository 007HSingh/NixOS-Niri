{
  config,
  pkgs,
  inputs,
  stable,
  unstable,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    kitty = "kitty";
    niri = "niri";
    fuzzel = "fuzzel";
    fastfetch = "fastfetch";
    btop = "btop";
    wallpapers = "wallpapers";
  };
in

{
  imports = [
    ./nixvim.nix
  ];

  home.username = "harsh";
  home.homeDirectory = "/home/harsh";
  home.stateVersion = "25.11";

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Catppuccin-Mocha-Standard-Blue-Dark";
    };
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
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

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
      };
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
            if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
              compinit
            else
              compinit -C
            fi
            zstyle ':completion:*' menu select
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '';
    initContent = ''
      eval "$(zoxide init zsh --no-cmd)"
      alias cd='__zoxide_z'
      alias cdi='__zoxide_zi'
      eval "$(direnv hook zsh)"

      bindkey -r '^T'
      bindkey -r '^R'
      function __load_fzf() {
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        source ${pkgs.fzf}/share/fzf/completion.zsh
        zle reset-prompt
      }
      zle -N __load_fzf
      bindkey '^T' __load_fzf
    '';
    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };
    shellAliases = {
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };

    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };

    syntaxHighlighting = {
      enable = true;
    };

    oh-my-zsh.enable = false;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
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
        beautifulLyrics
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        ncsVisualizer
      ];
      enabledSnippets = with spicePkgs.snippets; [
        rotatingCoverart
        pointer
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home.packages = with pkgs; [
    cava
    poppler
    resvg
    eza
    bat
    obsidian
    ripgrep
    fd
    fzf
    lazygit
    zoxide
    bibata-cursors
    catppuccin-gtk
    papirus-icon-theme
    gcc
    unzip
    nil
    lua-language-server
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
    dockerfile-language-server
    docker-compose-language-service
    tree-sitter
    gnumake
    tokei
    rust-analyzer
    pyright
    bash-language-server
    jdt-language-server
    clang-tools
    marksman
    nixfmt
    stylua
    prettier
    black
    rustfmt
    shfmt
    p7zip
    jq
    yq
    hyperfine
    stable.keepassxc
    javaPackages.compiler.temurin-bin.jdk-25
    racket
    git-absorb
    libreoffice-qt
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitiytools.d";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
  };
}
