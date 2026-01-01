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
    nvim = "neovim";
    niri = "niri";
    fuzzel = "fuzzel";
  };
in

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

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = ''
            eval "$(zoxide init zsh)"

      autoload -Uz compinit
          compinit
          zstyle ':completion:*' menu select
          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

            source ${pkgs.fzf}/share/fzf/key-bindings.zsh
            source ${pkgs.fzf}/share/fzf/completion.zsh
    '';
    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
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
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home.file = {
    "Pictures/Wallpapers".source = ./config/wallpapers;
  };

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
    javaPackages.compiler.temurin-bin.jdk-21
    p7zip
    jq
    yq
    hyperfine
    stable.keepassxc
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };
}
