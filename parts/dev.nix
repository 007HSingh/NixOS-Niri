# Flake-parts module: Development Shells
# Provides dev shells for working on this configuration
{ inputs, ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        name = "nixos-config-shell";

        # Tools for Nix development
        packages = with pkgs; [
          nixfmt
          nixd
          statix
          deadnix
          nh # Nix Helper - great for builds/updates
          nix-tree # Explore dependency graph
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

          # Optional: set an env var to indicate we are in this shell
          export NIX_CONFIG_SHELL=1
        '';
      };
    };
}
