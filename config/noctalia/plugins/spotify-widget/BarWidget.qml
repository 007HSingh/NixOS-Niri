import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Services.Media
import qs.Services.UI

// Bar capsule with cute bouncing equalizer bars animation.
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

        // ── Equalizer Bars Animation ─────────────────────────────────────
        Row {
            anchors.centerIn: parent
            spacing: 2
            height: parent.height * 0.6

            Repeater {
                model: 4

                Rectangle {
                    id: bar
                    required property int index

                    width: 3
                    anchors.bottom: parent.bottom
                    radius: 1.5
                    color: mouseArea.containsMouse ? Color.mOnHover : Color.mPrimary

                    Behavior on color {
                        ColorAnimation { duration: Style.animationNormal }
                    }

                    // Each bar has a different phase/speed for organic feel
                    readonly property real baseHeight: parent.height * 0.25
                    readonly property real maxHeight: parent.height

                    height: isPlaying ? _animatedHeight : baseHeight

                    property real _animatedHeight: baseHeight

                    Behavior on height {
                        NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
                    }

                    // Staggered bounce animation when playing
                    SequentialAnimation on _animatedHeight {
                        running: isPlaying
                        loops: Animation.Infinite

                        // Offset start based on bar index
                        PauseAnimation { duration: bar.index * 120 }

                        SequentialAnimation {
                            loops: Animation.Infinite
                            NumberAnimation {
                                from: bar.baseHeight
                                to: bar.maxHeight * (0.6 + Math.random() * 0.4)
                                duration: 300 + bar.index * 80
                                easing.type: Easing.OutQuad
                            }
                            NumberAnimation {
                                to: bar.baseHeight * (1.0 + Math.random() * 0.5)
                                duration: 250 + bar.index * 60
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                to: bar.maxHeight * (0.4 + Math.random() * 0.5)
                                duration: 280 + bar.index * 70
                                easing.type: Easing.OutQuad
                            }
                            NumberAnimation {
                                to: bar.baseHeight
                                duration: 200 + bar.index * 50
                                easing.type: Easing.InQuad
                            }
                        }
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
