# Media: Spicetify (Spotify theming and extensions)
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.modules.home.media;
in
{
  options.modules.home.media.enable = lib.mkEnableOption "media apps (spicetify Spotify theming)";

  config = lib.mkIf cfg.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        enable = true;

        enabledExtensions = with spicePkgs.extensions; [
          adblock
          hidePodcasts
          shuffle
          playlistIcons
          beautifulLyrics
        ];
        enabledCustomApps = with spicePkgs.apps; [
          newReleases
          ncsVisualizer
        ];
        enabledSnippets = with spicePkgs.snippets; [
          rotatingCoverart
          pointer
        ];
      };
  };
}
