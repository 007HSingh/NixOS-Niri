# Noctalia Shell Configuration
# Status bar and desktop shell for Niri
{ pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.file.".config/noctalia/plugins" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "noctalia-dev";
      repo = "noctalia-plugins";
      rev = "00c554207b77aaa3a899bd8c2c8a0fdc327d6d85";
      hash = "sha256-x54meFWkMgvUSLTsVi7ipdcKyjIn3O5nw96GQyoRay4=";
      sparseCheckout = [
        "catwalk"
      ];
    };
  };

  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = "home/harsh/.config/wallpapers/wallpaper-13.png";
      wallpapers = {
        "eDP-1" = "/home/harsh/.config/wallpapers/wallpaper-13.png";
      };
    };
  };

  home.file.".config/noctalia/plugins.json" = {
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
        enabled = false;
        autoSchedule = true;
        nightTemp = "3000";
        dayTemp = "6500";
      };
      templates = {
        gtk = true;
        qt = true;
        kitty = true;
        pywalfox = true;
        cava = true;
        niri = true;
        discord = true;
      };
    };
  };
}
