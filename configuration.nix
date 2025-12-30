{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot = {
    kernelParams = [
      "quiet"
      "loglevel=3"
      "rd.systemd.show_status=0"
      "udev.log_level=3"
    ];
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
      };
    };  
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;  
    "vm.vfs_cache_pressure" = 50;  
    "vm.dirty_ratio" = 10;  
    "vm.dirty_background_ratio" = 5;  
  };

  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri";
      user = "greeter";
    };
  };

  services.xserver.xkb.layout = "us";

  services.libinput.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "";
  };  

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  users.users.harsh = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Harsh Singh";
    extraGroups = [ "networkmanager" "wheel" ]; 
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
  };

  programs.niri.enable = true;

  programs.starship.enable = true;

  programs.gpu-screen-recorder.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions = {
      enable = true;
      async = true;
    };
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
	"starship"
	"colored-man-pages"
      ];
    };
    shellAliases = {
      ls = "eza -la --icons";
      cat = "bat";
      update = "sudo nixos-rebuild switch --flake /home/harsh/nixos-config#nixos";
      generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      clean = "sudo nix-collect-garbage -d";
    };
  };

  programs.dconf.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-vcs-plugin
    ];
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [ 
    wget
    git 
    kitty
    niri
    xwayland-satellite
    fuzzel
    swaylock
    wayclip
    brightnessctl
    cliphist
    cava
    wlsunset
    eza
    bat
    obsidian
    spotify
    vlc
    btop
    ripgrep
    fd
    fzf
    fastfetch
    lazygit
    zoxide
    starship
    bibata-cursors
    vesktop
    pywalfox-native
    catppuccin-gtk
    catppuccin-kvantum
    papirus-icon-theme
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    nnn
    xfce.thunar
    xfce.tumbler
    jetbrains.idea
    kdePackages.okular
    xdg-utils
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  services.blueman.enable = true;

  services.power-profiles-daemon.enable = true;

  services.upower.enable = true;

  services.tumbler.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  nixpkgs.config.allowUnfree = true;

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      nvidiaSettings = true;

      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };  

  security.polkit.enable = true;

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  system.stateVersion = "25.11"; 

}

