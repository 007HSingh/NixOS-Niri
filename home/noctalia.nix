# Noctalia Shell Configuration
# Status bar and desktop shell for Niri
{
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.file = {
    ".config/noctalia/plugins" = {
      recursive = true;
      source = "${inputs.noctalia-plugins}/catwalk";
    };

    ".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "${config.xdg.configHome}/wallpapers/wallpaper-25.jpg";
        wallpapers = {
          "eDP-1" = "${config.xdg.configHome}/wallpapers/wallpaper-25.jpg";
        };
      };
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
        };
      };
    };
  };

  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "comfortable";
        position = "left";
        showCapsule = false;
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
            { id = "AudioVisualizer"; }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            { id = "Volume"; }
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
}
