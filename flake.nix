{
  description = "NixOS Configuration with flake-parts";

  inputs = {
    # Nixpkgs channels
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake-parts for modular flake structure
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Nixvim for Neovim configuration
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Catppuccin theming
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Quickshell for Wayland shell components
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Noctalia shell (status bar)
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Spicetify for Spotify theming
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{ flake-parts, nixpkgs-unstable, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Systems to build for
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Import flake-parts modules
      imports = [
        ./parts/nixos.nix
        ./parts/dev.nix
      ];

      # Provide pkgs for perSystem modules (since we use nixpkgs-unstable, not nixpkgs)
      perSystem =
        { system, ... }:
        {
          _module.args.pkgs = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
    };
}
