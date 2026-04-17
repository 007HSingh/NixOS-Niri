import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    property string wallpaperPath: ""
    signal select

    // Catppuccin Mocha palette
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color lavender: "#b4befe"
    readonly property color text: "#cdd6f4"

    radius: 12
    color: thumbnailMouse.containsMouse ? root.surface1 : root.surface0
    opacity: 0.85

    border.color: root.lavender
    border.opacity: thumbnailMouse.containsMouse ? 0.6 : 0.25
    border.width: 2

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Behavior on border.opacity {
        OpacityAnimator {
            duration: 150
        }
    }

    layer.enabled: true
    layer.effect: ShaderEffect {
        fragmentShader: "
            #version 440
            layout(location=0) in vec2 qt_TexCoord0;
            layout(location=0) out vec4 fragColor;
            layout(std140, binding=0) uniform buf {
                mat4 qt_Matrix;
                float qt_Opacity;
            };
            layout(binding=1) uniform sampler2D source;

            void main() {
                vec4 color = texture(source, qt_TexCoord0);
                // Soft rounded corners
                vec2 uv = qt_TexCoord0;
                float dist = length(uv - 0.5) * 1.414;
                float mask = 1.0 - smoothstep(0.85, 1.0, dist);
                color.a *= mask;
                fragColor = color;
            }
        "
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        // Thumbnail image
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 8
            color: root.surface0
            clip: true

            // Image component for thumbnail
            Image {
                id: thumbnailImage
                anchors.fill: parent
                anchors.centerIn: parent
                source: root.wallpaperPath ? "file://" + root.wallpaperPath : ""
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true

                // Fallback gradient if image fails
                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: root.surface0 }
                        GradientStop { position: 1.0; color: root.surface1 }
                    }
                    z: -1
                }
            }
        }

        // Filename label
        Text {
            Layout.fillWidth: true
            text: {
                if (!root.wallpaperPath) return "Unknown"
                var parts = root.wallpaperPath.split("/")
                return parts[parts.length - 1]
            }
            font.family: "JetBrainsMono Nerd Font"
            font.size: 10
            color: root.text
            elide: Text.ElideMiddle
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.NoWrap
            maximumLineCount: 1
        }
    }

    MouseArea {
        id: thumbnailMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.select()
    }
}
