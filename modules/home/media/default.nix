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

        # Catppuccin Mocha — matches the rest of the system
        theme = lib.mkForce spicePkgs.themes.catppuccin;
        colorScheme = lib.mkForce "mocha";

        enabledExtensions = with spicePkgs.extensions; [
          adblock # Block ads & promoted content
          hidePodcasts # Remove podcast clutter
          shuffle # True shuffle (no repeat bias)
          playlistIcons # Folder/playlist icons
          spicyLyrics # Animated synced lyrics (replaces beautifulLyrics)
          fullAppDisplay # Immersive full-screen now playing
          volumePercentage # Show volume % on scroll
          seekSong # Seek with arrow keys
          keyboardShortcut # Extra keyboard shortcuts
          skipStats # Skip count overlay
        ];

        enabledCustomApps = with spicePkgs.apps; [
          newReleases # New releases feed
          ncsVisualizer # Audio visualizer
        ];

        enabledSnippets = with spicePkgs.snippets; [
          # Visual polish
          rotatingCoverart # Album art rotates while playing
          circularAlbumArt # Round album art in now playing bar
          smoothProgressBar # Eased progress bar animation
          roundedImages # Rounded corners on cards/images
          modernScrollbar # Thin styled scrollbar
          hoverPanels # Reveal panels on hover

          # Layout cleanup
          declutterNowPlayingBar # Hide excess icons in player bar
          removeTopSpacing # Remove wasted top padding
          removeUnusedSpace # Tighten sidebar padding
          centeredLyrics # Centre-align lyrics view
          hideSidebarScrollbar # Hide sidebar scrollbar (cleaner)
          removeGradient # Remove the header gradient blob

          # Pointer
          pointer # Custom cursor in Spotify
        ];
      };
  };
}
