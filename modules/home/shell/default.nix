# Shell Configuration
# Zsh, Starship, Zoxide, Direnv, and CLI tool integrations
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.shell;
in
{
  options.modules.home.shell.enable =
    lib.mkEnableOption "shell environment (zsh, starship, atuin, zoxide, etc.)";

  config = lib.mkIf cfg.enable {
    programs = {
      zsh = {
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
          (( $+commands[docker] )) && eval "$(docker completion zsh)"
        '';

        shellAliases = {
          update = "nh os switch";
          home-update = "nh home switch";

          nom-build = "nom build";
          nom-shell = "nom shell";
          nom-develop = "nom develop";
          nom-run = "nom run";

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

      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
          add_newline = false;
          character = {
            success_symbol = "[❯](bold green)";
            error_symbol = "[❯](bold red)";
            vicmd_symbol = "[V](bold yellow)";
          };
          directory = {
            style = "bold blue";
            truncation_length = 3;
            fish_style_pwd_dir_length = 1;
            truncate_to_repo = true;
            read_only = " ";
          };
          git_branch = {
            symbol = "  ";
            style = "bold purple";
            format = "on [$symbol$branch]($style) ";
          };
          git_status = {
            style = "bold red";
            format = "([$all_status$ahead_behind]($style) )";
            conflicted = "= ";
            ahead = "⇡";
            behind = "⇣";
            diverged = "⇕";
            untracked = "?";
            stashed = "";
            modified = "!";
            staged = "+";
            renamed = "»";
            deleted = "✘";
          };
          nix_shell = {
            symbol = "  ";
            style = "bold cyan";
            format = "via [$symbol$state]($style) ";
          };
          cmd_duration = {
            min_time = 2000;
            style = "bold yellow";
            format = "took [$duration]($style) ";
          };
        };
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      # direnv: enableZshIntegration handles the hook — no manual eval needed
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
      };

      eza = {
        enable = true;
        enableZshIntegration = true;
        git = true;
        icons = "always";
      };

      bat = {
        enable = true;
      };

      ripgrep.enable = true;

      fd = {
        enable = true;
        hidden = true;
      };

      lazygit = {
        enable = true;
        enableZshIntegration = true;
      };

      cava = {
        enable = true;
      };

      pay-respects = {
        enable = true;
        enableZshIntegration = true;
      };

      # -------------------------------------------------------------------------
      # ATUIN - Magical shell history with fuzzy search
      # Replaces Ctrl+R with a powerful TUI backed by SQLite
      # -------------------------------------------------------------------------
      atuin = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          # Local-only, no sync
          auto_sync = false;
          update_check = false;
          # Search behaviour
          search_mode = "fuzzy";
          filter_mode = "global";
          filter_mode_shell_up_key_binding = "session";
          # Style
          style = "compact";
          show_preview = true;
          max_preview_height = 4;
          show_help = false;
          # Avoid duplication
          history_filter = [
            "^ls$"
            "^cd$"
            "^pwd$"
            "^exit$"
            "^clear$"
          ];
        };
      };

      # -------------------------------------------------------------------------
      # YAZI - Blazing-fast TUI file manager with preview
      # Use 'y' instead of 'yazi' to have it cd into the last directory on exit
      # -------------------------------------------------------------------------
      yazi = {
        enable = true;
        enableZshIntegration = true;
        shellWrapperName = "y";
        settings = {
          manager = {
            show_hidden = true;
            sort_by = "natural";
            sort_dir_first = true;
          };
        };
      };

      # -------------------------------------------------------------------------
      # NIX-YOUR-SHELL - Stay in zsh when entering nix shell / nix develop
      # -------------------------------------------------------------------------
      nix-your-shell = {
        enable = true;
        enableZshIntegration = true;
      };

      # -------------------------------------------------------------------------
      # GH - GitHub CLI with declarative config & credential helper
      # -------------------------------------------------------------------------
      gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        settings = {
          git_protocol = "https";
          prompt = "enabled";
        };
      };

      # -------------------------------------------------------------------------
      # TEALDEER - Fast tldr client with auto-update
      # -------------------------------------------------------------------------
      tealdeer = {
        enable = true;
        settings = {
          updates = {
            auto_update = true;
            auto_update_interval_hours = 720; # ~monthly
          };
          display = {
            compact = false;
            use_pager = false;
          };
        };
      };
    };
  };
}
