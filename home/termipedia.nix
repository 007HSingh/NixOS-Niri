# Termipedia - Wikipedia for the terminal
# Packages the upstream shell script as a Nix derivation.
# Source: https://github.com/kantiankant/Termipedia
{ pkgs, ... }:

let
  termipedia = pkgs.writeShellApplication {
    name = "termipedia";

    runtimeInputs = with pkgs; [
      curl
      jq
      fzf
      less
    ];

    text = builtins.readFile (
      pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/kantiankant/Termipedia/main/termipedia.sh";
        hash = "sha256-mnmQZ5R9sEwL6J55PTeP3jaOP6MbqQ711FEoOH7BRkY=";
      }
    );
  };
in
{
  home.packages = [ termipedia ];
}
