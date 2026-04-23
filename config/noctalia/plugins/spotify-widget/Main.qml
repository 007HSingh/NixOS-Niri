import QtQuick
import Quickshell
import qs.Services.Media

// Shared state for the Spotify widget plugin.
// Exposes whether Spotify is the active player.
Item {
    id: root
    property var pluginApi: null

    readonly property bool isSpotify: {
        if (!MediaService.currentPlayer) return false;
        let identity = (MediaService.playerIdentity || "").toLowerCase();
        return identity.includes("spotify");
    }

    readonly property bool isPlaying: isSpotify && MediaService.isPlaying
}
