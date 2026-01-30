# Flake-parts module: Development Shells
# Provides dev shells for working on this configuration
{ inputs, ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-config";
        packages = with pkgs; [
          nixfmt-rfc-style
          nil
          statix
          deadnix
        ];

        shellHook = ''
          echo "NixOS Config Development Shell"
          echo "Available tools: nixfmt, nil, statix, deadnix"
        '';
      };
    };
}
