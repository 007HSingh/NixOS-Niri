import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services.Media
import qs.Widgets

// Popup panel with Spotify controls, cute equalizer animation, and track info.
Item {
    id: root
    property var pluginApi: null

    readonly property var geometryPlaceholder: panelContainer
    readonly property bool allowAttach: true
    property real contentPreferredWidth: 340 * Style.uiScaleRatio
    property real contentPreferredHeight: 280 * Style.uiScaleRatio

    anchors.fill: parent

    readonly property bool isSpotify: root.pluginApi?.mainInstance?.isSpotify ?? false
    readonly property bool isPlaying: root.pluginApi?.mainInstance?.isPlaying ?? false

    Rectangle {
        id: panelContainer
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

                // ── Cute Equalizer Animation (big version) ───────────────
                Item {
                    Layout.preferredWidth: 80 * Style.uiScaleRatio
                    Layout.preferredHeight: 50 * Style.uiScaleRatio
                    Layout.alignment: Qt.AlignHCenter

                    Row {
                        anchors.centerIn: parent
                        spacing: 4 * Style.uiScaleRatio
                        height: parent.height

                        Repeater {
                            model: 5

                            Rectangle {
                                id: panelBar
                                required property int index

                                width: 8 * Style.uiScaleRatio
                                anchors.bottom: parent.bottom
                                radius: 4 * Style.uiScaleRatio
                                color: Color.mPrimary

                                readonly property real baseH: parent.height * 0.2
                                readonly property real maxH: parent.height

                                height: isPlaying ? _animH : baseH
                                property real _animH: baseH

                                Behavior on height {
                                    NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
                                }

                                SequentialAnimation on _animH {
                                    running: isPlaying
                                    loops: Animation.Infinite

                                    PauseAnimation { duration: panelBar.index * 100 }

                                    SequentialAnimation {
                                        loops: Animation.Infinite
                                        NumberAnimation {
                                            from: panelBar.baseH
                                            to: panelBar.maxH * (0.5 + Math.random() * 0.5)
                                            duration: 350 + panelBar.index * 60
                                            easing.type: Easing.OutQuad
                                        }
                                        NumberAnimation {
                                            to: panelBar.baseH * (1.0 + Math.random() * 0.8)
                                            duration: 280 + panelBar.index * 50
                                            easing.type: Easing.InQuad
                                        }
                                        NumberAnimation {
                                            to: panelBar.maxH * (0.3 + Math.random() * 0.6)
                                            duration: 320 + panelBar.index * 70
                                            easing.type: Easing.OutQuad
                                        }
                                        NumberAnimation {
                                            to: panelBar.baseH
                                            duration: 250 + panelBar.index * 40
                                            easing.type: Easing.InQuad
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ── Track Info ────────────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        Layout.fillWidth: true
                        text: isSpotify ? MediaService.trackTitle : "No Spotify"
                        font.family: "Comfortaa"
                        font.pixelSize: Style.fontSizeXXL * 1.1
                        font.bold: true
                        font.letterSpacing: 0.5
                        color: Color.mOnSurface
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        Layout.fillWidth: true
                        text: isSpotify ? MediaService.trackArtist : ""
                        font.family: "Inter"
                        font.pixelSize: Style.fontSizeL
                        font.italic: true
                        color: Color.mSecondary
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        opacity: 0.9
                    }
                }

                // ── Progress Bar ─────────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Style.marginXXS

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 4
                        radius: 2
                        color: Color.mSurfaceVariant

                        Rectangle {
                            width: (MediaService.trackLength > 0)
                                   ? Math.min(1.0, MediaService.currentPosition / MediaService.trackLength) * parent.width
                                   : 0
                            height: parent.height
                            radius: parent.radius
                            color: Color.mPrimary

                            Behavior on width {
                                NumberAnimation { duration: 800; easing.type: Easing.OutQuad }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: MediaService.positionString
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: Style.fontSizeXS
                            color: Color.mOnSurfaceVariant
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: MediaService.lengthString
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: Style.fontSizeXS
                            color: Color.mOnSurfaceVariant
                        }
                    }
                }

                // ── Playback Controls ────────────────────────────────────
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Style.marginXL

                    // Previous
                    Item {
                        width: 32; height: 32

                        Text {
                            anchors.centerIn: parent
                            text: "󰒮"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 22
                            color: prevMouse.containsMouse ? Color.mOnSurface : Color.mOnSurfaceVariant
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }

                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaService.previous()
                        }

                        scale: prevMouse.pressed ? 0.85 : (prevMouse.containsMouse ? 1.1 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }
                    }

                    // Play/Pause pill
                    Rectangle {
                        width: 50
                        height: 36
                        radius: 18
                        color: Color.mPrimary

                        Text {
                            anchors.centerIn: parent
                            text: MediaService.isPlaying ? "󰏤" : "󰐊"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 22
                            color: Color.mOnPrimary
                            anchors.horizontalCenterOffset: MediaService.isPlaying ? 0 : 1
                        }

                        scale: playMouse.containsMouse ? 1.08 : 1.0
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

                        MouseArea {
                            id: playMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaService.playPause()
                        }
                    }

                    // Next
                    Item {
                        width: 32; height: 32

                        Text {
                            anchors.centerIn: parent
                            text: "󰒭"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 22
                            color: nextMouse.containsMouse ? Color.mOnSurface : Color.mOnSurfaceVariant
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }

                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaService.next()
                        }

                        scale: nextMouse.pressed ? 0.85 : (nextMouse.containsMouse ? 1.1 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }
                    }
                }
            }
        }
    }
}
