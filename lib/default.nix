# NixOS Configuration Library
# Helper functions for creating hosts and managing configurations
{ inputs }:

let
  inherit (inputs)
    nixpkgs-unstable
    home-manager
    catppuccin
    spicetify
    nix-index-database
    sops-nix
    zen-browser
    antigravity-nix
    hyprland
    ;
in
{
  # Create a NixOS host configuration
  # Usage: mkHost { hostname = "nixos"; system = "x86_64-linux"; users = [ "harsh" ]; }
  mkHost =
    {
      hostname,
      system ? "x86_64-linux",
      users ? [ ],
    }:
    let
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # Common specialArgs for both NixOS and Home Manager
      specialArgs = {
        inherit inputs users antigravity-nix;
        inherit pkgs-unstable;
        unstable = pkgs-unstable;
      };
    in
    nixpkgs-unstable.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        # Host-specific configuration
        ../hosts/${hostname}

        # ── System dendritic modules (auto-imported) ──
        inputs.self.nixosModules.all

        # Stylix NixOS integration
        inputs.stylix.nixosModules.stylix

        # Secrets management (sops-nix)
        sops-nix.nixosModules.sops

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = specialArgs;

            # Configure each user
            users = builtins.listToAttrs (
              map (username: {
                name = username;
                value = {
                  imports = [
                    # ── Home dendritic modules (auto-imported) ──
                    inputs.self.homeManagerModules.all

                    # ── User-specific config (identity, sops, profile) ──────────
                    ../users/${username}

                    # ── External Home Manager modules ───────────────────────────
                    spicetify.homeManagerModules.default
                    catppuccin.homeModules.catppuccin
                    nix-index-database.homeModules.nix-index
                    inputs.sops-nix.homeManagerModules.sops
                    zen-browser.homeModules.beta
                  ];
                };
              }) users
            );
          };
        }
      ];
    };
}
