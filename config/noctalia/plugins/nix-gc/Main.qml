import QtQuick
import Quickshell
import Quickshell.Io

// Periodically checks nix store size and provides garbage collection.
Item {
    id: root
    property var pluginApi: null

    // ── Exposed State ────────────────────────────────────────────────────────
    property string storeSize: "..."
    property string storePathCount: "..."
    property string generationCount: "..."
    property bool isCollecting: false
    property string lastCollected: "never"
    property string gcOutput: ""

    // ── Polling ──────────────────────────────────────────────────────────────
    Component.onCompleted: refresh()

    Timer {
        interval: 300000  // every 5 minutes
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    function refresh() {
        sizeProc.running = true;
    }

    // ── du -sh /nix/store ────────────────────────────────────────────────────
    Process {
        id: sizeProc
        command: ["du", "-sh", "/nix/store"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(/\s+/);
                if (parts.length >= 1) {
                    root.storeSize = parts[0];
                }
                pathCountProc.running = true;
            }
        }
    }

    // ── Count store paths ────────────────────────────────────────────────────
    Process {
        id: pathCountProc
        command: ["bash", "-c", "ls -1 /nix/store | wc -l"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                root.storePathCount = data.trim();
                genProc.running = true;
            }
        }
    }

    // ── nix-env generations ──────────────────────────────────────────────────
    Process {
        id: genProc
        command: ["bash", "-c", "nix-env --list-generations 2>/dev/null | wc -l"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                root.generationCount = data.trim();
            }
        }
    }

    // ── Garbage Collection ───────────────────────────────────────────────────
    function collectGarbage() {
        if (isCollecting) return;
        isCollecting = true;
        gcOutput = "Collecting...";
        gcProc.running = true;
    }

    Process {
        id: gcProc
        command: ["nix-collect-garbage", "-d"]
        running: false
        property string buf: ""
        stdout: SplitParser {
            onRead: data => { gcProc.buf += data + "\n"; }
        }
        onRunningChanged: {
            if (!running) {
                root.gcOutput = buf || "Done.";
                root.isCollecting = false;
                root.lastCollected = Qt.formatDateTime(new Date(), "hh:mm");
                buf = "";
                // Refresh sizes after GC
                root.refresh();
            }
        }
    }
}
