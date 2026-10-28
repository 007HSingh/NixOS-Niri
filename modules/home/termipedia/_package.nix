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
  version = "unstable-2026-05-06";

  src = fetchFromGitHub {
    owner = "kantiankant";
    repo = "Termipedia";
    rev = "7e6056d1de631ca4f6a7660e74fc5fb56cbbedc4";
    hash = "sha256-EJjkN9kJp6Af6CSyonkcBdsNWbzRfax88WdHdrWYChk=";
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
