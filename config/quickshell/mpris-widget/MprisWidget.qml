import QtQuick
import QtQuick.Controls

Item {
    id: widgetRoot
    
    property string status: "Stopped"
    property string title: "No Title"
    property string artist: "No Artist"
    property string artUrl: ""
    property real length: 0
    property real position: 0
    
    signal playPauseClicked()
    signal nextClicked()
    signal prevClicked()

    CatppuccinColors { id: colors }
    Scaler { id: scaler; currentWidth: widgetRoot.width }

    Rectangle {
        id: mainContainer
        anchors.fill: parent
        radius: 20
        color: colors.base
        clip: true
        border.color: colors.surface0
        border.width: 1

        // Background Image (dimmed for glass look)
        Image {
            id: bgImage
            anchors.fill: parent
            source: artUrl || ""
            fillMode: Image.PreserveAspectCrop
            opacity: 0.15
            visible: artUrl !== ""
        }

        Row {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 25

            // Album Art
            Rectangle {
                width: parent.height - 40
                height: width
                radius: 15
                color: colors.surface0
                clip: true
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    anchors.fill: parent
                    source: artUrl || ""
                    fillMode: Image.PreserveAspectCrop
                    visible: artUrl !== ""
                }
                
                Text {
                    anchors.centerIn: parent
                    text: "󰎆"
                    font.family: colors.monoFamily
                    font.pixelSize: 48
                    color: colors.surface1
                    visible: artUrl === ""
                }
            }

            // Track Info & Controls
            Column {
                width: parent.width - parent.height - 10
                height: parent.height - 40
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12
                
                Column {
                    width: parent.width
                    spacing: 4
                    
                    Text {
                        width: parent.width
                        text: title
                        font.family: colors.sansFamily
                        font.pixelSize: 22
                        font.bold: true
                        color: colors.text
                        elide: Text.ElideRight
                    }
                    
                    Text {
                        width: parent.width
                        text: artist
                        font.family: colors.sansFamily
                        font.pixelSize: 16
                        color: colors.mauve
                        elide: Text.ElideRight
                    }
                }
                
                // Progress Bar
                Column {
                    width: parent.width
                    spacing: 6
                    
                    Rectangle {
                        id: progressBarBg
                        width: parent.width
                        height: 6
                        radius: 3
                        color: colors.surface0
                        
                        Rectangle {
                            width: (length > 0) ? Math.min(1.0, position / length) * parent.width : 0
                            height: parent.height
                            radius: parent.radius
                            color: colors.mauve
                        }
                    }
                    
                    Item {
                        width: parent.width
                        height: 15
                        
                        Text {
                            anchors.left: parent.left
                            text: formatTime(position / 1000000)
                            font.family: colors.monoFamily
                            font.pixelSize: 11
                            color: colors.subtext0
                        }
                        
                        Text {
                            anchors.right: parent.right
                            text: formatTime(length / 1000000)
                            font.family: colors.monoFamily
                            font.pixelSize: 11
                            color: colors.subtext0
                        }
                    }
                }

                // Controls
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 45 // Increased spacing
                    
                    // Previous
                    Text {
                        text: "󰒮"
                        font.family: colors.monoFamily
                        font.pixelSize: 28
                        color: colors.text
                        opacity: prevMouse.containsMouse ? 1.0 : 0.7
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: prevClicked()
                        }
                        scale: prevMouse.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }
                    }
                    
                    // Play/Pause
                    Rectangle {
                        width: 48 // Slightly larger
                        height: 48
                        radius: 24
                        color: colors.text
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            anchors.centerIn: parent
                            text: status === "Playing" ? "󰏤" : "󰐊"
                            font.family: colors.monoFamily
                            font.pixelSize: 26
                            color: colors.base
                            // Refined optical alignment: only 1px for Play, none for Pause
                            anchors.horizontalCenterOffset: (status !== "Playing") ? 1 : 0
                        }
                        
                        scale: playMouse.containsMouse ? 1.08 : 1.0
                        Behavior on scale { NumberAnimation { duration: 150 } }
                        MouseArea {
                            id: playMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: playPauseClicked()
                        }
                    }
                    
                    // Next
                    Text {
                        text: "󰒭"
                        font.family: colors.monoFamily
                        font.pixelSize: 28
                        color: colors.text
                        opacity: nextMouse.containsMouse ? 1.0 : 0.7
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: nextClicked()
                        }
                        scale: nextMouse.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }
                    }
                }
            }
        }
    }
    
    function formatTime(seconds) {
        if (isNaN(seconds) || seconds < 0) return "0:00";
        let mins = Math.floor(seconds / 60);
        let secs = Math.floor(seconds % 60);
        return mins + ":" + (secs < 10 ? "0" : "") + secs;
    }
}
