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

  gtk = {
    enable = true;

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
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = pkgs.catppuccin-kvantum.override {
        accent = "Blue";
        variant = "Mocha";
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

  programs.zathura = {
    enable = true;
    options = {
      notification-error-bg = "#1e1e2e";
      notification-error-fg = "#f38ba8";
      notification-warning-bg = "#1e1e2e";
      notification-warning-fg = "#fab387";
      notification-bg = "#1e1e2e";
      notification-fg = "#cdd6f4";

      completion-bg = "#1e1e2e";
      completion-fg = "#cdd6f4";
      completion-group-bg = "#313244";
      completion-group-fg = "#89b4fa";
      completion-highlight-bg = "#45475a";
      completion-highlight-fg = "#cdd6f4";

      index-bg = "#1e1e2e";
      index-fg = "#cdd6f4";
      index-active-bg = "#45475a";
      index-active-fg = "#cdd6f4";

      inputbar-bg = "#1e1e2e";
      inputbar-fg = "#cdd6f4";

      statusbar-bg = "#1e1e2e";
      statusbar-fg = "#cdd6f4";

      highlight-color = "#f9e2af";
      highlight-active-color = "#a6e3a1";

      default-bg = "#1e1e2e";
      default-fg = "#cdd6f4";
      render-loading = true;
      render-loading-bg = "#1e1e2e";
      render-loading-fg = "#cdd6f4";

      recolor-lightcolor = "#1e1e2e";
      recolor-darkcolor = "#cdd6f4";
      recolor = false;
      recolor-keephue = true;

      adjust-open = "width";
      pages-per-row = 1;
      scroll-page-aware = true;
      smooth-scroll = true;
      zoom-min = 10;
      guioptions = "sv";
      font = "JetBrainsMono Nerd Font 11";
      selection-clipboard = "clipboard";
    };
    extraConfig = ''
      # Vim-like keybindings
      map u scroll half-up
      map d scroll half-down
      map D toggle_page_mode
      map r reload
      map R rotate
      map K zoom in
      map J zoom out
      map i recolor
      map p print
      map g goto top
    '';
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
      preview = {
        tab_size = 2;
        max_width = 1000;
        max_height = 1000;
      };
    };
    theme = {
      manager = {
        cwd = {
          fg = "#89b4fa";
        };
        hovered = {
          fg = "#1e1e2e";
          bg = "#89b4fa";
        };
        preview_hovered = {
          underline = true;
        };
        find_keyword = {
          fg = "#f9e2af";
          italic = true;
        };
        find_position = {
          fg = "#f5c2e7";
          bg = "reset";
          italic = true;
        };
        marker_selected = {
          fg = "#a6e3a1";
          bg = "#a6e3a1";
        };
        marker_copied = {
          fg = "#f9e2af";
          bg = "#f9e2af";
        };
        marker_cut = {
          fg = "#f38ba8";
          bg = "#f38ba8";
        };
        tab_active = {
          fg = "#1e1e2e";
          bg = "#89b4fa";
        };
        tab_inactive = {
          fg = "#cdd6f4";
          bg = "#313244";
        };
        tab_width = 1;
        border_symbol = "│";
        border_style = {
          fg = "#89b4fa";
        };
      };
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = "#313244";
          bg = "#313244";
        };
        mode_normal = {
          fg = "#1e1e2e";
          bg = "#89b4fa";
          bold = true;
        };
        mode_select = {
          fg = "#1e1e2e";
          bg = "#a6e3a1";
          bold = true;
        };
        mode_unset = {
          fg = "#1e1e2e";
          bg = "#f38ba8";
          bold = true;
        };
        progress_label = {
          fg = "#cdd6f4";
          bold = true;
        };
        progress_normal = {
          fg = "#89b4fa";
          bg = "#313244";
        };
        progress_error = {
          fg = "#f38ba8";
          bg = "#313244";
        };
        permissions_t = {
          fg = "#a6e3a1";
        };
        permissions_r = {
          fg = "#f9e2af";
        };
        permissions_w = {
          fg = "#f38ba8";
        };
        permissions_x = {
          fg = "#a6e3a1";
        };
        permissions_s = {
          fg = "#585b70";
        };
      };
      input = {
        border = {
          fg = "#89b4fa";
        };
        title = { };
        value = { };
        selected = {
          reversed = true;
        };
      };
      select = {
        border = {
          fg = "#89b4fa";
        };
        active = {
          fg = "#f5c2e7";
        };
        inactive = { };
      };
      tasks = {
        border = {
          fg = "#89b4fa";
        };
        title = { };
        hovered = {
          underline = true;
        };
      };
      which = {
        mask = {
          bg = "#181825";
        };
        cand = {
          fg = "#94e2d5";
        };
        rest = {
          fg = "#9399b2";
        };
        desc = {
          fg = "#f5c2e7";
        };
        separator = "  ";
        separator_style = {
          fg = "#585b70";
        };
      };
      help = {
        on = {
          fg = "#f5c2e7";
        };
        exec = {
          fg = "#94e2d5";
        };
        desc = {
          fg = "#9399b2";
        };
        hovered = {
          bg = "#585b70";
          bold = true;
        };
        footer = {
          fg = "#313244";
          bg = "#cdd6f4";
        };
      };
      filetype = {
        rules = [
          {
            mime = "image/*";
            fg = "#94e2d5";
          }
          {
            mime = "video/*";
            fg = "#f9e2af";
          }
          {
            mime = "audio/*";
            fg = "#f9e2af";
          }
          {
            mime = "application/zip";
            fg = "#f5c2e7";
          }
          {
            mime = "application/gzip";
            fg = "#f5c2e7";
          }
          {
            mime = "application/x-tar";
            fg = "#f5c2e7";
          }
          {
            mime = "application/x-bzip";
            fg = "#f5c2e7";
          }
          {
            mime = "application/x-7z-compressed";
            fg = "#f5c2e7";
          }
          {
            mime = "application/x-rar";
            fg = "#f5c2e7";
          }
          {
            name = "*";
            fg = "#cdd6f4";
          }
          {
            name = "*/";
            fg = "#89b4fa";
          }
        ];
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
  };
}
