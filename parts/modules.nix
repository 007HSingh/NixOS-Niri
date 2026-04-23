# Flake-parts module: Module Registry
# Exposes all dendritic NixOS and Home Manager modules as named flake outputs.
# Consumed in lib/default.nix via inputs.self.nixosModules.* and
# inputs.self.homeManagerModules.* so the module system remains path-agnostic.
{ ... }:

{
  flake = {
    nixosModules = {
      # ── System feature modules ──────────────────────────────────────────────
      boot = import ../modules/system/boot;
      desktop = import ../modules/system/desktop;
      fonts = import ../modules/system/fonts;
      hardware = import ../modules/system/hardware;
      networking = import ../modules/system/networking;
      nix = import ../modules/system/nix;
      packages = import ../modules/system/packages;
      programs = import ../modules/system/programs;
      security = import ../modules/system/security;
      services = import ../modules/system/services;
      stylix = import ../modules/system/stylix;
      users = import ../modules/system/users;
      vm = import ../modules/system/vm;
      nvidia = import ../modules/system/nvidia;

      # ── Host profiles ───────────────────────────────────────────────────────
      profile-predator = import ../profiles/predator.nix;
    };

    homeManagerModules = {
      # ── Home feature modules ────────────────────────────────────────────────
      audio = import ../modules/home/audio;
      bar = import ../modules/home/bar;
      browser = import ../modules/home/browser;
      clipboard = import ../modules/home/clipboard;
      editor = import ../modules/home/editor;
      git = import ../modules/home/git;
      idle = import ../modules/home/idle;
      media = import ../modules/home/media;
      notes = import ../modules/home/notes;
      packages = import ../modules/home/packages;
      quickshell = import ../modules/home/quickshell;
      shell = import ../modules/home/shell;
      termipedia = import ../modules/home/termipedia;
      theming = import ../modules/home/theming;
      vscode = import ../modules/home/vscode;
      wofi = import ../modules/home/wofi;
      xdg = import ../modules/home/xdg;

      # ── User profiles ───────────────────────────────────────────────────────
      profile-harsh = import ../profiles/harsh.nix;
    };
  };
}
