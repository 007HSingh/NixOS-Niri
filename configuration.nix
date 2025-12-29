{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  programs.yazi.enable = true;

  programs.niri.enable = true;

  programs.starship.enable = true;

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
    };
  };  

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

  nixpkgs.config.allowUnfree = true;

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      nvidiaSettings = true;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };  

  system.stateVersion = "25.11"; 

}

