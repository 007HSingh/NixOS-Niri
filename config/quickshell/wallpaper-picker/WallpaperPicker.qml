import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.folderlistmodel
import QtMultimedia
import Quickshell
import Quickshell.Io

Item {
    id: window
    width: Screen.width

    // Signal to request window close
    signal windowCloseRequested()

    // -------------------------------------------------------------------------
    // RESPONSIVE SCALING
    // -------------------------------------------------------------------------
    Scaler {
        id: scaler
        currentWidth: Screen.width
    }

    function s(val) {
        return scaler.s(val)
    }

    CatppuccinColors { id: _theme }

    // -------------------------------------------------------------------------
    // PROPERTIES
    // -------------------------------------------------------------------------
    property string widgetArg: ""
    property string targetWallName: ""
    property bool initialFocusSet: false
    property int visibleItemCount: -1
    property int scrollAccum: 0
    property real scrollThreshold: window.s(300)

    // Filter System
    property string currentFilter: "All"
    property string _lastFilter: "All"
    readonly property var filterData: [
        { name: "All",    hex: "", label: "All"    },
        { name: "Video",  hex: "", label: "Vid"    }
    ]

    // Local state
    property bool isApplying: false
    property bool isModelChanging: false
    property bool jumpToLastOnFilterChange: false

    // Reactive status
    property bool isStartup: srcFolderModel.status === FolderListModel.Loading
    property bool isReady: visible && srcFolderModel.status === FolderListModel.Ready

    // -------------------------------------------------------------------------
    // PATHS
    // -------------------------------------------------------------------------
    readonly property string homeDir: "file://" + Quickshell.env("HOME")
    readonly property string thumbDir: homeDir + "/.cache/wallpaper_picker/thumbs"
    readonly property string srcDir: {
        const dir = Quickshell.env("WALLPAPER_DIR")
        return (dir && dir !== "")
            ? dir
            : Quickshell.env("HOME") + "/.config/wallpapers"
    }

    // -------------------------------------------------------------------------
    // APPLY WALLPAPER  (awww instead of swww, no matugen)
    // -------------------------------------------------------------------------
    readonly property var transitions: ["grow", "outer", "any", "wipe", "wave", "fade", "center"]

    function applyWallpaper(safeFileName, isVideo) {
        if (!safeFileName || window.isApplying) return

        window.isApplying = true
        window.targetWallName = safeFileName

        const originalFile = window.srcDir + "/" + safeFileName

        const noctaliaBin = "/etc/profiles/per-user/harsh/bin/noctalia-shell"

        const fullScript = `
            (
                WALL_FILE=$(cat /tmp/qs_wall_path)

                export WAYLAND_DISPLAY="\${WAYLAND_DISPLAY:-${Quickshell.env("WAYLAND_DISPLAY") || "wayland-1"}}"
                export XDG_RUNTIME_DIR="\${XDG_RUNTIME_DIR:-${Quickshell.env("XDG_RUNTIME_DIR") || "/run/user/1000"}}"

                echo "[$(date)] Applying via Noctalia IPC: $WALL_FILE" >> /tmp/awww-debug.log

                ${noctaliaBin} ipc call wallpaper set "$WALL_FILE" all \
                    >> /tmp/awww-debug.log 2>&1

                ${isVideo ? `
                    pkill mpvpaper 2>/dev/null || true
                    mpvpaper -o 'loop --no-audio --panscan=1.0 --hwdec=auto --profile=high-quality --video-sync=display-resample --interpolation --tscale=oversample' '*' "$WALL_FILE" \
                        >>/tmp/awww-debug.log 2>&1 &
                    ffmpegthumbnailer -i "$WALL_FILE" -o /tmp/lock_bg.png -s 0 2>/dev/null || true
                ` : `
                    pkill mpvpaper 2>/dev/null || true
                    cp "$WALL_FILE" /tmp/lock_bg.png 2>/dev/null || true
                `}

                echo 'close' > /tmp/qs_widget_state

            ) </dev/null >>/tmp/awww-debug.log 2>&1 & disown
        `

        // Write path safely then run script
        Quickshell.execDetached(["bash", "-c",
            `printf '%s' ${JSON.stringify(originalFile)} > /tmp/qs_wall_path && ` + fullScript
        ])

        Qt.callLater(() => { window.isApplying = false })
    }

    // -------------------------------------------------------------------------
    // VISIBILITY
    // -------------------------------------------------------------------------
    onVisibleChanged: {
        if (!visible) {
            window.initialFocusSet = false
            window.isApplying = false
        } else {
            window.isFilterAnimating = true
            filterAnimationTimer.restart()
            window.applyFilters(true)
        }
    }

    // -------------------------------------------------------------------------
    // HELPERS
    // -------------------------------------------------------------------------
    function getCleanName(name) {
        if (!name) return ""
        let clean = String(name)
        return clean.startsWith("000_") ? clean.substring(4) : clean
    }

    function isDownloaded(name) {
        if (!name) return false
        for (let i = 0; i < srcFolderModel.count; i++) {
            if (srcFolderModel.get(i, "fileName") === name) return true
        }
        return false
    }

    onWidgetArgChanged: {
        if (widgetArg !== "") {
            targetWallName = widgetArg
            initialFocusSet = false
            tryFocus()
        }
    }

    function executeFocusRestore(targetIndex, isSearchRestore, requirePositioning) {
        let targetModel = localProxyModel
        if (targetIndex !== -1 && targetIndex < targetModel.count) {
            window.isModelChanging = true
            if (requirePositioning) {
                view.forceLayout()
                view.positionViewAtIndex(targetIndex, ListView.Center)
            }
            view.currentIndex = targetIndex
            if (isSearchRestore) window.searchIndexRestored = true
            window.isModelChanging = false
            window.initialFocusSet = true
        } else if (isSearchRestore) {
            window.searchIndexRestored = true
        }
    }

    function tryFocus() {
        if (initialFocusSet) return
        if (localProxyModel.count > 0) {
            let foundIndex = -1
            let cleanTarget = window.getCleanName(targetWallName)
            if (cleanTarget !== "") {
                for (let i = 0; i < localProxyModel.count; i++) {
                    let fname = localProxyModel.get(i).fileName || ""
                    if (window.getCleanName(fname) === cleanTarget) { foundIndex = i; break }
                }
            }
            window.executeFocusRestore(foundIndex !== -1 ? foundIndex : 0, false, true)
        }
    }

    // -------------------------------------------------------------------------
    // COLOR FILTERING
    // -------------------------------------------------------------------------
    function checkItemMatchesFilter(fileName, isVid, filter) {
        if (filter === "All")   return true
        if (filter === "Video") return isVid
        return false
    }

    // -------------------------------------------------------------------------
    // NAVIGATION HELPERS
    // -------------------------------------------------------------------------
    function stepToNextValidIndex(direction) {
        let targetModel = localProxyModel
        if (!targetModel || targetModel.count === 0) return
        let start = view.currentIndex
        let found = -1

        if (direction === 1) {
            for (let i = start + 1; i < targetModel.count; i++) {
                let fname = targetModel.get(i).fileName || ""
                if (checkItemMatchesFilter(fname, fname.startsWith("000_"),
                        window.currentFilter)) { found = i; break }
            }
        } else {
            for (let i = start - 1; i >= 0; i--) {
                let fname = targetModel.get(i).fileName || ""
                if (checkItemMatchesFilter(fname, fname.startsWith("000_"),
                        window.currentFilter)) { found = i; break }
            }
        }

        if (found !== -1) { view.currentIndex = found; return }

        const filterOrder = ["All", "Video"]
        let currentFilterIdx = filterOrder.indexOf(window.currentFilter)

        if (currentFilterIdx === -1) {
            let current = start
            for (let i = 0; i < targetModel.count; i++) {
                current = (current + direction + targetModel.count) % targetModel.count
                let fname = targetModel.get(current).fileName || ""
                if (checkItemMatchesFilter(fname, fname.startsWith("000_"),
                        window.currentFilter)) {
                    view.currentIndex = current; return
                }
            }
            return
        }

        let nextFilterIdx = currentFilterIdx + direction
        if (nextFilterIdx >= 0 && nextFilterIdx < filterOrder.length) {
            window.jumpToLastOnFilterChange = (direction === -1)
            window.currentFilter = filterOrder[nextFilterIdx]
        }
    }

    function cycleFilter(direction) {
        let currentIdx = -1
        for (let i = 0; i < window.filterData.length; i++) {
            if (window.filterData[i].name === window.currentFilter) { currentIdx = i; break }
        }
        if (currentIdx !== -1) {
            let nextIdx = (currentIdx + direction + window.filterData.length) % window.filterData.length
            window.currentFilter = window.filterData[nextIdx].name
        }
    }

    function applyFilters(forceSnap) {
        let targetModel = localProxyModel
        if (!targetModel || targetModel.count === 0) return

        let firstValidIndex = -1
        let lastValidIndex  = -1
        let cleanTarget  = window.getCleanName(window.targetWallName)
        let targetIndex  = -1

        for (let i = 0; i < targetModel.count; i++) {
            let fname = targetModel.get(i).fileName || ""
            let isVid = fname.startsWith("000_")
            if (checkItemMatchesFilter(fname, isVid, window.currentFilter)) {
                if (firstValidIndex === -1) firstValidIndex = i
                lastValidIndex = i
                if (cleanTarget !== "" && window.getCleanName(fname) === cleanTarget) targetIndex = i
            }
        }

        let indexToFocus = targetIndex !== -1 ? targetIndex
                         : window.jumpToLastOnFilterChange && lastValidIndex !== -1 ? lastValidIndex
                         : firstValidIndex

        window.jumpToLastOnFilterChange = false
        if (indexToFocus !== -1) window.executeFocusRestore(indexToFocus, false, forceSnap === true)
    }

    // -------------------------------------------------------------------------
    // KEYBOARD SHORTCUTS
    // -------------------------------------------------------------------------
    Shortcut {
        sequence: "Left"
        enabled: !window.isApplying
        onActivated: window.stepToNextValidIndex(-1)
    }
    Shortcut {
        sequence: "Right"
        enabled: !window.isApplying
        onActivated: window.stepToNextValidIndex(1)
    }
    Shortcut {
        sequence: "Return"
        enabled: !window.isApplying
        onActivated: {
            let targetModel = localProxyModel
            if (view.currentIndex >= 0 && view.currentIndex < targetModel.count) {
                let fname = targetModel.get(view.currentIndex).fileName
                if (fname) window.applyWallpaper(String(fname), String(fname).startsWith("000_"))
            }
        }
    }
    Shortcut {
        sequence: "Escape"
        enabled: !window.isApplying
        onActivated: window.windowCloseRequested()
    }
    Shortcut { sequence: "Tab";    enabled: !window.isApplying; onActivated: window.cycleFilter(1)  }
    Shortcut { sequence: "Backtab"; enabled: !window.isApplying; onActivated: window.cycleFilter(-1) }

    // -------------------------------------------------------------------------
    // MODELS
    // -------------------------------------------------------------------------
    ListModel { id: localProxyModel  }

    readonly property var activeModel: localProxyModel

    FolderListModel {
        id: srcFolderModel
        folder: "file://" + window.srcDir
        nameFilters: ["*.jpg","*.jpeg","*.png","*.webp","*.gif","*.mp4","*.mkv","*.mov","*.webm"]
        showDirs: false
        sortField: FolderListModel.Name
        onCountChanged: {
            window.syncLocalModel()
        }
        onStatusChanged: { if (status === FolderListModel.Ready) window.syncLocalModel() }
    }

    function syncLocalModel() {
        let startIdx = localProxyModel.count
        let endIdx   = srcFolderModel.count
        if (endIdx < startIdx) {
            window.isModelChanging = true; localProxyModel.clear(); startIdx = 0; window.isModelChanging = false
        }
        for (let i = startIdx; i < endIdx; i++) {
            let fn = srcFolderModel.get(i, "fileName")
            let fu = srcFolderModel.get(i, "fileUrl")
            if (fn !== undefined) localProxyModel.append({ "fileName": fn, "fileUrl": String(fu) })
        }
        if (!window.initialFocusSet && localProxyModel.count > 0)
            window.tryFocus()
    }

    // -------------------------------------------------------------------------
    // TIMERS
    // -------------------------------------------------------------------------
    Timer { id: scrollThrottle; interval: 150 }

    property bool isFilterAnimating: false
    Timer { id: filterAnimationTimer; interval: 800; onTriggered: window.isFilterAnimating = false }

    property bool isItemAnimating: false
    Timer { id: itemAnimationTimer; interval: 500; onTriggered: window.isItemAnimating = false }

    // -------------------------------------------------------------------------
    // CAROUSEL LIST VIEW
    // -------------------------------------------------------------------------
    readonly property real itemWidth:   window.s(400)
    readonly property real itemHeight:  window.s(420)
    readonly property real borderWidth: window.s(3)
    readonly property real spacing:     window.s(10)
    readonly property real skewFactor:  -0.35

    ListView {
        id: view
        anchors.fill: parent

        opacity: window.isReady ? 1.0 : 0.0
        anchors.margins: window.isReady ? 0 : window.s(40)

        Behavior on opacity        { NumberAnimation { duration: 600; easing.type: Easing.OutQuart } }
        Behavior on anchors.margins { NumberAnimation { duration: 700; easing.type: Easing.OutExpo  } }

        spacing: 0
        orientation: ListView.Horizontal
        clip: false
        interactive: !window.isApplying
        cacheBuffer: 2000

        highlightRangeMode:      ListView.StrictlyEnforceRange
        preferredHighlightBegin: (width / 2) - ((window.itemWidth * 1.5 + window.spacing) / 2)
        preferredHighlightEnd:   (width / 2) + ((window.itemWidth * 1.5 + window.spacing) / 2)
        highlightMoveDuration:   window.initialFocusSet ? 500 : 0
        focus: true

        onCurrentIndexChanged: {
            window.isItemAnimating = true
            itemAnimationTimer.restart()
        }

        add: Transition {
            enabled: window.initialFocusSet
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
                NumberAnimation { property: "scale";   from: 0.5; to: 1; duration: 400; easing.type: Easing.OutBack }
            }
        }
        addDisplaced: Transition {
            enabled: window.initialFocusSet
            NumberAnimation { property: "x"; duration: 400; easing.type: Easing.OutCubic }
        }

        header: Item { width: Math.max(0, (view.width / 2) - ((window.itemWidth * 1.5) / 2)) }
        footer: Item { width: Math.max(0, (view.width / 2) - ((window.itemWidth * 1.5) / 2)) }

        model: window.activeModel

        // Mouse-wheel scrolling (discrete, throttled)
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: (wheel) => {
                if (window.isApplying) { wheel.accepted = true; return }
                if (scrollThrottle.running) { wheel.accepted = true; return }
                let dx = wheel.angleDelta.x
                let dy = wheel.angleDelta.y
                let delta = Math.abs(dx) > Math.abs(dy) ? dx : dy
                scrollAccum += delta
                if (Math.abs(scrollAccum) >= scrollThreshold) {
                    window.stepToNextValidIndex(scrollAccum > 0 ? -1 : 1)
                    scrollAccum = 0
                    scrollThrottle.start()
                }
                wheel.accepted = true
            }
        }

        // ── Delegate ──────────────────────────────────────────────────────────
        delegate: Item {
            id: delegateRoot

            readonly property string safeFileName: fileName !== undefined ? String(fileName) : ""
            readonly property bool isCurrent: ListView.isCurrentItem
            readonly property bool isVisuallyEnlarged: isCurrent
            readonly property bool isVideo: safeFileName.startsWith("000_")
            readonly property string thumbPath: window.thumbDir + "/" + safeFileName
            readonly property bool matchesFilter: window.checkItemMatchesFilter(
                safeFileName, isVideo, window.currentFilter)

            readonly property real targetWidth:  isVisuallyEnlarged ? (window.itemWidth * 1.5) : (window.itemWidth * 0.5)
            readonly property real targetHeight: isVisuallyEnlarged ? (window.itemHeight + window.s(30)) : window.itemHeight

            property bool isPlayingVideo: false
            readonly property bool isNearCenter: Math.abs(view.currentIndex - index) <= 3

            Timer {
                id: videoPlayTimer
                interval: 150
                running: delegateRoot.isNearCenter && delegateRoot.isVideo &&
                         !window.isFilterAnimating && window.isReady
                onTriggered: {
                    if (delegateRoot.isNearCenter && delegateRoot.isVideo) {
                        delegateRoot.isPlayingVideo = true
                        previewPlayer.play()
                    }
                }
            }
            onIsNearCenterChanged: {
                if (!isNearCenter) {
                    isPlayingVideo = false
                    videoPlayTimer.stop()
                    previewPlayer.stop()
                }
            }

            width:   matchesFilter ? (targetWidth + window.spacing) : 0
            visible: width > 0.1 || opacity > 0.01
            opacity: matchesFilter ? (isVisuallyEnlarged ? 1.0 : 0.6) : 0.0
            scale:   matchesFilter ? 1.0 : 0.5
            height:  matchesFilter ? targetHeight : 0
            anchors.verticalCenter: parent ? parent.verticalCenter : undefined

            anchors.verticalCenterOffset: window.s(15)
            z: isVisuallyEnlarged ? 10 : 1

            Behavior on scale   { enabled: window.initialFocusSet; NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
            Behavior on width   { enabled: window.initialFocusSet; NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
            Behavior on height  { enabled: window.initialFocusSet; NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
            Behavior on opacity { enabled: window.initialFocusSet; NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }

            Item {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: ((window.itemHeight - height) / 2) * window.skewFactor
                width:  parent.width > 0 ? parent.width * (targetWidth / (targetWidth + window.spacing)) : 0
                height: parent.height

                transform: Matrix4x4 {
                    property real s: window.skewFactor
                    matrix: Qt.matrix4x4(1, s, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: delegateRoot.matchesFilter && !window.isApplying
                    onClicked: {
                        view.currentIndex = index
                        window.applyWallpaper(delegateRoot.safeFileName, delegateRoot.isVideo)
                    }
                }

                Item {
                    anchors.fill: parent
                    anchors.margins: window.borderWidth
                    Rectangle { anchors.fill: parent; color: "black" }
                    clip: true

                    Image {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: window.s(-50)
                        width:  (window.itemWidth * 1.5) + ((window.itemHeight + window.s(30)) * Math.abs(window.skewFactor)) + window.s(50)
                        height: window.itemHeight + window.s(30)
                        fillMode: Image.PreserveAspectCrop

                        // Only try thumbnail, and only fallback if it's NOT a video
                        source: thumbPath
                        onStatusChanged: {
                            if (status === Image.Error && !delegateRoot.isVideo) {
                                source = fileUrl
                            }
                        }

                        // Show a placeholder if it's a video and no thumbnail exists
                        Rectangle {
                            anchors.fill: parent
                            color: _theme.mantle
                            visible: delegateRoot.isVideo && parent.status !== Image.Ready

                            Column {
                                anchors.centerIn: parent
                                spacing: window.s(10)
                                Text {
                                    text: "󰈫"
                                    font.family: _theme.monoFamily
                                    font.pixelSize: window.s(48)
                                    color: _theme.surface1
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                Text {
                                    text: "VIDEO"
                                    font.family: _theme.sansFamily
                                    font.pixelSize: window.s(14)
                                    color: _theme.surface1
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.letterSpacing: 2
                                }
                            }
                        }

                        asynchronous: true
                        transform: Matrix4x4 {
                            property real s: -window.skewFactor
                            matrix: Qt.matrix4x4(1, s, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                        }
                    }

                    MediaPlayer {
                        id: previewPlayer
                        source: delegateRoot.isPlayingVideo && fileUrl !== undefined ? fileUrl : ""
                        audioOutput: AudioOutput { muted: true }
                        videoOutput: previewOutput
                        loops: MediaPlayer.Infinite
                    }
                    VideoOutput {
                        id: previewOutput
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: window.s(-50)
                        width:  (window.itemWidth * 1.5) + ((window.itemHeight + window.s(30)) * Math.abs(window.skewFactor)) + window.s(50)
                        height: window.itemHeight + window.s(30)
                        fillMode: VideoOutput.PreserveAspectCrop
                        visible: delegateRoot.isPlayingVideo && previewPlayer.playbackState === MediaPlayer.PlayingState
                        transform: Matrix4x4 {
                            property real s: -window.skewFactor
                            matrix: Qt.matrix4x4(1, s, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                        }
                    }

                    // Video icon badge
                    Rectangle {
                        visible: delegateRoot.isVideo &&
                                 (!delegateRoot.isPlayingVideo || previewPlayer.playbackState !== MediaPlayer.PlayingState)
                        anchors.top: parent.top; anchors.right: parent.right; anchors.margins: window.s(10)
                        width: window.s(32); height: window.s(32); radius: window.s(6); color: "#60000000"
                        transform: Matrix4x4 {
                            property real s: -window.skewFactor
                            matrix: Qt.matrix4x4(1, s, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                        }
                        Canvas {
                            anchors.fill: parent; anchors.margins: window.s(8)
                            property real scaleTrigger: window.s(1)
                            onScaleTriggerChanged: requestPaint()
                            onPaint: {
                                var ctx = getContext("2d"); var s = window.s
                                ctx.reset(); ctx.fillStyle = "#EEFFFFFF"; ctx.beginPath()
                                ctx.moveTo(s(4), 0); ctx.lineTo(s(14), s(8)); ctx.lineTo(s(4), s(16))
                                ctx.closePath(); ctx.fill()
                            }
                        }
                    }
                    // Focus Pulse Border
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: delegateRoot.isCurrent ? _theme.mauve : "transparent"
                        border.width: delegateRoot.isCurrent ? window.s(4) : 0
                        z: 100
                        opacity: delegateRoot.isCurrent ? 1.0 : 0.0

                        SequentialAnimation on opacity {
                            running: delegateRoot.isCurrent
                            loops: Animation.Infinite
                            NumberAnimation { from: 0.5; to: 1.0; duration: 1000; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1.0; to: 0.5; duration: 1000; easing.type: Easing.InOutSine }
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // FILTER BAR  (top-floating pill)
    // -------------------------------------------------------------------------
    Rectangle {
        id: filterBarBackground
        anchors.top: parent.top
        anchors.topMargin: window.isReady ? window.s(40) : window.s(-100)
        opacity: window.isReady ? 1.0 : 0.0
        Behavior on anchors.topMargin { NumberAnimation { duration: 600; easing.type: Easing.OutExpo } }
        Behavior on opacity           { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        anchors.horizontalCenter: parent.horizontalCenter
        z: 20
        height: window.s(56)
        width: filterRow.width + window.s(24)
        radius: window.s(14)
        color: Qt.rgba(_theme.mantle.r, _theme.mantle.g, _theme.mantle.b, 0.90)
        border.color: Qt.rgba(_theme.surface2.r, _theme.surface2.g, _theme.surface2.b, 0.8)
        border.width: 1

        Row {
            id: filterRow
            anchors.centerIn: parent
            spacing: window.s(12)

            // ── Filter buttons ────────────────────────────────────────────────
            Repeater {
                model: window.filterData
                delegate: Item {
                    visible: modelData.name !== "Search"
                    width: !visible ? 0 : ((modelData.name === "Video" || modelData.name === "All")
                        ? window.s(44)
                        : (modelData.hex === "" ? filterText.contentWidth + window.s(24) : window.s(36)))
                    height: !visible ? 0 : window.s(36)
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.fill: parent
                        radius: window.s(10)
                        color: modelData.hex === ""
                            ? (window.currentFilter === modelData.name ? _theme.surface2 : "transparent")
                            : modelData.hex
                        border.color: window.currentFilter === modelData.name
                            ? _theme.text
                            : Qt.rgba(_theme.surface1.r, _theme.surface1.g, _theme.surface1.b, 0.6)
                        border.width: window.currentFilter === modelData.name ? window.s(2) : 1
                        scale: window.currentFilter === modelData.name ? 1.15 : (filterMouse.containsMouse ? 1.08 : 1.0)
                        Behavior on scale       { NumberAnimation { duration: 400; easing.type: Easing.OutBack; easing.overshoot: 1.2 } }
                        Behavior on border.color { ColorAnimation { duration: 300 } }

                        Text {
                            id: filterText
                            visible: modelData.hex === "" && modelData.name !== "Video" && modelData.name !== "All"
                            text: modelData.label
                            anchors.centerIn: parent
                            color: window.currentFilter === modelData.name
                                ? _theme.text
                                : Qt.rgba(_theme.text.r, _theme.text.g, _theme.text.b, 0.7)
                            font.family: _theme.monoFamily; font.pixelSize: window.s(14)
                            font.weight: window.currentFilter === modelData.name ? Font.DemiBold : Font.Normal
                            Behavior on color { ColorAnimation { duration: 400; easing.type: Easing.OutQuart } }
                        }

                        // Play triangle for "Video" filter
                        Canvas {
                            visible: modelData.name === "Video"
                            width: window.s(14); height: window.s(16)
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: window.s(2)
                            property string activeColor: window.currentFilter === modelData.name
                                ? _theme.text
                                : Qt.rgba(_theme.text.r, _theme.text.g, _theme.text.b, 0.7)
                            onActiveColorChanged: requestPaint()
                            property real scaleTrigger: window.s(1); onScaleTriggerChanged: requestPaint()
                            onPaint: {
                                var ctx = getContext("2d"); var s = window.s; ctx.reset()
                                ctx.fillStyle = activeColor; ctx.beginPath()
                                ctx.moveTo(0, 0); ctx.lineTo(s(14), s(8)); ctx.lineTo(0, s(16))
                                ctx.closePath(); ctx.fill()
                            }
                        }

                        // Four-squares for "All" filter
                        Canvas {
                            visible: modelData.name === "All"
                            width: window.s(14); height: window.s(14)
                            anchors.centerIn: parent
                            property string activeColor: window.currentFilter === modelData.name
                                ? _theme.text
                                : Qt.rgba(_theme.text.r, _theme.text.g, _theme.text.b, 0.7)
                            onActiveColorChanged: requestPaint()
                            property real scaleTrigger: window.s(1); onScaleTriggerChanged: requestPaint()
                            onPaint: {
                                var ctx = getContext("2d"); var s = window.s; ctx.reset()
                                ctx.fillStyle = activeColor
                                ctx.fillRect(0,    0,    s(6), s(6))
                                ctx.fillRect(s(8), 0,    s(6), s(6))
                                ctx.fillRect(0,    s(8), s(6), s(6))
                                ctx.fillRect(s(8), s(8), s(6), s(6))
                            }
                        }
                    }

                    MouseArea {
                        id: filterMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !window.isApplying
                        cursorShape: Qt.PointingHandCursor
                        onClicked: window.currentFilter = modelData.name
                    }
                }
            }

        }
    }

    // -------------------------------------------------------------------------
    // LIFECYCLE
    // -------------------------------------------------------------------------
    Component.onCompleted: {
        view.forceActiveFocus()
    }

    Component.onDestruction: {
    }
}
