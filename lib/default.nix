# NixOS Configuration Library
# Helper functions for creating hosts and managing configurations
{ inputs }:

let
  inherit (inputs)
    nixpkgs-stable
    nixpkgs-unstable
    home-manager
    catppuccin
    spicetify
    nix-index-database
    sops-nix
    zen-browser
    antigravity-nix
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
        inherit inputs users antigravity-nix;
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

        # ── System dendritic modules (options declared; profile enables them) ──
        inputs.self.nixosModules.boot
        inputs.self.nixosModules.desktop
        inputs.self.nixosModules.fonts
        inputs.self.nixosModules.hardware
        inputs.self.nixosModules.networking
        inputs.self.nixosModules.nix
        inputs.self.nixosModules.packages
        inputs.self.nixosModules.programs
        inputs.self.nixosModules.security
        inputs.self.nixosModules.services
        inputs.self.nixosModules.stylix
        inputs.self.nixosModules.users
        inputs.self.nixosModules.vm
        inputs.self.nixosModules.nvidia

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
                    # ── Home dendritic modules (options declared; profile enables them) ──
                    inputs.self.homeManagerModules.audio
                    inputs.self.homeManagerModules.bar
                    inputs.self.homeManagerModules.browser
                    inputs.self.homeManagerModules.clipboard
                    inputs.self.homeManagerModules.editor
                    inputs.self.homeManagerModules.git
                    inputs.self.homeManagerModules.idle
                    inputs.self.homeManagerModules.media
                    inputs.self.homeManagerModules.notes
                    inputs.self.homeManagerModules.packages
                    inputs.self.homeManagerModules.quickshell
                    inputs.self.homeManagerModules.shell
                    inputs.self.homeManagerModules.termipedia
                    inputs.self.homeManagerModules.theming
                    inputs.self.homeManagerModules.vscode
                    inputs.self.homeManagerModules.wofi
                    inputs.self.homeManagerModules.xdg

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
