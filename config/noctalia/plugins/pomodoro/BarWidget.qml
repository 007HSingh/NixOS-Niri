import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Services.UI

Item {
    id: root

    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""
    property int sectionWidgetIndex: -1
    property int sectionWidgetsCount: 0

    readonly property string screenName: screen?.name ?? ""
    readonly property string barPosition: Settings.getBarPositionForScreen(screenName)
    readonly property bool barIsVertical: barPosition === "left" || barPosition === "right"
    readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)

    readonly property var m: root.pluginApi?.mainInstance ?? null
    readonly property string phase: m?.phase ?? "idle"
    readonly property string timeString: m?.timeString ?? "25:00"
    readonly property real progress: m?.progress ?? 0
    readonly property bool running: m?.running ?? false

    property string tooltipText: {
        if (phase === "idle") return "Pomodoro — Click to start";
        var label = phase === "work" ? "Focus" : phase === "shortBreak" ? "Short Break" : "Long Break";
        return label + " — " + timeString + (running ? "" : " (paused)");
    }
    property string tooltipDirection: BarService.getTooltipDirection()
    property bool enabled: true

    readonly property real contentWidth: barIsVertical ? capsuleHeight : Math.round(80 * Style.uiScaleRatio)
    readonly property real contentHeight: capsuleHeight

    implicitWidth: contentWidth
    implicitHeight: contentHeight

    signal entered
    signal exited
    signal clicked

    function openPanel() { if (pluginApi) pluginApi.openPanel(root.screen); }

    // ── Capsule ──────────────────────────────────────────────────────────────
    Rectangle {
        id: capsule
        anchors.fill: parent
        radius: Math.min(Style.radiusL, height / 2)
        color: mouseArea.containsMouse ? Color.mHover : Style.capsuleColor
        border.color: Style.capsuleBorderColor
        border.width: Style.capsuleBorderWidth

        Behavior on color { ColorAnimation { duration: Style.animationNormal } }

        // Progress fill arc background
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: {
                if (phase === "work") return Qt.rgba(Color.mPrimary.r, Color.mPrimary.g, Color.mPrimary.b, 0.15);
                if (phase === "shortBreak") return Qt.rgba(Color.mTertiary.r, Color.mTertiary.g, Color.mTertiary.b, 0.15);
                return Qt.rgba(Color.mSecondary.r, Color.mSecondary.g, Color.mSecondary.b, 0.15);
            }
            Behavior on color { ColorAnimation { duration: 600 } }
        }

        // Progress fill (left-to-right)
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2
            width: (parent.width - 4) * progress
            radius: parent.radius
            color: {
                if (phase === "work") return Qt.rgba(Color.mPrimary.r, Color.mPrimary.g, Color.mPrimary.b, 0.35);
                if (phase === "shortBreak") return Qt.rgba(Color.mTertiary.r, Color.mTertiary.g, Color.mTertiary.b, 0.35);
                return Qt.rgba(Color.mSecondary.r, Color.mSecondary.g, Color.mSecondary.b, 0.35);
            }
            Behavior on width { NumberAnimation { duration: 800; easing.type: Easing.OutQuad } }
            Behavior on color { ColorAnimation { duration: 600 } }
        }

        // Content row
        Row {
            anchors.centerIn: parent
            spacing: 4

            // Tomato / break icon
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: phase === "work" ? "🍅" : phase === "idle" ? "🍅" : "☕"
                font.pixelSize: 13

                SequentialAnimation on scale {
                    running: running
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.15; duration: 800; easing.type: Easing.OutQuad }
                    NumberAnimation { to: 1.0;  duration: 800; easing.type: Easing.InQuad }
                }
                scale: 1.0
            }

            // Timer text
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: phase === "idle" ? "start" : timeString
                font.family: "Maple Mono NF"
                font.pixelSize: Style.fontSizeS
                font.bold: phase !== "idle"
                color: {
                    if (mouseArea.containsMouse) return Color.mOnHover;
                    if (phase === "work") return Color.mPrimary;
                    if (phase === "shortBreak" || phase === "longBreak") return Color.mTertiary;
                    return Color.mOnSurfaceVariant;
                }
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function(mouse) {
            TooltipService.hide();
            if (mouse.button === Qt.LeftButton) {
                openPanel();
                root.clicked();
            }
        }
        onEntered: {
            TooltipService.show(root, root.tooltipText, root.tooltipDirection);
            root.entered();
        }
        onExited: {
            TooltipService.hide();
            root.exited();
        }
    }
}
