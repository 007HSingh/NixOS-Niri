{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.harsh = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "/home/harsh/Downloads/wallpaper(2).png";
	wallpapers = {
	  "eDP-1" = "/home/harsh/Downloads/wallpaper(2).png";
	};
      };
    };

    home.file.".config/noctalia/plugins.json" = {
      text = builtins.toJSON {
        "catwalk" = {
	  enabled = true;
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
	        id="plugin:catwalk";
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
	  gtk = false;
	  qt = false;
	  fuzzel = true;
	  discord = true;
	  pywalfox = true;
	  cava = true;
	  niri = true;
	};
      };
    };
  };
}
