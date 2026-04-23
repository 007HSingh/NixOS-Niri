import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Services.Media
import qs.Services.UI
import qs.Widgets.AudioSpectrum

// Bar capsule with real-time audio spectrum visualizer.
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

    // Register with SpectrumService for real-time audio data
    readonly property string spectrumId: "plugin:spotify-widget:" + screenName
    Component.onCompleted: SpectrumService.registerComponent(spectrumId)
    Component.onDestruction: SpectrumService.unregisterComponent(spectrumId)

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

        // ── Real-time Audio Spectrum ─────────────────────────────────────
        NLinearSpectrum {
            anchors.fill: parent
            anchors.margins: Style.marginS
            values: SpectrumService.values
            fillColor: mouseArea.containsMouse ? Color.mOnHover : Color.mPrimary
            showMinimumSignal: true
            vertical: root.barIsVertical
            barPosition: root.barPosition
            mirrored: false
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
