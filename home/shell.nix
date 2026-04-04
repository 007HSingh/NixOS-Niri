# Shell Configuration
# Zsh, Starship, Zoxide, Direnv, and CLI tool integrations
{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    initContent = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      (( $+commands[gh]     )) && eval "$(gh completion -s zsh)"
      (( $+commands[docker] )) && eval "$(docker completion zsh)"
    '';

    shellAliases = {
      update = "nh os switch";
      home-update = "nh home switch";

      # Modern replacements
      ls = "eza -la --icons";
      cat = "bat";

      # Git
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";

      # Navigation
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

    # zsh-you-should-use: reminds you when you forget your own aliases
    plugins = [
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
      }
    ];

  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
      add_newline = false;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      directory = {
        style = "bold blue";
        truncation_length = 3;
        fish_style_pwd_dir_length = 1;
      };
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      git_status = {
        style = "bold red";
      };
      nix_shell = {
        symbol = " ";
        style = "bold cyan";
        format = "[$symbol$state]($style) ";
      };
      cmd_duration = {
        min_time = 2000;
        style = "bold yellow";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # direnv: enableZshIntegration handles the hook — no manual eval needed
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "always";
  };

  programs.bat = {
    enable = true;
  };

  programs.ripgrep.enable = true;

  programs.fd = {
    enable = true;
    hidden = true;
  };

  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.cava = {
    enable = true;
  };

  # pay-respects: corrects mistyped commands (replaces thefuck, removed from nixpkgs)
  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
  };
}
