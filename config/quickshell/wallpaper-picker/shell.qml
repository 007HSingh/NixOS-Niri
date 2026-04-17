import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

// Root shell for the wallpaper picker.
// Launched via: qs -c wallpaper-picker
// Niri bind: Mod+Shift+W  →  qs -c wallpaper-picker
ShellRoot {

    // ── Poll /tmp/qs_widget_state for "close" ─────────────────────────────────
    // The apply script writes 'close' there after firing awww.
    // We use a Timer + Process instead of FileView to avoid crashes when the
    // file doesn't exist yet.
    Timer {
        id: closePoller
        interval: 200
        repeat: true
        running: true
        onTriggered: closeReader.running = true
    }

    Process {
        id: closeReader
        command: ["bash", "-c", "cat /tmp/qs_widget_state 2>/dev/null || true"]
        stdout: SplitParser {
            onRead: (line) => {
                if (line.trim() === "close") {
                    // Clear the file so we don't re-trigger
                    closeWriter.running = true
                    Qt.quit()
                }
            }
        }
    }

    Process {
        id: closeWriter
        command: ["bash", "-c", "echo '' > /tmp/qs_widget_state"]
    }

    // ── Fullscreen layer surface ──────────────────────────────────────────────
    PanelWindow {
        id: pickerWindow
        screen: Quickshell.screens[0]

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        anchors {
            top: true; bottom: true; left: true; right: true
        }

        color: "transparent"

        Shortcut {
            sequence: "Escape"
            context: Qt.ApplicationShortcut
            onActivated: Qt.quit()
        }

        WallpaperPicker {
            anchors.fill: parent
        }
    }
}
