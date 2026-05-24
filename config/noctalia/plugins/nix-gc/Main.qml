import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    property var pluginApi: null

    property string storeSize: "..."
    property string storePathCount: "..."
    property string generationCount: "..."
    property bool isCollecting: false
    property bool gcConfirmPending: false
    property string lastCollected: "never"
    property string gcSummary: ""
    property string errorMsg: ""

    Component.onCompleted: refresh()

    Timer {
        interval: 300000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Timer {
        id: confirmTimer
        interval: 5000
        running: false
        onTriggered: root.gcConfirmPending = false
    }

    function refresh() {
        if (root.isCollecting)
            return;
        errorMsg = "";
        sizeProc.running = true;
    }

    function requestGC() {
        if (isCollecting)
            return;
        if (!gcConfirmPending) {
            gcConfirmPending = true;
            confirmTimer.restart();
            return;
        }
        confirmTimer.stop();
        gcConfirmPending = false;
        isCollecting = true;
        gcSummary = "Collecting…";
        errorMsg = "";
        gcProc.running = true;
    }

    function cancelGC() {
        confirmTimer.stop();
        gcConfirmPending = false;
    }

    // Bug 3 fix: use `du` instead of `nix path-info --all` (instant vs. 30s+)
    Process {
        id: sizeProc
        command: ["bash", "-c", "du -sh /nix/store 2>/dev/null | cut -f1"]
        running: false
        property var lines: []
        stdout: SplitParser {
            onRead: line => {
                sizeProc.lines.push(line.trim());
            }
        }
        onRunningChanged: {
            if (running) {
                lines = [];
                return;
            }
            var out = lines.filter(l => l.length > 0).join("");
            root.storeSize = out.length > 0 ? out : "?";
            lines = [];
            pathCountProc.running = true;
        }
    }

    Process {
        id: pathCountProc
        command: ["bash", "-c", "nix path-info --all 2>/dev/null | wc -l"]
        running: false
        property var lines: []
        stdout: SplitParser {
            onRead: line => {
                pathCountProc.lines.push(line.trim());
            }
        }
        onRunningChanged: {
            if (running) {
                lines = [];
                return;
            }
            root.storePathCount = lines.filter(l => l.length > 0).join("") || "?";
            lines = [];
            genProc.running = true;
        }
    }

    Process {
        id: genProc
        command: ["bash", "-c", "nix-env --list-generations 2>/dev/null | wc -l"]
        running: false
        property var lines: []
        stdout: SplitParser {
            onRead: line => {
                genProc.lines.push(line.trim());
            }
        }
        onRunningChanged: {
            if (running) {
                lines = [];
                return;
            }
            root.generationCount = lines.filter(l => l.length > 0).join("") || "?";
            lines = [];
        }
    }

    // Bug 2 fix: use pkexec so GC actually has permission to delete store paths
    Process {
        id: gcProc
        command: ["pkexec", "nix-collect-garbage", "-d"]
        running: false
        property var outLines: []
        property var errLines: []
        stdout: SplitParser {
            onRead: line => {
                gcProc.outLines.push(line);
            }
        }
        stderr: SplitParser {
            onRead: line => {
                gcProc.errLines.push(line);
            }
        }
        onRunningChanged: {
            if (running) {
                outLines = [];
                errLines = [];
                return;
            }
            if (errLines.length > 0) {
                root.errorMsg = errLines[errLines.length - 1].trim();
            }
            var freed = outLines.filter(l => l.indexOf("freed") !== -1 || l.indexOf("MiB") !== -1 || l.indexOf("GiB") !== -1);
            root.gcSummary = freed.length > 0 ? freed[freed.length - 1].trim() : (outLines.length > 0 ? outLines[outLines.length - 1].trim() : "Done");
            outLines = [];
            errLines = [];
            root.isCollecting = false;
            root.lastCollected = Qt.formatDateTime(new Date(), "HH:mm");
            root.refresh();
        }
    }
}
