import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

Item {
    id: root
    property var pluginApi: null

    readonly property var geometryPlaceholder: panelBg
    readonly property bool allowAttach: true
    property real contentPreferredWidth: 320 * Style.uiScaleRatio
    property real contentPreferredHeight: 260 * Style.uiScaleRatio

    anchors.fill: parent

    readonly property var m: root.pluginApi?.mainInstance ?? null
    readonly property string branch: m?.branch ?? "—"
    readonly property bool isDirty: m?.isDirty ?? false
    readonly property string lastCommitHash: m?.lastCommitHash ?? ""
    readonly property string lastCommitMsg: m?.lastCommitMsg ?? ""
    readonly property string lastCommitTime: m?.lastCommitTime ?? ""
    readonly property int modifiedCount: m?.modifiedCount ?? 0
    readonly property int untrackedCount: m?.untrackedCount ?? 0
    readonly property int stagedCount: m?.stagedCount ?? 0

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

                // ── Branch ────────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.marginS

                    Text {
                        text: ""
                        font.family: "Maple Mono NF"
                        font.pixelSize: Style.fontSizeXXL
                        color: isDirty ? Color.mError : Color.mTertiary
                        Behavior on color { ColorAnimation { duration: 300 } }
                    }

                    Text {
                        text: branch
                        font.family: "Comfortaa"
                        font.pixelSize: Style.fontSizeXXL
                        font.bold: true
                        color: Color.mOnSurface
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        width: 10; height: 10; radius: 5
                        color: isDirty ? Color.mError : Color.mTertiary
                        Behavior on color { ColorAnimation { duration: 300 } }
                    }
                }

                // ── Divider ───────────────────────────────────────────────
                Rectangle { Layout.fillWidth: true; height: 1; color: Color.mOutline; opacity: 0.5 }

                // ── Last Commit ───────────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: "LAST COMMIT"
                        font.family: "Maple Mono NF"
                        font.pixelSize: Style.fontSizeXXS
                        color: Color.mOnSurfaceVariant
                        font.letterSpacing: 1.5
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Style.marginS

                        Text {
                            text: lastCommitHash || "—"
                            font.family: "Maple Mono NF"
                            font.pixelSize: Style.fontSizeS
                            color: Color.mPrimary
                        }

                        Text {
                            text: lastCommitMsg || "—"
                            font.family: "Nunito"
                            font.pixelSize: Style.fontSizeS
                            color: Color.mOnSurface
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    Text {
                        text: lastCommitTime || ""
                        font.family: "Nunito"
                        font.pixelSize: Style.fontSizeXS
                        color: Color.mOnSurfaceVariant
                        opacity: 0.7
                        font.italic: true
                    }
                }

                // ── Status Counts ─────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.marginM
                    visible: isDirty

                    Repeater {
                        model: [
                            { icon: "●", label: "staged",    count: stagedCount,    color: Color.mTertiary },
                            { icon: "●", label: "modified",  count: modifiedCount,  color: Color.mError },
                            { icon: "●", label: "untracked", count: untrackedCount, color: Color.mOnSurfaceVariant }
                        ]

                        RowLayout {
                            required property var modelData
                            spacing: 4
                            visible: modelData.count > 0

                            Rectangle { width: 8; height: 8; radius: 4; color: modelData.color }
                            Text {
                                text: modelData.count + " " + modelData.label
                                font.family: "Maple Mono NF"
                                font.pixelSize: Style.fontSizeXS
                                color: Color.mOnSurfaceVariant
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                // ── Refresh Button ────────────────────────────────────────
                Rectangle {
                    Layout.alignment: Qt.AlignRight
                    width: 90 * Style.uiScaleRatio
                    height: 32 * Style.uiScaleRatio
                    radius: 16 * Style.uiScaleRatio
                    color: refreshMouse.containsMouse ? Color.mSurfaceVariant : "transparent"
                    border.color: Color.mOutline
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 150 } }

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: "↻"; font.pixelSize: 14; color: Color.mOnSurfaceVariant }
                        Text {
                            text: "refresh"
                            font.family: "Nunito"
                            font.pixelSize: Style.fontSizeXS
                            color: Color.mOnSurfaceVariant
                        }
                    }

                    MouseArea {
                        id: refreshMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (m) m.refresh()
                    }
                }
            }
        }
    }
}
