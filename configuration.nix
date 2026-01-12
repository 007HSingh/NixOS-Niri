{
  config,
  lib,
  pkgs,
  stable,
  unstable,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./nixvim.nix
  ];

  boot = {
    plymouth.enable = true;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "rd.systemd.show_status=0"
      "udev.log_level=3"
      "acpi_backlight=native"
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
    "vm.swappiness" = 60;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "lz4";
    priority = 100;
  };

  networking.hostName = "nixos";

  networking.networkmanager = {
    enable = true;
    plugins = [
      stable.networkmanager-openvpn
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  catppuccin = {
    enable = true;
    cache.enable = true;
    grub.enable = true;
    grub.flavor = "mocha";
    sddm.enable = true;
    sddm.flavor = "mocha";
    sddm.clockEnabled = true;
    plymouth.enable = true;
    plymouth.flavor = "mocha";
  };

  services.xserver.xkb.layout = "us";

  services.fstrim.enable = true;

  services.libinput.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  users.users.harsh = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Harsh Singh";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "kvm"
    ];
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

  programs.steam.enable = true;

  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;

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
        "docker"
        "kubectl"
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.dconf.enable = true;

  programs.evince.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
      thunar-vcs-plugin
    ];
  };

  programs.yazi.enable = true;

  security = {
    rtkit.enable = true;

    sudo.wheelNeedsPassword = true;
    apparmor.enable = true;

    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "harsh" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wget2
    git
    kitty
    niri
    xwayland-satellite
    fuzzel
    swaylock
    wayclip
    brightnessctl
    cliphist
    wlsunset
    spotify
    btop
    vlc
    fastfetch
    lazygit
    starship
    stable.discord
    pywalfox-native
    jetbrains.idea
    xdg-utils
    file
    chafa
    ffmpegthumbnailer
    mediainfo
    evince
    nwg-look
    fastfetch
    gh
    delta
    docker-compose
    android-studio
    android-tools
    mangohud
    protonup-ng
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
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

  services.gvfs.enable = true;

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

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
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

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      experimental = true;
      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ];
    };
  };

  system.stateVersion = "25.11";

}
