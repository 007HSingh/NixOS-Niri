# Spicetify Configuration
# Spotify theming and extensions
{ pkgs, inputs, ... }:

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
    # theme = spicePkgs.themes.catppuccin; # Managed by Stylix
    # colorScheme = "mocha"; # Managed by Stylix
  };
}
