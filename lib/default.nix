# NixOS Configuration Library
# Helper functions for creating hosts and managing configurations
{ inputs }:

let
  inherit (inputs) nixpkgs-stable nixpkgs-unstable home-manager catppuccin nixvim spicetify;
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
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # Common specialArgs for both NixOS and Home Manager
      specialArgs = {
        inherit inputs;
        inherit pkgs-stable pkgs-unstable;
        stable = pkgs-stable;
        unstable = pkgs-unstable;
      };
    in
    nixpkgs-unstable.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        # Host-specific configuration
        ../hosts/${hostname}

        # System-wide modules
        ../system

        # Catppuccin NixOS theming
        catppuccin.nixosModules.catppuccin

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
                    ../users/${username}
                    catppuccin.homeModules.catppuccin
                    nixvim.homeModules.nixvim
                    spicetify.homeManagerModules.default
                  ];
                };
              }) users
            );
          };
        }
      ];
    };
}
