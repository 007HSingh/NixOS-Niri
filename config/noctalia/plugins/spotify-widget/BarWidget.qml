import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Services.Media
import qs.Services.UI

// Bar capsule with bouncing music note animation.
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

    readonly property bool isSpotify: root.pluginApi?.mainInstance?.isSpotify ?? false
    readonly property bool isPlaying: root.pluginApi?.mainInstance?.isPlaying ?? false

    property string tooltipText: {
        if (!isSpotify) return "Spotify";
        return MediaService.trackTitle + " — " + MediaService.trackArtist;
    }
    property string tooltipDirection: BarService.getTooltipDirection()
    property bool enabled: true

    readonly property real contentWidth: barIsVertical ? capsuleHeight : Math.round(capsuleHeight + Style.marginXS * 2)
    readonly property real contentHeight: capsuleHeight

    implicitWidth: contentWidth
    implicitHeight: contentHeight

    signal entered
    signal exited
    signal clicked

    function openPanel() {
        if (pluginApi) {
            pluginApi.openPanel(root.screen);
        }
    }

    // ── Capsule ──────────────────────────────────────────────────────────────
    Rectangle {
        id: visualCapsule
        x: Style.pixelAlignCenter(parent.width, width)
        y: Style.pixelAlignCenter(parent.height, height)
        width: root.contentWidth
        height: root.contentHeight
        color: mouseArea.containsMouse ? Color.mHover : Style.capsuleColor
        radius: Math.min(Style.radiusL, width / 2)
        border.color: Style.capsuleBorderColor
        border.width: Style.capsuleBorderWidth

        Behavior on color {
            ColorAnimation { duration: Style.animationNormal; easing.type: Easing.InOutQuad }
        }

        // ── Bouncing Music Notes ─────────────────────────────────────────
        Item {
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.5

            // Note 1 — left, bounces up
            Text {
                id: note1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -7
                text: "♪"
                font.pixelSize: 14
                font.bold: true
                color: mouseArea.containsMouse ? Color.mOnHover : Color.mPrimary

                property real bounce: 0
                y: parent.height * 0.3 + bounce

                SequentialAnimation on bounce {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { to: -5; duration: 500; easing.type: Easing.OutQuad }
                    NumberAnimation { to: 2; duration: 500; easing.type: Easing.InQuad }
                }

                property real wobble: 1.0
                SequentialAnimation on wobble {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.15; duration: 600; easing.type: Easing.OutQuad }
                    NumberAnimation { to: 0.95; duration: 600; easing.type: Easing.InQuad }
                }
                scale: wobble
            }

            // Note 2 — right, offset phase
            Text {
                id: note2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 7
                text: "♫"
                font.pixelSize: 12
                color: mouseArea.containsMouse ? Color.mOnHover : Color.mSecondary
                opacity: 0.8

                property real bounce: 0
                y: parent.height * 0.15 + bounce

                SequentialAnimation on bounce {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { to: 3; duration: 450; easing.type: Easing.InQuad }
                    NumberAnimation { to: -4; duration: 450; easing.type: Easing.OutQuad }
                }

                property real spin: 0
                SequentialAnimation on spin {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { to: 10; duration: 700; easing.type: Easing.OutQuad }
                    NumberAnimation { to: -10; duration: 700; easing.type: Easing.InQuad }
                }
                rotation: spin
            }
        }
    }

    // ── Mouse Interaction ────────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function(mouse) {
            TooltipService.hide();
            if (mouse.button === Qt.LeftButton) {
                root.openPanel();
                root.clicked();
            }
        }

        onEntered: {
            if (root.tooltipText) {
                TooltipService.show(root, root.tooltipText, root.tooltipDirection);
            }
            root.entered();
        }
        onExited: {
            TooltipService.hide();
            root.exited();
        }
    }
}
