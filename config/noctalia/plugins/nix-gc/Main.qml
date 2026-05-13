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
    property bool gcConfirmPending: false
    property string lastCollected: "never"
    property string gcOutput: ""
    property string errorMsg: ""

    // ── Polling ──────────────────────────────────────────────────────────────
    Component.onCompleted: refresh()

    Timer {
        interval: 300000  // every 5 minutes
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    // Auto-dismiss confirmation after 5 seconds
    Timer {
        id: confirmTimer
        interval: 5000
        running: gcConfirmPending
        onTriggered: root.gcConfirmPending = false
    }

    function refresh() {
        errorMsg = "";
        sizeProc.running = true;
    }

    // ── Nix store size via nix path-info ─────────────────────────────────────
    Process {
        id: sizeProc
        command: ["bash", "-c", "nix path-info -S --all 2>/dev/null | awk '{s+=$2}END{if(s>1073741824)printf \"%.1fG\",s/1073741824; else if(s>1048576)printf \"%.0fM\",s/1048576; else printf \"%.0fK\",s/1024}'"]
        running: false
        property string buf: ""
        stdout: SplitParser {
            onRead: data => { sizeProc.buf = data.trim(); }
        }
        onRunningChanged: {
            if (!running) {
                if (buf.length > 0) {
                    root.storeSize = buf;
                } else {
                    root.storeSize = "?";
                    root.errorMsg = "Could not query store size";
                }
                buf = "";
                pathCountProc.running = true;
            }
        }
    }

    // ── Count store paths via nix path-info ──────────────────────────────────
    Process {
        id: pathCountProc
        command: ["bash", "-c", "nix path-info --all 2>/dev/null | wc -l"]
        running: false
        property string buf: ""
        stdout: SplitParser {
            onRead: data => { pathCountProc.buf = data.trim(); }
        }
        onRunningChanged: {
            if (!running) {
                root.storePathCount = buf.length > 0 ? buf : "?";
                buf = "";
                genProc.running = true;
            }
        }
    }

    // ── nix-env generations ──────────────────────────────────────────────────
    Process {
        id: genProc
        command: ["bash", "-c", "nix-env --list-generations 2>/dev/null | wc -l"]
        running: false
        property string buf: ""
        stdout: SplitParser {
            onRead: data => { genProc.buf = data.trim(); }
        }
        onRunningChanged: {
            if (!running) {
                root.generationCount = buf.length > 0 ? buf : "?";
                buf = "";
            }
        }
    }

    // ── Garbage Collection ───────────────────────────────────────────────────
    function requestGC() {
        if (isCollecting) return;
        if (!gcConfirmPending) {
            // First click: enter confirmation state
            gcConfirmPending = true;
            return;
        }
        // Second click: actually run GC
        gcConfirmPending = false;
        isCollecting = true;
        gcOutput = "Collecting...";
        errorMsg = "";
        gcProc.running = true;
    }

    function cancelGC() {
        gcConfirmPending = false;
    }

    Process {
        id: gcProc
        command: ["nix-collect-garbage"]
        running: false
        property string buf: ""
        property string errBuf: ""
        stdout: SplitParser {
            onRead: data => { gcProc.buf += data + "\n"; }
        }
        stderr: SplitParser {
            onRead: data => { gcProc.errBuf += data + "\n"; }
        }
        onRunningChanged: {
            if (!running) {
                if (errBuf.length > 0) {
                    root.errorMsg = errBuf.trim();
                    root.gcOutput = buf.length > 0 ? buf.trim() : "Completed with errors.";
                } else {
                    root.gcOutput = buf.length > 0 ? buf.trim() : "Done — nothing to collect.";
                }
                root.isCollecting = false;
                root.lastCollected = Qt.formatDateTime(new Date(), "hh:mm");
                buf = "";
                errBuf = "";
                // Refresh sizes after GC
                root.refresh();
            }
        }
    }
}
