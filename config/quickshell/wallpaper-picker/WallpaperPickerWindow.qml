import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Hyprland

Rectangle {
    id: root

    // Catppuccin Mocha palette
    readonly property color crust: "#11111b"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color lavender: "#b4befe"
    readonly property color text: "#cdd6f4"
    readonly property color overlay0: "#6c7086"

    color: "transparent"

    // Frosted glass background overlay
    Rectangle {
        anchors.fill: parent
        anchors.margins: 40
        radius: 20
        color: root.crust
        opacity: 0.72

        border.color: root.lavender
        border.opacity: 0.35

        // Subtle inner shadow effect
        layer.enabled: true
        layer.effect: ShaderEffect {
            property var source: root

            fragmentShader: "
                #version 440
                layout(location=0) in vec2 qt_TexCoord0;
                layout(location=1) out vec4 fragColor;
                layout(std140, binding=0) uniform buf {
                    mat4 qt_Matrix;
                    float qt_Opacity;
                };
                layout(binding=1) uniform sampler2D source;

                void main() {
                    vec4 color = texture(source, qt_TexCoord0);
                    // Add subtle vignette
                    vec2 uv = qt_TexCoord0;
                    float dist = distance(uv, vec2(0.5));
                    float vignette = 1.0 - smoothstep(0.4, 0.8, dist);
                    color.rgb *= mix(1.0, 0.85, vignette);
                    fragColor = color;
                }
            "
        }
    }

    // Main content
    Item {
        anchors.fill: parent
        anchors.margins: 40

        ColumnLayout {
            anchors.fill: parent
            spacing: 16

            // Header
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    spacing: 12

                    Text {
                        Layout.fillWidth: true
                        text: "Select Wallpaper"
                        font.family: "JetBrainsMono Nerd Font"
                        font.size: 20
                        font.weight: Font.Bold
                        color: root.text
                        verticalAlignment: Text.AlignVCenter
                    }

                    // Close button
                    Rectangle {
                        width: 36
                        height: 36
                        radius: 10
                        color: root.surface1
                        opacity: closeMouse.containsMouse ? 0.8 : 0.6

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 150
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            font.family: "JetBrainsMono Nerd Font"
                            font.size: 16
                            color: root.text
                        }

                        MouseArea {
                            id: closeMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.exit()
                        }
                    }
                }
            }

            // Wallpaper grid
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                ScrollView {
                    anchors.fill: parent
                    clip: true

                    // Custom scrollbar styling
                    background: Rectangle {
                        color: "transparent"
                        radius: 10
                    }

                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    ScrollBar.horizontal.policy: ScrollBar.AsNeeded

                    GridView {
                        id: wallpaperGrid
                        anchors.fill: parent
                        anchors.margins: 8

                        cellWidth: root.parent ? (root.parent.width - 80) / 4 : 280
                        cellHeight: 220

                        model: QuickshellRoot ? QuickshellRoot.wallpapers : []

                        delegate: WallpaperThumbnail {
                            width: wallpaperGrid.cellWidth - 16
                            height: wallpaperGrid.cellHeight - 16
                            wallpaperPath: modelData
                            onSelect: {
                                if (QuickshellRoot) {
                                    QuickshellRoot.selectWallpaper(modelData)
                                }
                            }
                        }
                    }
                }
            }

            // Footer with hint
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "Click to select • Esc to cancel"
                    font.family: "JetBrainsMono Nerd Font"
                    font.size: 11
                    color: root.overlay0
                }
            }
        }
    }

    // Close on Escape
    Shortcut {
        sequence: "Escape"
        onActivated: Quickshell.exit()
    }
}
