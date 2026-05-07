# Nix Settings
# Flakes, optimization, garbage collection, substituters
{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.modules.system.nix;
in
{
  options.modules.system.nix.enable =
    lib.mkEnableOption "nix daemon settings (flakes, GC, substituters, overlays)";

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
        max-jobs = "auto";
        cores = 0;
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://claude-code.cachix.org"
          "https://zed.cachix.org"
          "https://cache.nixos-cuda.org"
          "https://quickshell.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
          "zed.cachix.org-1:QQ4XGMsy4wG0+LwBq6QGj5PEgNFbTAqK6HNoF7DAfFI="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          "quickshell.cachix.org-1:SrePAnJ9XVS7AnYv7vAtp5ZzYJ3B8oYyYxO6Y8cT48I="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    # Allow unfree packages (system-wide)
    # Note: flake.nix also sets allowUnfree in perSystem for the dev shell pkgs — both are intentional
    nixpkgs.config.allowUnfree = true;

    # System-wide overlays — applied before pkgs is evaluated, so all consumers
    # (including home-manager with useGlobalPkgs = true) see pkgs.nur
    nixpkgs.overlays = [
      inputs.nur.overlays.default
      inputs.claude-code-nix.overlays.default
    ];
  };
}
