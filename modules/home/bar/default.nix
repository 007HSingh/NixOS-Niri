# Noctalia Shell
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
      ".config/noctalia/plugins/weather-indicator" = {
        recursive = true;
        source = "${inputs.noctalia-plugins}/weather-indicator";
      };

      ".config/noctalia/plugins/catwalk" = {
        recursive = true;
        source = "${inputs.noctalia-plugins}/catwalk";
      };

      ".config/noctalia/plugins/pomodoro" = {
        recursive = true;
        source = "${inputs.noctalia-plugins}/pomodoro";
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
            "weather-indicator" = {
              enabled = true;
            };
            pomodoro = {
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
          density = "default";
          position = "left";
          showCapsule = false;
          framed = false;
          floating = true;
          useSeparateOpacity = true;
          backgroundOpacity = lib.mkForce 0.50;
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
              { id = "plugin:pomodoro"; }
              { id = "plugin:catwalk"; }
              { id = "plugin:weather-indicator"; }
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
        idle.enabled = true;
        templates = {
          kitty = false;
          niri = false;
          discord = false;
        };
      };
    };
  };
}
