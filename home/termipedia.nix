# Termipedia - Wikipedia for the terminal
# Packages the upstream shell script as a Nix derivation.
# Source: https://github.com/kantiankant/Termipedia
{ pkgs, ... }:

let
  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/kantiankant/Termipedia/main/termipedia.sh";
    hash = "sha256-mnmQZ5R9sEwL6J55PTeP3jaOP6MbqQ711FEoOH7BRkY=";
  };

  termipedia = pkgs.stdenv.mkDerivation {
    pname = "termipedia";
    version = "unstable";

    dontUnpack = true;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      install -Dm755 ${src} $out/bin/termipedia
      wrapProgram $out/bin/termipedia \
        --prefix PATH : ${
          pkgs.lib.makeBinPath (
            with pkgs;
            [
              curl
              jq
              fzf
              less
            ]
          )
        }
    '';
  };
in
{
  home.packages = [ termipedia ];
}
