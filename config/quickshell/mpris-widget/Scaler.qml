import QtQuick

// Responsive scaler: maps a base design width (1920) to the actual screen width.
// Usage: call s(val) to scale any pixel value proportionally.
QtObject {
    property real currentWidth: 1920
    readonly property real baseWidth: 1920
    readonly property real ratio: currentWidth / baseWidth

    function s(val) {
        return val * ratio
    }
}
