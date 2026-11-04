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

        theme = lib.mkForce spicePkgs.themes.catppuccin;
        colorScheme = lib.mkForce "mocha";

        enabledExtensions = with spicePkgs.extensions; [
          adblock
          hidePodcasts
          shuffle
          playlistIcons
          spicyLyrics
          fullAppDisplay
          volumePercentage
          seekSong
          keyboardShortcut
          skipStats
        ];

        enabledCustomApps = with spicePkgs.apps; [
          newReleases
          ncsVisualizer
        ];

        enabledSnippets = with spicePkgs.snippets; [
          rotatingCoverart
          circularAlbumArt
          smoothProgressBar
          roundedImages
          modernScrollbar
          hoverPanels

          declutterNowPlayingBar
          removeTopSpacing
          removeUnusedSpace
          centeredLyrics
          hideSidebarScrollbar
          removeGradient

          pointer
        ];
      };
  };
}
