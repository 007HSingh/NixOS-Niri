import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

// Root shell for the MPRIS widget.
// Launched via: qs -c mpris-widget
ShellRoot {
    id: root

    property string mprisStatus: "Stopped"
    property string mprisTitle: "No Title"
    property string mprisArtist: "No Artist"
    property string mprisArtUrl: ""
    property real mprisLength: 0
    property real mprisPosition: 0

    Component.onCompleted: {
        Qt.application.name = "MprisWidget"
        mprisFollower.running = true
        initialMetadataFetcher.running = true
    }

    // ── Initial Fetch ────────────────────────────────────────────────────────
    Process {
        id: initialMetadataFetcher
        command: ["playerctl", "metadata", "--format", "{{status}}::|::{{title}}::|::{{artist}}::|::{{mpris:artUrl}}::|::{{mpris:length}}"]
        stdout: SplitParser {
            onRead: (line) => updateMetadata(line)
        }
    }

    // ── Metadata Follower ────────────────────────────────────────────────────
    Process {
        id: mprisFollower
        command: ["playerctl", "metadata", "--format", "{{status}}::|::{{title}}::|::{{artist}}::|::{{mpris:artUrl}}::|::{{mpris:length}}", "--follow"]
        stdout: SplitParser {
            onRead: (line) => updateMetadata(line)
        }
    }

    function updateMetadata(line) {
        let parts = line.split("::|::");
        if (parts.length >= 5) {
            mprisStatus = parts[0];
            mprisTitle = parts[1] || "No Title";
            mprisArtist = parts[2] || "No Artist";
            mprisArtUrl = parts[3] || "";
            mprisLength = parseFloat(parts[4]) || 0;
            
            if (mprisArtUrl === "" && mprisStatus !== "Stopped") {
                artUrlFetcher.running = true;
            }
        }
    }

    Process {
        id: artUrlFetcher
        command: ["playerctl", "metadata", "mpris:artUrl"]
        stdout: SplitParser {
            onRead: (line) => {
                if (line.trim() !== "") mprisArtUrl = line.trim();
            }
        }
    }

    // ── Position Poller ──────────────────────────────────────────────────────
    Timer {
        id: positionTimer
        interval: 1000
        repeat: true
        running: mprisStatus === "Playing"
        onTriggered: positionPoller.running = true
    }

    Process {
        id: positionPoller
        command: ["playerctl", "position"]
        stdout: SplitParser {
            onRead: (line) => {
                mprisPosition = parseFloat(line) * 1000000;
            }
        }
    }

    // ── Actions ──────────────────────────────────────────────────────────────
    function playPause() {
        actionRunner.command = ["playerctl", "play-pause"];
        actionRunner.running = true;
    }

    function next() {
        actionRunner.command = ["playerctl", "next"];
        actionRunner.running = true;
    }

    function previous() {
        actionRunner.command = ["playerctl", "previous"];
        actionRunner.running = true;
    }

    Process { id: actionRunner }

    // ── Window ────────────────────────────────────────────────────────────────
    PanelWindow {
        id: mprisWindow
        screen: Quickshell.screens[0]

        // Fix: Only visible when active or animating to avoid blocking input when hidden
        visible: isActive || widget.opacity > 0

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        
        // Grab focus only when active
        WlrLayershell.keyboardFocus: (isActive) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
        
        property bool isActive: mprisStatus === "Playing" || mprisStatus === "Paused"

        anchors {
            bottom: true
            left: true
            right: true
        }
        
        WlrLayershell.margins {
            bottom: 35 // Lift the window from the bottom edge
            left: (mprisWindow.screen.width - 600) / 2
            right: (mprisWindow.screen.width - 600) / 2
        }
        
        implicitWidth: 600
        implicitHeight: 180 // Exact widget height to minimize input blocking area
        color: "transparent"

        MprisWidget {
            id: widget
            width: parent.width
            height: 180
            
            // Internal sliding animation - slides from bottom of window (y=180) to top (y=0)
            y: mprisWindow.isActive ? 0 : parent.height
            
            Behavior on y {
                NumberAnimation { duration: 600; easing.type: Easing.OutBack }
            }
            
            opacity: mprisWindow.isActive ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }

            focus: true 
            
            status: root.mprisStatus
            title: root.mprisTitle
            artist: root.mprisArtist
            artUrl: root.mprisArtUrl
            length: root.mprisLength
            position: root.mprisPosition
            
            onPlayPauseClicked: root.playPause()
            onNextClicked: root.next()
            onPrevClicked: root.previous()

            Keys.onEscapePressed: Qt.quit()
        }
    }
}
