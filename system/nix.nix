# Nix Settings
# Flakes, optimization, garbage collection, substituters
{ inputs, ... }:

{
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
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
  nixpkgs.overlays = [ inputs.nur.overlays.default ];
}
