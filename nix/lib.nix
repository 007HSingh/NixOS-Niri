{ inputs }:

let
  inherit (inputs)
    nixpkgs
    home-manager
    catppuccin
    spicetify
    nix-index-database
    sops-nix
    ;
in
{
  mkHost =
    {
      hostname,
      system ? "x86_64-linux",
      users ? [ ],
      flakePath ? "/home/${builtins.head users}/nixos-config",
    }:
    let
      specialArgs = {
        inherit inputs users flakePath;
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ../hosts/${hostname}

        inputs.self.nixosModules.all

        inputs.stylix.nixosModules.stylix

        inputs.catppuccin.nixosModules.catppuccin

        sops-nix.nixosModules.sops

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = specialArgs;

            users = builtins.listToAttrs (
              map (username: {
                name = username;
                value = {
                  imports = [
                    inputs.self.homeManagerModules.all

                    ../users/${username}.nix

                    spicetify.homeManagerModules.default
                    catppuccin.homeModules.catppuccin
                    nix-index-database.homeModules.nix-index
                    inputs.sops-nix.homeManagerModules.sops
                  ];
                };
              }) users
            );
          };
        }
      ];
    };
}
