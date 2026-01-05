{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.harsh = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    home.file.".config/noctalia/plugins" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "noctalia-dev";
        repo = "noctalia-plugins";
        rev = "4881988b10e1785530e6fb7f07ada6ad3ec035a1";
        hash = "sha256-KhnBRNBu56Z3zgESNcrbu7XPSEtqROCkylFM0nGKQxo=";
        sparseCheckout = [
          "catwalk"
        ];
      };
    };

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "/home/harsh/Pictures/Wallpapers/wallpaper(17).png";
        wallpapers = {
          "eDP-1" = "/home/harsh/Pictures/Wallpapers/wallpaper(17).png";
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
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "WiFi";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "Brightness";
              }
              {
                id = "PowerProfile";
              }
            ];
            center = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
              {
                id = "AudioVisualizer";
              }
            ];
            right = [
              {
                alwaysShowPercentage = false;
                id = "Battery";
                warningThreshold = 30;
              }
              {
                id = "Volume";
              }
              {
                id = "plugin:catwalk";
              }
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              {
                id = "SystemMonitor";
              }
            ];
          };
        };
        wallpaper = {
          overviewEnabled = true;
        };
        colorSchemes.predefinedScheme = "Catppuccin";
        location = {
          monthBeforeDay = true;
          name = "Kolkata, India";
        };
        templates = {
          gtk = true;
          qt = true;
          kitty = true;
          fuzzel = true;
          pywalfox = true;
          cava = true;
          niri = true;
        };
      };
    };
  };
}
