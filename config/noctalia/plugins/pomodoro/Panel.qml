import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

Item {
    id: root
    property var pluginApi: null

    readonly property var geometryPlaceholder: panelBg
    readonly property bool allowAttach: true
    property real contentPreferredWidth: 300 * Style.uiScaleRatio
    property real contentPreferredHeight: 320 * Style.uiScaleRatio

    anchors.fill: parent

    readonly property var m: root.pluginApi?.mainInstance ?? null
    readonly property string phase: m?.phase ?? "idle"
    readonly property string timeString: m?.timeString ?? "25:00"
    readonly property real progress: m?.progress ?? 0
    readonly property bool running: m?.running ?? false
    readonly property int sessions: m?.sessionsCompleted ?? 0

    readonly property color phaseColor: {
        if (phase === "work") return Color.mPrimary;
        if (phase === "shortBreak") return Color.mTertiary;
        if (phase === "longBreak") return Color.mSecondary;
        return Color.mOnSurfaceVariant;
    }

    readonly property string phaseLabel: {
        if (phase === "work") return "Focus";
        if (phase === "shortBreak") return "Short Break";
        if (phase === "longBreak") return "Long Break";
        return "Ready";
    }

    Rectangle {
        id: panelBg
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            anchors.margins: Style.marginL
            color: Color.mSurface
            radius: Style.radiusL
            border.color: Color.mOutline
            border.width: Style.borderS

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.marginXL
                spacing: Style.marginL

                // ── Big Tomato + Phase Label ─────────────────────────────
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Style.marginXS

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: phase === "work" || phase === "idle" ? "🍅" : "☕"
                        font.pixelSize: 48

                        SequentialAnimation on scale {
                            running: root.running
                            loops: Animation.Infinite
                            NumberAnimation { to: 1.1; duration: 900; easing.type: Easing.OutQuad }
                            NumberAnimation { to: 1.0; duration: 900; easing.type: Easing.InQuad }
                        }
                        scale: 1.0
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: phaseLabel
                        font.family: "Comfortaa"
                        font.pixelSize: Style.fontSizeXL
                        font.bold: true
                        color: phaseColor
                        Behavior on color { ColorAnimation { duration: 400 } }
                    }
                }

                // ── Big Timer Display ────────────────────────────────────
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: timeString
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 52 * Style.uiScaleRatio
                    font.bold: true
                    color: Color.mOnSurface
                }

                // ── Progress Bar ─────────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 6
                    radius: 3
                    color: Color.mSurfaceVariant

                    Rectangle {
                        width: parent.width * progress
                        height: parent.height
                        radius: parent.radius
                        color: phaseColor
                        Behavior on width { NumberAnimation { duration: 800; easing.type: Easing.OutQuad } }
                        Behavior on color { ColorAnimation { duration: 400 } }
                    }
                }

                // ── Session Dots (4 dots = 1 long break cycle) ───────────
                Row {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8

                    Repeater {
                        model: 4
                        Rectangle {
                            required property int index
                            width: 10; height: 10; radius: 5
                            color: index < (sessions % 4) ? Color.mPrimary : Color.mSurfaceVariant
                            Behavior on color { ColorAnimation { duration: 300 } }
                        }
                    }
                }

                // ── Controls ─────────────────────────────────────────────
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Style.marginL

                    // Reset
                    Rectangle {
                        width: 40; height: 40; radius: 20
                        color: resetMouse.containsMouse ? Color.mSurfaceVariant : "transparent"
                        border.color: Color.mOutline
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 150 } }

                        Text {
                            anchors.centerIn: parent
                            text: "↺"
                            font.pixelSize: 20
                            color: Color.mOnSurfaceVariant
                        }
                        MouseArea {
                            id: resetMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (m) m.reset()
                        }
                        scale: resetMouse.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }
                    }

                    // Play/Pause
                    Rectangle {
                        width: 60; height: 60; radius: 30
                        color: phaseColor
                        Behavior on color { ColorAnimation { duration: 400 } }

                        Text {
                            anchors.centerIn: parent
                            text: running ? "⏸" : "▶"
                            font.pixelSize: 22
                            color: Color.mOnPrimary
                            anchors.horizontalCenterOffset: running ? 0 : 2
                        }
                        scale: playMouse.containsMouse ? 1.05 : 1.0
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                        MouseArea {
                            id: playMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (m) m.togglePause()
                        }
                    }

                    // Skip
                    Rectangle {
                        width: 40; height: 40; radius: 20
                        color: skipMouse.containsMouse ? Color.mSurfaceVariant : "transparent"
                        border.color: Color.mOutline
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 150 } }

                        Text {
                            anchors.centerIn: parent
                            text: "⏭"
                            font.pixelSize: 16
                            color: Color.mOnSurfaceVariant
                        }
                        MouseArea {
                            id: skipMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (m) m.skip()
                        }
                        scale: skipMouse.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }
                    }
                }

                // ── Session Count ─────────────────────────────────────────
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: sessions + " session" + (sessions !== 1 ? "s" : "") + " completed"
                    font.family: "Inter"
                    font.pixelSize: Style.fontSizeXS
                    color: Color.mOnSurfaceVariant
                    opacity: 0.7
                }
            }
        }
    }
}
