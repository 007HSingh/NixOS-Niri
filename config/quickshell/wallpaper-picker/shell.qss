import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

// Root shell for the wallpaper picker.
// Launched via: qs -c ~/.config/quickshell/wallpaper-picker/shell.qss
// Niri bind: Mod+Shift+W
ShellRoot {
    // ── IPC: listen for "close" written to /tmp/qs_widget_state ──────────────
    // The apply script writes 'close' after firing awww, so the picker dismisses
    // itself as soon as the wallpaper starts transitioning.
    IpcHandler {
        target: "widget_state"
        function onMessage(msg) {
            if (msg.trim() === "close") Qt.quit()
        }
    }

    // ── File-based close signal (polling fallback) ────────────────────────────
    // Watches /tmp/qs_widget_state every 200 ms. If the apply script writes
    // "close" before IPC fires, this catches it.
    FileView {
        id: stateFile
        path: "/tmp/qs_widget_state"
        watchChanges: true
        onTextChanged: {
            if (text.trim() === "close") Qt.quit()
        }
    }

    // ── Fullscreen layer surface ──────────────────────────────────────────────
    PanelWindow {
        id: pickerWindow
        screen: Quickshell.screens[0]

        // Cover the entire screen above all windows
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        anchors {
            top: true; bottom: true; left: true; right: true
        }

        // Transparent background — the picker renders its own frosted glass bar
        color: "transparent"

        // Close on Escape when not in search mode (search mode uses its own Escape handler)
        Shortcut {
            sequence: "Escape"
            onActivated: Qt.quit()
        }

        WallpaperPicker {
            anchors.fill: parent
        }
    }
}
