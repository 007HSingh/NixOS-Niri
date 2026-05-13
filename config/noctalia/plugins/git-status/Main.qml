import QtQuick
import Quickshell
import Quickshell.Io

// Periodically polls git status for ~/nixos-config.
Item {
    id: root
    property var pluginApi: null

    property string repoPath: Quickshell.env("HOME") + "/nixos-config"

    // ── Exposed State ────────────────────────────────────────────────────────
    property string branch: "—"
    property string lastCommitHash: ""
    property string lastCommitMsg: ""
    property string lastCommitTime: ""
    property int modifiedCount: 0
    property int untrackedCount: 0
    property int stagedCount: 0
    property bool isDirty: modifiedCount > 0 || untrackedCount > 0 || stagedCount > 0
    property bool hasData: branch !== "—"

    // ── Polling ──────────────────────────────────────────────────────────────
    Component.onCompleted: refresh()

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    function refresh() {
        branchProc.running = true;
    }

    // ── git branch --show-current ────────────────────────────────────────────
    Process {
        id: branchProc
        command: ["git", "-C", root.repoPath, "branch", "--show-current"]
        running: false
        property string buf: ""
        stdout: SplitParser {
            onRead: data => { branchProc.buf = data.trim(); }
        }
        onRunningChanged: {
            if (!running) {
                if (buf.length > 0) {
                    root.branch = buf;
                    buf = "";
                    statusProc.running = true;
                } else {
                    // Repo may not exist or isn't a git repo
                    root.branch = "—";
                    buf = "";
                }
            }
        }
    }

    // ── git status --porcelain ───────────────────────────────────────────────
    Process {
        id: statusProc
        command: ["git", "-C", root.repoPath, "status", "--porcelain"]
        running: false
        property string buf: ""
        stdout: SplitParser {
            onRead: data => { statusProc.buf += data + "\n"; }
        }
        onRunningChanged: {
            if (!running) {
                if (buf.length > 0) {
                    var lines = buf.trim().split("\n").filter(l => l.length > 0);
                    var m = 0, u = 0, s = 0;
                    for (var i = 0; i < lines.length; i++) {
                        var code = lines[i].substring(0, 2);
                        if (code === "??") u++;
                        else if (code[0] !== " " && code[0] !== "?") s++;
                        else m++;
                    }
                    root.modifiedCount = m;
                    root.untrackedCount = u;
                    root.stagedCount = s;
                } else {
                    root.modifiedCount = 0;
                    root.untrackedCount = 0;
                    root.stagedCount = 0;
                }
                buf = "";
                commitProc.running = true;
            }
        }
    }

    // ── git log -1 ───────────────────────────────────────────────────────────
    // Using unit separator (\x1f) to avoid collision with pipes in commit messages
    Process {
        id: commitProc
        command: ["git", "-C", root.repoPath, "log", "-1", "--format=%h%x1f%s%x1f%cr"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split("\x1f");
                if (parts.length >= 3) {
                    root.lastCommitHash = parts[0];
                    root.lastCommitMsg = parts[1];
                    root.lastCommitTime = parts[2];
                }
            }
        }
    }
}
