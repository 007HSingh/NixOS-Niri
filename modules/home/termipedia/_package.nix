{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  curl,
  jq,
  fzf,
  less,
  ...
}:

stdenv.mkDerivation {
  pname = "termipedia";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "kantiankant";
    repo = "Termipedia";
    rev = "main";
    hash = "sha256-r9zZaCjTFAzcIVWpPFHx9eO+Ui1Mld/XGexPyWXj754=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 termipedia $out/bin/termipedia

    wrapProgram $out/bin/termipedia \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          jq
          fzf
          less
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Wikipedia for the terminal";
    homepage = "https://github.com/kantiankant/Termipedia";
    license = lib.licenses.gpl3Only;
    mainProgram = "termipedia";
    platforms = lib.platforms.all;
  };
}
