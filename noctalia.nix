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
        rev = "c3e10d4c3f0b61085c67922fc12ffa6a4738cd33";
        hash = "sha256-OKWspRl7BmNtFQRnItDWy0cEFZ698DjeN5IXi28o2Rs=";
        sparseCheckout = [
          "catwalk"
        ];
      };
    };

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "/home/harsh/Pictures/Wallpapers/wallpaper(7).png";
        wallpapers = {
          "eDP-1" = "/home/harsh/Pictures/Wallpapers/wallpaper(7).png";
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
          position = "top";
          showCapsule = false;
          floating = false;
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
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              {
                id = "plugin:catwalk";
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
