import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Services.UI

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

    readonly property var m: root.pluginApi?.mainInstance ?? null
    readonly property string storeSize: m?.storeSize ?? "..."
    readonly property bool isCollecting: m?.isCollecting ?? false

    property string tooltipText: isCollecting ? "Collecting garbage..." : "Nix Store: " + storeSize
    property string tooltipDirection: BarService.getTooltipDirection()
    property bool enabled: true

    readonly property real contentWidth: barIsVertical ? capsuleHeight : Math.round(capsuleHeight * 2.4)
    readonly property real contentHeight: capsuleHeight

    implicitWidth: contentWidth
    implicitHeight: contentHeight

    signal entered
    signal exited
    signal clicked

    function openPanel() { if (pluginApi) pluginApi.openPanel(root.screen, root); }

    Rectangle {
        anchors.fill: parent
        radius: Math.min(Style.radiusL, height / 2)
        color: mouseArea.containsMouse ? Color.mHover : Style.capsuleColor
        border.color: Style.capsuleBorderColor
        border.width: Style.capsuleBorderWidth

        Behavior on color { ColorAnimation { duration: Style.animationNormal } }

        Row {
            anchors.centerIn: parent
            spacing: 4

            // Nix logo icon
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "󱄅"
                font.family: "Maple Mono NF"
                font.pixelSize: Style.fontSizeM
                color: mouseArea.containsMouse ? Color.mOnHover : Color.mPrimary

                SequentialAnimation on opacity {
                    running: isCollecting
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 600; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
                }
                opacity: 1.0
            }

            // Store size
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: isCollecting ? "gc..." : storeSize
                font.family: "Maple Mono NF"
                font.pixelSize: Style.fontSizeS
                color: mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton

        onClicked: {
            TooltipService.hide();
            openPanel();
            root.clicked();
        }
        onEntered: {
            TooltipService.show(root, root.tooltipText, root.tooltipDirection);
            root.entered();
        }
        onExited: {
            TooltipService.hide();
            root.exited();
        }
    }
}
