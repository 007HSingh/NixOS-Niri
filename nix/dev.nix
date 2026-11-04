_:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        name = "nixos-config-shell";

        packages = with pkgs; [
          nixfmt
          statix
          deadnix
          nh
          nix-tree
          age
          sops
        ];

        shellHook = ''
          echo "󱄅 NixOS Configuration Development Environment"
          echo "--------------------------------------------"
          echo "Available tools:"
          echo "  • nixfmt: Formatting"
          echo "  • nixd: Language Server"
          echo "  • statix/deadnix: Linting"
          echo "  • nh: Nix Helper (nh os switch)"
          echo "  • nix-tree: Dependency visualization"

          export NIX_CONFIG_SHELL=1
        '';
      };
    };
}
