# Flake-parts module: Treefmt configuration
{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      # Treefmt configuration
      treefmt = {
        # Used to find the project root
        projectRootFile = "flake.nix";

        # Individual formatters
        programs = {
          # Nix
          nixfmt.enable = true;

          # Lua
          stylua.enable = true;

          # Shell
          shfmt.enable = true;

          # JSON, YAML, Markdown, etc.
          prettier.enable = true;
        };

        # Settings for specific formatters
        settings.formatter = {
          shfmt.includes = [ "*.sh" ];
          stylua.includes = [ "*.lua" ];
        };
      };
    };
}
