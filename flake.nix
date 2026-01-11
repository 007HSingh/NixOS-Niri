{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs-stable,
      nixpkgs-unstable,
      catppuccin,
      home-manager,
      nixvim,
      spicetify,
      zen-browser,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs-unstable.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
          inherit pkgs-unstable;
          stable = pkgs-stable;
          unstable = pkgs-unstable;
        };
        modules = [
          ./configuration.nix
          ./noctalia.nix
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.harsh = {
                imports = [
                  ./home.nix
                  catppuccin.homeModules.catppuccin
                  nixvim.homeModules.nixvim
                  inputs.spicetify.homeManagerModules.default
                ];
              };
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs;
                inherit pkgs-stable;
                inherit pkgs-unstable;
                stable = pkgs-stable;
                unstable = pkgs-unstable;
              };
            };
          }
        ];
      };
    };
}
