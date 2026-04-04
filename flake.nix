{
  description = "NixOS Configuration with flake-parts";

  inputs = {
    # Nixpkgs channels
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake-parts for modular flake structure
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

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

    # Noctalia plugins
    noctalia-plugins = {
      url = "github:noctalia-dev/noctalia-plugins/00c554207b77aaa3a899bd8c2c8a0fdc327d6d85";
      flake = false;
    };

    # Spicetify for Spotify theming
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Stylix for system-wide theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Treefmt-nix for unified formatting
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Nix-index database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Nix User Repository (for Firefox/Zen addons)
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Zen Browser (Firefox-based, with declarative HM module)
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager";
      };
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs-unstable,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Systems to build for
      systems = [ "x86_64-linux" ];

      # Import flake-parts modules
      imports = [
        ./parts/nixos.nix
        ./parts/dev.nix
        ./parts/treefmt.nix
        treefmt-nix.flakeModule
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
