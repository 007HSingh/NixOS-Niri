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
        if (!isSpotify)
            return "Spotify";
        return MediaService.trackTitle + " — " + MediaService.trackArtist;
    }
    property string tooltipDirection: BarService.getTooltipDirection()
    property bool enabled: true

    readonly property real contentWidth: barIsVertical ? capsuleHeight : (isPlaying ? Math.round(capsuleHeight + Style.marginXS * 2 + Style.fontSizeS * 8) : Math.round(capsuleHeight + Style.marginXS * 2))
    readonly property real contentHeight: capsuleHeight

    implicitWidth: contentWidth
    implicitHeight: contentHeight

    signal entered
    signal exited
    signal clicked

    function openPanel() {
        if (pluginApi) {
            pluginApi.openPanel(root.screen, root);
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
            ColorAnimation {
                duration: Style.animationNormal
                easing.type: Easing.InOutQuad
            }
        }

        // ── Spotify Logo ─────────────────────────────────────────────────
        Row {
            anchors.centerIn: parent
            spacing: 4

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "󰓇"
                font.family: "Maple Mono NF"
                font.pixelSize: Math.round(parent.parent.height * 0.5)
                color: mouseArea.containsMouse ? Color.mOnHover : Color.mPrimary

                Behavior on color {
                    ColorAnimation {
                        duration: Style.animationNormal
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            Text {
                visible: root.isPlaying && !barIsVertical
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    var t = MediaService.trackTitle ?? "";
                    return t.length > 14 ? t.substring(0, 14) + "…" : t;
                }
                font.family: "Maple Mono NF"
                font.pixelSize: Style.fontSizeS
                color: mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface
                width: visible ? implicitWidth : 0
                Behavior on width {
                    NumberAnimation {
                        duration: Style.animationNormal
                    }
                }
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

        onClicked: function (mouse) {
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
