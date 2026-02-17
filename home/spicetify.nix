# Spicetify Configuration
# Spotify theming and extensions
{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.spicetify = {
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
    theme = lib.mkForce spicePkgs.themes.text;
  };
}
