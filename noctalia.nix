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

    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
	  density = "compact";
	  position = "left";
	  showCapsule = false;
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
	    ];
	  };
	};
	colorSchemes.predefinedScheme = "Monochrome";
	location = {
	  monthBeforeDay = true;
	  name = "Kolkata, India";
	};
      };
    };
  };
}
