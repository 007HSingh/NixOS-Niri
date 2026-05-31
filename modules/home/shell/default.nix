# Shell Configuration
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
    stylix.targets = {
      kitty.enable = false;
      bat.enable = false;
      lazygit.enable = false;
      yazi.enable = false;
      starship.enable = false;
    };

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

          # ── compinit caching ──────────────────────────────────────────────
          # Re-run full compinit (with compaudit) at most once every 20 hours;
          # all other starts use -C (skip audit) for a ~75ms startup saving.
          autoload -Uz compinit
          local _zcompdump="''${ZDOTDIR}/.zcompdump"
          if [[ -n "''${_zcompdump}"(#qN.mh+20) ]]; then
            compinit -d "''${_zcompdump}"
          else
            compinit -C -d "''${_zcompdump}"
          fi
          unset _zcompdump

          # ── Lazy docker completion ────────────────────────────────────────
          # Only eval docker completion on first <Tab> after 'docker',
          # not on every shell start.
          if (( $+commands[docker] )); then
            function _lazy_docker() {
              unfunction _lazy_docker
              eval "$(docker completion zsh)"
              _docker "$@"
            }
            compdef _lazy_docker docker
          fi
        '';

        shellAliases = {
          update = "nh os switch";
          home-update = "nh home switch";
          zathura = "zathura --fork";

          nom-build = "nom build";
          nom-shell = "nom shell";
          nom-develop = "nom develop";
          nom-run = "nom run";

          ls = "eza -la --icons";
          cat = "bat";

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

        # zsh-you-should-use: reminds you when you forget your own aliases
        plugins = [
          {
            name = "zsh-you-should-use";
            src = pkgs.zsh-you-should-use;
          }
          {
            name = "fzf-tab";
            src = pkgs.zsh-fzf-tab;
          }
        ];
      };

      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          format = "$directory$git_branch$git_status$nix_shell$python$rust$docker_context$battery$cmd_duration$line_break$character";
          right_format = "$time";
          scan_timeout = 100;
          command_timeout = 500;
          add_newline = false;

          character = {
            success_symbol = "[❯](bold green)";
            error_symbol = "[❯](bold red)";
            vicmd_symbol = "[V](bold yellow)";
          };

          directory = {
            style = "bold lavender";
            truncation_length = 3;
            truncation_symbol = ".../";
            fish_style_pwd_dir_length = 1;
            truncate_to_repo = true;
            read_only = " 󰌾";
            format = " [$path]($style)[$read_only]($read_only_style) ";
          };

          git_branch = {
            symbol = " ";
            style = "bold mauve";
            format = "[$symbol$branch]($style) ";
          };

          git_status = {
            style = "bold red";
            format = "([$all_status$ahead_behind]($style) )";
            ignore_submodules = true; # skip submodule scan — big repos stay fast
            conflicted = "󰞇 ";
            ahead = "󰶣";
            behind = "󰶡";
            diverged = "󰶤";
            untracked = "󰋗 ";
            stashed = "󰏗 ";
            modified = "󰏫 ";
            staged = "󰐖 ";
            renamed = "󰑕 ";
            deleted = "󰆴 ";
          };

          nix_shell = {
            symbol = "󱄅 ";
            style = "bold sky";
            format = "[$symbol$state]($style) ";
          };

          cmd_duration = {
            min_time = 2000;
            style = "bold yellow";
            format = "󱎫 [$duration]($style) ";
          };

          python = {
            symbol = " ";
            style = "bold yellow";
            format = "[$symbol$version]($style) ";
            detect_files = [
              "requirements.txt"
              ".python-version"
              "pyproject.toml"
              "Pipfile"
            ];
          };

          rust = {
            symbol = " ";
            style = "bold peach";
            format = "[$symbol$version]($style) ";
          };

          docker_context = {
            symbol = " ";
            style = "bold blue";
            format = "[$symbol$context]($style) ";
            only_with_files = true;
          };

          battery = {
            display = [
              {
                threshold = 30;
                style = "bold red";
                charging_symbol = "󰂄 ";
                discharging_symbol = "󰂃 ";
              }
            ];
          };

          time = {
            disabled = false;
            format = "[$time]($style)";
            style = "dimmed text";
            time_format = "%H:%M";
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
        settings = {
          general = {
            framerate = 60;
            bar_width = 2;
            bar_spacing = 1;
          };
          smoothing.monstercat = 1;

        };
      };

      fastfetch = {
        enable = true;
      };

      pay-respects = {
        enable = true;
        enableZshIntegration = true;
      };

      atuin = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          # local-only, no sync
          auto_sync = false;
          update_check = false;
          search_mode = "fuzzy";
          filter_mode = "global";
          filter_mode_shell_up_key_binding = "session";
          style = "compact";
          show_preview = true;
          max_preview_height = 4;
          show_help = false;
          history_filter = [
            "^ls$"
            "^cd$"
            "^pwd$"
            "^exit$"
            "^clear$"
          ];
        };
      };

      yazi = {
        enable = true;
        enableZshIntegration = true;
        shellWrapperName = "y"; # cds into last visited dir on exit
        initLua = ''
          require("full-border"):setup()
          require("git"):setup()
        '';
        settings = {
          manager = {
            show_hidden = true;
            sort_by = "natural";
            sort_dir_first = true;
          };
        };
        plugins = {
          full-border =
            pkgs.fetchFromGitHub {
              owner = "yazi-rs";
              repo = "plugins";
              rev = "ac82af3";
              hash = "sha256-svc7I2E+tVMEUWUvIS6i3oTGfLq13eaI61T0c1MQ8qQ=";
            }
            + "/full-border.yazi";
          git =
            pkgs.fetchFromGitHub {
              owner = "yazi-rs";
              repo = "plugins";
              rev = "ac82af3";
              hash = "sha256-svc7I2E+tVMEUWUvIS6i3oTGfLq13eaI61T0c1MQ8qQ=";
            }
            + "/git.yazi";
        };
      };

      # keeps zsh when entering nix shell / nix develop
      nix-your-shell = {
        enable = true;
        enableZshIntegration = true;
      };

      gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        settings = {
          git_protocol = "https";
          prompt = "enabled";
        };
      };

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

      kitty = {
        enable = true;
        font = {
          name = "Maple Mono NF";
          size = 12;
        };
        settings = {
          modify_font = "cell_height 125%";
          enable_ligatures = "always";
          background_blur = 20;
          window_padding_width = 16;
          window_margin_width = 2;
          hide_window_decorations = "yes";
          inactive_text_alpha = "0.8";
          placement_strategy = "center";
          cursor_shape = "beam";
          cursor_blink_interval = "0.5";
          cursor_stop_blinking_after = 0;
          cursor_trail = 3;
          cursor_trail_decay = "0.15 0.5";
          url_style = "single";
          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          tab_title_template = "{index}: {title}";
          shell_integration = "enabled";
          scrollback_lines = 10000;
          enable_audio_bell = "no";
          repaint_delay = 10;
          input_delay = 3;
          allow_remote_control = "yes";
          confirm_os_window_close = 0;
          allow_hyperlinks = "yes";
          detect_urls = "yes";
          copy_on_select = "no";
          clipboard_control = "write-clipboard write-primary";
          shell = "/run/current-system/sw/bin/zsh";
          working_directory = "home";
          vsync = "yes";
          background_opacity = "0.85";
        };
        keybindings = {
          "ctrl+shift+t" = "new_tab";
          "ctrl+shift+w" = "close_tab";
          "ctrl+tab" = "next_tab";
          "ctrl+shift+tab" = "previous_tab";
          "ctrl+shift+d" = "launch --location=hsplit";
          "ctrl+shift+D" = "launch --location=vsplit";
          "ctrl+shift+h" = "neighboring_window left";
          "ctrl+shift+l" = "neighboring_window right";
          "ctrl+shift+k" = "neighboring_window up";
          "ctrl+shift+j" = "neighboring_window down";
          "ctrl+equal" = "increase_font_size";
          "ctrl+minus" = "decrease_font_size";
          "ctrl+0" = "reset_font_size";
          "ctrl+shift+c" = "copy_to_clipboard";
          "ctrl+shift+v" = "paste_from_clipboard";
          "ctrl+shift+f" = "search";
        };
      };
    };

    catppuccin = {
      enable = true;
      flavor = "mocha";

      starship.enable = true;
      cava.enable = true;
      kitty.enable = true;
      bat.enable = true;
      lazygit.enable = true;
      yazi.enable = true;
    };
  };
}
