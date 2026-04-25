import QtQuick
import Quickshell
import Quickshell.Io

// Pomodoro timer state machine.
// States: idle → work → shortBreak → work → ... → longBreak (after 4 work sessions)
Item {
    id: root
    property var pluginApi: null

    // ── Timer State ──────────────────────────────────────────────────────────
    property string phase: "idle"      // idle, work, shortBreak, longBreak
    property int totalSeconds: 0       // total for current phase
    property int remainingSeconds: 0   // countdown
    property int sessionsCompleted: 0  // work sessions done
    property bool running: false

    readonly property int workDuration: 60 * 60
    readonly property int shortBreakDuration: 5 * 60
    readonly property int longBreakDuration: 15 * 60
    readonly property int sessionsBeforeLongBreak: 4

    readonly property real progress: totalSeconds > 0 ? (1.0 - remainingSeconds / totalSeconds) : 0
    readonly property string timeString: {
        var m = Math.floor(remainingSeconds / 60);
        var s = remainingSeconds % 60;
        return m + ":" + (s < 10 ? "0" : "") + s;
    }

    // ── Core Timer ───────────────────────────────────────────────────────────
    Timer {
        id: ticker
        interval: 1000
        running: root.running && root.remainingSeconds > 0
        repeat: true
        onTriggered: {
            root.remainingSeconds--;
            if (root.remainingSeconds <= 0) {
                root.onPhaseComplete();
            }
        }
    }

    function start() {
        if (phase === "idle") {
            startWork();
        }
        running = true;
    }

    function pause() {
        running = false;
    }

    function togglePause() {
        if (phase === "idle") {
            start();
        } else {
            running = !running;
        }
    }

    function reset() {
        running = false;
        phase = "idle";
        remainingSeconds = 0;
        totalSeconds = 0;
        sessionsCompleted = 0;
    }

    function skip() {
        onPhaseComplete();
    }

    function startWork() {
        phase = "work";
        totalSeconds = workDuration;
        remainingSeconds = workDuration;
        running = true;
        notify("🍅 Focus Time", "60 minutes of deep work. Let's go!");
    }

    function startShortBreak() {
        phase = "shortBreak";
        totalSeconds = shortBreakDuration;
        remainingSeconds = shortBreakDuration;
        running = true;
        notify("☕ Short Break", "5 minute break. Stretch and breathe.");
    }

    function startLongBreak() {
        phase = "longBreak";
        totalSeconds = longBreakDuration;
        remainingSeconds = longBreakDuration;
        running = true;
        notify("🎉 Long Break", "Great work! Take a 15 minute break.");
    }

    function onPhaseComplete() {
        running = false;
        if (phase === "work") {
            sessionsCompleted++;
            if (sessionsCompleted % sessionsBeforeLongBreak === 0) {
                startLongBreak();
            } else {
                startShortBreak();
            }
        } else {
            // Break is over, start next work session
            startWork();
        }
    }

    // ── Notifications ────────────────────────────────────────────────────────
    function notify(summary, body) {
        notifyProc.command = ["notify-send", "--app-name=Pomodoro", "--icon=alarm-symbolic", summary, body];
        notifyProc.running = true;
    }

    Process {
        id: notifyProc
        running: false
    }
}
