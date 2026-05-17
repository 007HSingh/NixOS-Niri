import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    property var pluginApi: null

    property string repoPath: Quickshell.env("HOME") + "/nixos-config"

    // Exposed state
    property string branch: "—"
    property string lastCommitHash: ""
    property string lastCommitMsg: ""
    property string lastCommitTime: ""
    property int modifiedCount: 0
    property int untrackedCount: 0
    property int stagedCount: 0
    property bool isDirty: modifiedCount > 0 || untrackedCount > 0 || stagedCount > 0
    property bool hasData: branch !== "—"
    property bool isRefreshing: false

    Component.onCompleted: refresh()

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    function refresh() {
        if (root.isRefreshing)
            return;
        root.isRefreshing = true;
        branchProc.running = true;
    }

    // git branch --show-current
    Process {
        id: branchProc
        command: ["git", "-C", root.repoPath, "branch", "--show-current"]
        running: false
        property var lines: []
        stdout: SplitParser {
            onRead: line => {
                branchProc.lines.push(line.trim());
            }
        }
        onRunningChanged: {
            if (running) {
                lines = [];
                return;
            }
            var b = lines.filter(l => l.length > 0).join("");
            root.branch = b.length > 0 ? b : "—";
            lines = [];
            statusProc.running = true;
        }
    }

    // git status --porcelain
    Process {
        id: statusProc
        command: ["git", "-C", root.repoPath, "status", "--porcelain"]
        running: false
        property var lines: []
        stdout: SplitParser {
            onRead: line => {
                if (line.length > 0)
                    statusProc.lines.push(line);
            }
        }
        onRunningChanged: {
            if (running) {
                lines = [];
                return;
            }
            var m = 0, u = 0, s = 0;
            for (var i = 0; i < lines.length; i++) {
                var xy = lines[i].substring(0, 2);
                if (xy === "??")
                    u++;
                else if (xy[0] !== " " && xy[0] !== "?")
                    s++;
                else
                    m++;
            }
            root.modifiedCount = m;
            root.untrackedCount = u;
            root.stagedCount = s;
            lines = [];
            commitProc.running = true;
        }
    }

    // git log -1
    Process {
        id: commitProc
        command: ["git", "-C", root.repoPath, "log", "-1", "--format=%h%x1f%s%x1f%cr"]
        running: false
        property var lines: []
        stdout: SplitParser {
            onRead: line => {
                if (line.trim().length > 0)
                    commitProc.lines.push(line.trim());
            }
        }
        onRunningChanged: {
            if (running) {
                lines = [];
                return;
            }
            if (lines.length > 0) {
                var parts = lines[0].split("\x1f");
                root.lastCommitHash = parts.length > 0 ? parts[0] : "";
                root.lastCommitMsg = parts.length > 1 ? parts[1] : "";
                root.lastCommitTime = parts.length > 2 ? parts[2] : "";
            }
            lines = [];
            root.isRefreshing = false;
        }
    }
}
