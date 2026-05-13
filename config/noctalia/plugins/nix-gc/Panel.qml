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
    property real contentPreferredHeight: 300 * Style.uiScaleRatio

    anchors.fill: parent

    readonly property var m: root.pluginApi?.mainInstance ?? null
    readonly property string storeSize: m?.storeSize ?? "..."
    readonly property string storePathCount: m?.storePathCount ?? "..."
    readonly property string generationCount: m?.generationCount ?? "..."
    readonly property bool isCollecting: m?.isCollecting ?? false
    readonly property bool gcConfirmPending: m?.gcConfirmPending ?? false
    readonly property string lastCollected: m?.lastCollected ?? "never"
    readonly property string gcOutput: m?.gcOutput ?? ""
    readonly property string errorMsg: m?.errorMsg ?? ""

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
                spacing: Style.marginM

                // ── Header ────────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "󱄅"
                        font.family: "Maple Mono NF"
                        font.pixelSize: 28
                        color: Color.mPrimary

                        SequentialAnimation on opacity {
                            running: isCollecting
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.2; duration: 600; easing.type: Easing.InOutQuad }
                            NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
                        }
                        opacity: 1.0
                    }

                    Text {
                        text: "Nix Store"
                        font.family: "Comfortaa"
                        font.pixelSize: Style.fontSizeXXL
                        font.bold: true
                        color: Color.mOnSurface
                        leftPadding: Style.marginS
                        Layout.fillWidth: true
                    }
                }

                // ── Divider ───────────────────────────────────────────────
                Rectangle { Layout.fillWidth: true; height: 1; color: Color.mOutline; opacity: 0.5 }

                // ── Stats Grid ────────────────────────────────────────────
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: Style.marginL
                    rowSpacing: Style.marginS

                    Repeater {
                        model: [
                            { label: "Store Size",   value: storeSize },
                            { label: "Store Paths",  value: storePathCount },
                            { label: "Generations",  value: generationCount },
                            { label: "Last GC",      value: lastCollected }
                        ]

                        ColumnLayout {
                            required property var modelData
                            spacing: 1

                            Text {
                                text: modelData.label.toUpperCase()
                                font.family: "Maple Mono NF"
                                font.pixelSize: Style.fontSizeXXS
                                color: Color.mOnSurfaceVariant
                                font.letterSpacing: 1.2
                            }
                            Text {
                                text: modelData.value
                                font.family: "Maple Mono NF"
                                font.pixelSize: Style.fontSizeL
                                font.bold: true
                                color: Color.mOnSurface
                            }
                        }
                    }
                }

                // ── GC Output / Error ─────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40 * Style.uiScaleRatio
                    visible: gcOutput !== "" || errorMsg !== ""
                    color: errorMsg !== "" ? Qt.rgba(Color.mError.r, Color.mError.g, Color.mError.b, 0.15) : Color.mSurfaceVariant
                    radius: Style.radiusS

                    Text {
                        anchors.fill: parent
                        anchors.margins: Style.marginS
                        text: errorMsg !== "" ? errorMsg : gcOutput
                        font.family: "Maple Mono NF"
                        font.pixelSize: Style.fontSizeXS
                        color: errorMsg !== "" ? Color.mError : Color.mOnSurfaceVariant
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        maximumLineCount: 2
                    }
                }

                Item { Layout.fillHeight: true }

                // ── Buttons ───────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.marginS

                    // Refresh
                    Rectangle {
                        Layout.fillWidth: true
                        height: 36 * Style.uiScaleRatio
                        radius: 18 * Style.uiScaleRatio
                        color: refreshMouse.containsMouse ? Color.mSurfaceVariant : "transparent"
                        border.color: Color.mOutline
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 150 } }

                        Text {
                            anchors.centerIn: parent
                            text: "↻  refresh"
                            font.family: "Nunito"
                            font.pixelSize: Style.fontSizeS
                            color: Color.mOnSurfaceVariant
                        }
                        MouseArea {
                            id: refreshMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (m) m.refresh()
                        }
                    }

                    // Collect Garbage (with confirmation)
                    Rectangle {
                        Layout.fillWidth: true
                        height: 36 * Style.uiScaleRatio
                        radius: 18 * Style.uiScaleRatio
                        color: {
                            if (isCollecting) return Color.mSurfaceVariant;
                            if (gcConfirmPending) return gcMouse.containsMouse ? Qt.darker(Color.mError, 1.1) : Color.mError;
                            return gcMouse.containsMouse ? Qt.darker(Color.mTertiary, 1.1) : Color.mTertiary;
                        }
                        Behavior on color { ColorAnimation { duration: 200 } }

                        Text {
                            anchors.centerIn: parent
                            text: {
                                if (isCollecting) return "collecting...";
                                if (gcConfirmPending) return "sure?  confirm";
                                return "󱄅  collect";
                            }
                            font.family: "Nunito"
                            font.pixelSize: Style.fontSizeS
                            color: {
                                if (isCollecting) return Color.mOnSurfaceVariant;
                                if (gcConfirmPending) return Color.mOnError;
                                return Color.mOnTertiary;
                            }
                        }
                        MouseArea {
                            id: gcMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: isCollecting ? Qt.ArrowCursor : Qt.PointingHandCursor
                            onClicked: if (m && !isCollecting) m.requestGC()
                        }
                        scale: gcMouse.pressed ? 0.97 : 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }
                    }
                }
            }
        }
    }
}
