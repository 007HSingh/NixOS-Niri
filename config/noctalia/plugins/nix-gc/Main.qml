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
        if (root.isCollecting) return;
        errorMsg = "";
        sizeProc.running = true;
    }

    function requestGC() {
        if (isCollecting) return;
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

    // Store size (with 15s timeout fallback)
    Process {
        id: sizeProc
        command: ["bash", "-c",
            "timeout 15 nix path-info -S --all 2>/dev/null | " +
            "awk '{s+=$2}END{if(s>1073741824)printf \"%.1fG\",s/1073741824; " +
            "else if(s>1048576)printf \"%.0fM\",s/1048576; else printf \"%.0fK\",s/1024}'"]
        running: false
        property var lines: []
        stdout: SplitParser { onRead: line => { sizeProc.lines.push(line.trim()); } }
        onRunningChanged: {
            if (running) { lines = []; return; }
            var out = lines.filter(l => l.length > 0).join("");
            root.storeSize = out.length > 0 ? out : "?";
            if (out.length === 0) root.errorMsg = "Store query timed out";
            lines = [];
            pathCountProc.running = true;
        }
    }

    Process {
        id: pathCountProc
        command: ["bash", "-c", "nix path-info --all 2>/dev/null | wc -l"]
        running: false
        property var lines: []
        stdout: SplitParser { onRead: line => { pathCountProc.lines.push(line.trim()); } }
        onRunningChanged: {
            if (running) { lines = []; return; }
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
        stdout: SplitParser { onRead: line => { genProc.lines.push(line.trim()); } }
        onRunningChanged: {
            if (running) { lines = []; return; }
            root.generationCount = lines.filter(l => l.length > 0).join("") || "?";
            lines = [];
        }
    }

    // GC — collect stdout, extract the "freed X bytes" summary line
    Process {
        id: gcProc
        command: ["nix-collect-garbage", "-d"]
        running: false
        property var outLines: []
        property var errLines: []
        stdout: SplitParser { onRead: line => { gcProc.outLines.push(line); } }
        stderr: SplitParser { onRead: line => { gcProc.errLines.push(line); } }
        onRunningChanged: {
            if (running) { outLines = []; errLines = []; return; }
            if (errLines.length > 0) {
                root.errorMsg = errLines[errLines.length - 1].trim();
            }
            // Extract the "freed X MiB" line nix-collect-garbage always emits
            var freed = outLines.filter(l => l.indexOf("freed") !== -1 ||
                                            l.indexOf("MiB") !== -1 ||
                                            l.indexOf("GiB") !== -1);
            root.gcSummary = freed.length > 0
                ? freed[freed.length - 1].trim()
                : (outLines.length > 0 ? outLines[outLines.length - 1].trim() : "Done");
            outLines = []; errLines = [];
            root.isCollecting = false;
            root.lastCollected = Qt.formatDateTime(new Date(), "HH:mm");
            root.refresh();
        }
    }
}
