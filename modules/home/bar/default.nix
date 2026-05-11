# Noctalia Shell Configuration
# Status bar and desktop shell for Niri
# Note: noctalia.homeModules.default is imported at the top level (not inside mkIf)
# so the option is always declared; only the config is conditional.
{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.modules.home.bar;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.modules.home.bar.enable = lib.mkEnableOption "noctalia status bar";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".config/noctalia/plugins/catwalk" = {
        recursive = true;
        source = "${inputs.noctalia-plugins}/catwalk";
      };

      ".config/noctalia/plugins/pomodoro" = {
        recursive = true;
        source = "${inputs.noctalia-plugins}/pomodoro";
      };

      ".config/noctalia/plugins/spotify-control" = {
        recursive = true;
        source = ../../../config/noctalia/plugins/spotify-control;
      };

      ".config/noctalia/plugins/git-status" = {
        recursive = true;
        source = ../../../config/noctalia/plugins/git-status;
      };

      ".config/noctalia/plugins/nix-gc" = {
        recursive = true;
        source = ../../../config/noctalia/plugins/nix-gc;
      };

      ".config/noctalia/plugins.json" = {
        text = builtins.toJSON {
          sources = [
            {
              enabled = true;
              name = "Official Noctalia Plugins";
              url = "https://github.com/noctalia-dev/noctalia-plugins";
            }
          ];
          states = {
            catwalk = {
              enabled = true;
            };
            "spotify-control" = {
              enabled = true;
            };
            pomodoro = {
              enabled = true;
            };
            git-status = {
              enabled = true;
            };
            nix-gc = {
              enabled = true;
            };
          };
        };
      };
    };

    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          density = "comfortable";
          position = "top";
          showCapsule = true;
          floating = true;
          widgets = {
            left = [
              { id = "ControlCenter"; }
              { id = "WiFi"; }
              { id = "Bluetooth"; }
              { id = "Brightness"; }
              { id = "PowerProfile"; }
              { id = "NightLight"; }
            ];
            center = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              {
                alwaysShowPercentage = false;
                id = "Battery";
                warningThreshold = 30;
              }
              { id = "Volume"; }
              { id = "plugin:spotify-control"; }
              { id = "plugin:pomodoro"; }
              { id = "plugin:git-status"; }
              { id = "plugin:nix-gc"; }
              { id = "plugin:catwalk"; }
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              { id = "SystemMonitor"; }
            ];
          };
        };
        colorSchemes.predefinedScheme = "Catppuccin";
        wallpaper = {
          overviewEnabled = true;
        };
        location = {
          monthBeforeDay = true;
          name = "Kolkata, India";
        };
        dock = {
          enabled = false;
        };
        nightLight = {
          enabled = true;
          autoSchedule = true;
          nightTemp = "3000";
          dayTemp = "6500";
        };
        templates = {
          kitty = true;
          niri = true;
          discord = true;
        };
      };
    };
  };
}
