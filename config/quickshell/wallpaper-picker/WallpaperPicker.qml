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
    property string searchQuery: ""
    property bool isOnlineSearch: false
    property bool isSearchPaused: false
    property bool hasSearched: false

    // Download / status tracking
    property bool isDownloadingWallpaper: false
    property string currentDownloadName: ""

    // Strict apply lock — blocks all input while wallpaper is being set
    property bool isApplying: false

    // Reactive status
    property bool isStartup: srcFolderModel.status === FolderListModel.Loading
    property bool isReady: visible && srcFolderModel.status === FolderListModel.Ready
    property bool isSearchActive: window.currentFilter === "Search" && window.hasSearched &&
                                  searchFolderModel.status === FolderListModel.Loading

    // Memory for search
    property string lastSearchName: ""
    property bool isModelChanging: false
    property bool searchIndexRestored: false

    property bool isScrollingBlocked: window.currentFilter === "Search" &&
                                      window.hasSearched &&
                                      window.isSearchActive &&
                                      !window.isSearchPaused
    property bool jumpToLastOnFilterChange: false

    readonly property var filterData: [
        { name: "All",    hex: "", label: "All"    },
        { name: "Video",  hex: "", label: "Vid"    },
        { name: "Search", hex: "", label: "Search" }
    ]

    // -------------------------------------------------------------------------
    // PATHS
    // -------------------------------------------------------------------------
    readonly property string homeDir: "file://" + Quickshell.env("HOME")
    readonly property string searchDir: homeDir + "/.cache/wallpaper_picker/search_thumbs"
    readonly property string srcDir: {
        const dir = Quickshell.env("WALLPAPER_DIR")
        return (dir && dir !== "")
            ? dir
            : Quickshell.env("HOME") + "/.config/wallpapers"
    }

    // -------------------------------------------------------------------------
    // APPLY WALLPAPER  (awww instead of swww, no matugen)
    // -------------------------------------------------------------------------
    readonly property var transitions: ["grow", "outer", "any", "wipe", "wave", "pixel", "center"]

    function applyWallpaper(safeFileName, isVideo) {
        if (!safeFileName || window.isApplying) return

        window.isApplying = true
        window.targetWallName = safeFileName

        let cleanName = window.getCleanName(safeFileName)
        const escapeBash = (str) => String(str).replace(/(["\\$`])/g, '\\$1')
        const randomTransition = window.transitions[Math.floor(Math.random() * window.transitions.length)]

        // ── Online search result ──────────────────────────────────────────────
        if (window.currentFilter === "Search" && window.hasSearched) {
            let alreadyExists = window.isDownloaded(safeFileName)
            let destFile  = window.srcDir + "/" + safeFileName
            let tempThumb = decodeURIComponent(window.searchDir.replace("file://", "")) + "/" + safeFileName
            let mapFile   = Quickshell.env("HOME") + "/.cache/wallpaper_picker/search_map.txt"

            if (alreadyExists) {
                const applyScript = `
                    (
                        echo 'close' > /tmp/qs_widget_state

                        export WAYLAND_DISPLAY="${Quickshell.env("WAYLAND_DISPLAY")}"
                        export XDG_RUNTIME_DIR="${Quickshell.env("XDG_RUNTIME_DIR")}"
                        export DEST_FILE="${escapeBash(destFile)}"

                        cp "$DEST_FILE" /tmp/lock_bg.png || true
                        pkill mpvpaper || true

                        awww img "$DEST_FILE" \
                            --transition-type ${randomTransition} \
                            --transition-fps 144 \
                            --transition-duration 1 \
                            >/dev/null 2>&1 || true

                    ) </dev/null >/dev/null 2>&1 & disown
                `
                Quickshell.execDetached(["bash", "-c", applyScript])
            } else {
                window.isDownloadingWallpaper = true
                window.currentDownloadName = safeFileName

                const downloadScript = `
                    export SAFE_NAME="${escapeBash(safeFileName)}"
                    export DEST_FILE="${escapeBash(destFile)}"
                    export TEMP_THUMB="${escapeBash(tempThumb)}"
                    export MAP_FILE="${escapeBash(mapFile)}"

                    (
                        URL=$(awk -F'|' -v fname="$SAFE_NAME" '$1 == fname {print $2; exit}' "$MAP_FILE")
                        if [ -n "$URL" ]; then
                            curl -s -L -A "Mozilla/5.0" "$URL" -o "$DEST_FILE.tmp"

                            if file "$DEST_FILE.tmp" | grep -iq "webp"; then
                                magick "$DEST_FILE.tmp" "$DEST_FILE"
                                rm -f "$DEST_FILE.tmp"
                            else
                                mv "$DEST_FILE.tmp" "$DEST_FILE"
                            fi

                            echo 'close' > /tmp/qs_widget_state

                            cp "$DEST_FILE" /tmp/lock_bg.png || true
                            pkill mpvpaper || true

                            awww img "$DEST_FILE" \
                                --transition-type ${randomTransition} \
                                --transition-fps 144 \
                                --transition-duration 1 \
                                >/dev/null 2>&1 || true
                        fi
                    ) </dev/null >/dev/null 2>&1 & disown
                `
                Quickshell.execDetached(["bash", "-c", downloadScript])
            }
            return
        }

        // ── Local wallpaper ───────────────────────────────────────────────────
        const originalFile = window.srcDir + "/" + cleanName
        const escOriginal = escapeBash(originalFile)

        let wallpaperCmd = ""
        let lockBgCmd    = ""

        if (isVideo) {
            wallpaperCmd = `mpvpaper -o 'loop --no-audio --hwdec=auto --profile=high-quality --video-sync=display-resample --interpolation --tscale=oversample' '*' "$WALL_FILE"`
            lockBgCmd    = `ffmpeg -ss 1 -i "$WALL_FILE" -frames:v 1 -q:v 3 /tmp/lock_bg.png -y 2>/dev/null || true`
        } else {
            wallpaperCmd = `
                awww img "$WALL_FILE" \
                    --transition-type ${randomTransition} \
                    --transition-fps 144 \
                    --transition-duration 1 \
                    >/dev/null 2>&1 || true
            `
            lockBgCmd = `cp "$WALL_FILE" /tmp/lock_bg.png`
        }

        const fullScript = `
            (
                echo 'close' > /tmp/qs_widget_state

                export WAYLAND_DISPLAY="${Quickshell.env("WAYLAND_DISPLAY")}"
                export XDG_RUNTIME_DIR="${Quickshell.env("XDG_RUNTIME_DIR")}"
                export WALL_FILE="${escOriginal}"

                ${lockBgCmd} || true
                pkill mpvpaper || true

                ${wallpaperCmd}

            ) </dev/null >/dev/null 2>&1 & disown
        `
        Quickshell.execDetached(["bash", "-c", fullScript])
    }

    // -------------------------------------------------------------------------
    // PERSISTENT SETTINGS (survive widget close/reopen)
    // -------------------------------------------------------------------------
    QtObject {
        id: searchState
        property string query:    ""
        property bool   searched: false
        property string lastName: ""
    }

    onIsSearchPausedChanged: {
        Quickshell.execDetached(["bash", "-c",
            "echo '" + (isSearchPaused ? "pause" : "run") + "' > /tmp/ddg_search_control"])
    }

    // -------------------------------------------------------------------------
    // VISIBILITY
    // -------------------------------------------------------------------------
    onVisibleChanged: {
        if (!visible) {
            window.initialFocusSet = false
            window.searchIndexRestored = false
            window.isApplying = false

            if (window.hasSearched) window.isSearchPaused = true
        } else {
            window.isFilterAnimating = true
            filterAnimationTimer.restart()

            if (window.currentFilter !== "Search") {
                window.applyFilters(true)
            } else if (window.hasSearched) {
                window.searchIndexRestored = false
                window.isSearchPaused = true
                window.trySearchFocus()
                window.syncSearchModel()
            }
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
        let targetModel = window.getModelForFilter(window.currentFilter)
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

    function trySearchFocus() {
        if (window.searchIndexRestored || searchProxyModel.count === 0) return
        if (window.lastSearchName === "") { window.searchIndexRestored = true; return }
        for (let i = 0; i < searchProxyModel.count; i++) {
            let fname = searchProxyModel.get(i).fileName || ""
            if (fname === window.lastSearchName) {
                window.executeFocusRestore(i, true, true)
                return
            }
        }
        if (searchFolderModel.status === FolderListModel.Ready &&
            searchProxyModel.count === searchFolderModel.count) {
            window.searchIndexRestored = true
        }
    }

    function getModelForFilter(filter) {
        return filter === "Search" ? searchProxyModel : localProxyModel
    }

    function updateVisibleCount() {
        let targetModel = window.getModelForFilter(window.currentFilter)
        if (!targetModel || targetModel.count === 0) { window.visibleItemCount = 0; return }
        let count = 0
        for (let i = 0; i < targetModel.count; i++) {
            let fname = targetModel.get(i).fileName || ""
            let isVid = fname.startsWith("000_")
            if (checkItemMatchesFilter(fname, isVid, window.currentFilter)) count++
        }
        window.visibleItemCount = count
    }

    function triggerOnlineSearch() {
        if (searchInput.text.trim() === "") return

        window.isModelChanging = true
        searchProxyModel.clear()
        window.lastSearchName = ""
        searchState.lastName = ""
        if (window.currentFilter === "Search") {
            view.currentIndex = 0
            view.positionViewAtIndex(0, ListView.Center)
        }
        window.isModelChanging = false

        window.searchIndexRestored = true
        window.isOnlineSearch = true
        window.hasSearched = true
        window.visibleItemCount = 0
        searchState.searched = true
        searchState.query = searchInput.text.trim()
        window.isSearchPaused = false
        window.searchQuery = searchInput.text.trim()

        let rawSearchDir = decodeURIComponent(window.searchDir.replace(/^file:\/\//, ""))
        let scriptPath   = decodeURIComponent(
            Qt.resolvedUrl("ddg_search.sh").toString().replace(/^file:\/\//, ""))

        const cmd = `
            exec > /tmp/qs_ddg_run.log 2>&1
            export PATH=$PATH:/run/current-system/sw/bin

            echo 'stop' > /tmp/ddg_search_control

            for p in $(pgrep -f ddg_search.sh); do
                if [ "$p" != "$$" ] && [ "$p" != "$BASHPID" ]; then
                    kill -9 $p 2>/dev/null || true
                fi
            done
            pkill -f "[g]et_ddg_links.py" || true
            sleep 0.2

            rm -rf "${rawSearchDir}"/* || true
            rm -f "${rawSearchDir}/../search_map.txt" || true

            echo 'run' > /tmp/ddg_search_control
            bash "${scriptPath}" "${window.searchQuery}" &
        `
        Quickshell.execDetached(["bash", "-c", cmd])
        searchInput.focus = false
        view.forceActiveFocus()
    }

    // -------------------------------------------------------------------------
    // COLOR FILTERING
    // -------------------------------------------------------------------------
    function checkItemMatchesFilter(fileName, isVid, filter) {
        if (filter === "Search") return true
        if (filter === "All")   return true
        if (filter === "Video") return isVid
        return false
    }

    // -------------------------------------------------------------------------
    // NAVIGATION HELPERS
    // -------------------------------------------------------------------------
    function stepToNextValidIndex(direction) {
        let targetModel = window.getModelForFilter(window.currentFilter)
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
        let targetModel = window.getModelForFilter(window.currentFilter)
        if (!targetModel || targetModel.count === 0) { window.updateVisibleCount(); return }
        if (window.currentFilter === "Search") { window.updateVisibleCount(); return }

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
        window.updateVisibleCount()
    }

    onCurrentFilterChanged: {
        window.isFilterAnimating = true
        filterAnimationTimer.restart()
        window.isModelChanging = true
        let returningFromSearch = (window._lastFilter === "Search" && window.currentFilter !== "Search")
        window._lastFilter = window.currentFilter
        if (returningFromSearch) window.searchIndexRestored = false

        Qt.callLater(() => {
            view.forceActiveFocus()
            if (window.currentFilter === "Search") {
                if (window.hasSearched) { window.searchIndexRestored = false; window.trySearchFocus() }
            } else {
                window.applyFilters(returningFromSearch)
            }
            window.isModelChanging = false
        })
    }

    // -------------------------------------------------------------------------
    // KEYBOARD SHORTCUTS
    // -------------------------------------------------------------------------
    Shortcut {
        sequence: "Left"
        enabled: !window.isScrollingBlocked && !window.isApplying
        onActivated: window.stepToNextValidIndex(-1)
    }
    Shortcut {
        sequence: "Right"
        enabled: !window.isScrollingBlocked && !window.isApplying
        onActivated: window.stepToNextValidIndex(1)
    }
    Shortcut {
        sequence: "Return"
        enabled: !searchInput.activeFocus && !window.isScrollingBlocked && !window.isApplying
        onActivated: {
            let targetModel = window.getModelForFilter(window.currentFilter)
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
    ListModel { id: searchProxyModel }

    readonly property var activeModel: window.currentFilter === "Search" ? searchProxyModel : localProxyModel

    FolderListModel {
        id: srcFolderModel
        folder: "file://" + window.srcDir
        nameFilters: ["*.jpg","*.jpeg","*.png","*.webp","*.gif","*.mp4","*.mkv","*.mov","*.webm"]
        showDirs: false
        sortField: FolderListModel.Name
        onCountChanged: {
            window.syncLocalModel()
            if (window.isDownloadingWallpaper && window.isDownloaded(window.currentDownloadName))
                window.isDownloadingWallpaper = false
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
        if (window.currentFilter !== "Search") window.updateVisibleCount()
        if (!window.initialFocusSet && window.currentFilter !== "Search" && localProxyModel.count > 0)
            window.tryFocus()
    }

    FolderListModel {
        id: searchFolderModel
        folder: window.searchDir
        nameFilters: ["*.jpg","*.jpeg","*.png","*.webp","*.gif","*.mp4","*.mkv","*.mov","*.webm"]
        showDirs: false
        sortField: FolderListModel.Name
        onFolderChanged: {
            window.isModelChanging = true; searchProxyModel.clear(); window.isModelChanging = false
        }
        onCountChanged:  window.syncSearchModel()
        onStatusChanged: { if (status === FolderListModel.Ready) window.syncSearchModel() }
    }

    function syncSearchModel() {
        let startIdx = searchProxyModel.count
        let endIdx   = searchFolderModel.count
        if (endIdx < startIdx) {
            window.isModelChanging = true; searchProxyModel.clear(); startIdx = 0; window.isModelChanging = false
        }
        for (let i = startIdx; i < endIdx; i++) {
            let fn = searchFolderModel.get(i, "fileName")
            let fu = searchFolderModel.get(i, "fileUrl")
            if (fn !== undefined) searchProxyModel.append({ "fileName": fn, "fileUrl": String(fu) })
        }
        if (window.currentFilter === "Search") window.updateVisibleCount()
        if (window.currentFilter === "Search" && window.hasSearched) {
            if (!window.searchIndexRestored) window.trySearchFocus()
            if (window.isScrollingBlocked && startIdx === 0 && searchProxyModel.count > 0 &&
                window.lastSearchName === "") {
                view.forceLayout()
                view.currentIndex = 0
                view.positionViewAtIndex(0, ListView.Center)
            }
        }
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
        interactive: !window.isScrollingBlocked && !window.isApplying
        cacheBuffer: 2000

        highlightRangeMode:      ListView.StrictlyEnforceRange
        preferredHighlightBegin: (width / 2) - ((window.itemWidth * 1.5 + window.spacing) / 2)
        preferredHighlightEnd:   (width / 2) + ((window.itemWidth * 1.5 + window.spacing) / 2)
        highlightMoveDuration:   window.initialFocusSet ? 500 : 0
        focus: true

        onCurrentIndexChanged: {
            window.isItemAnimating = true
            itemAnimationTimer.restart()
            if (view.model !== searchProxyModel || window.currentFilter !== "Search") return
            if (!window.isModelChanging && window.hasSearched && window.searchIndexRestored) {
                if (currentIndex >= 0 && currentIndex < searchProxyModel.count) {
                    let fname = searchProxyModel.get(currentIndex).fileName
                    if (fname !== undefined && fname !== "") {
                        window.lastSearchName = String(fname)
                        searchState.lastName = String(fname)
                    }
                }
            }
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
                if (window.isScrollingBlocked || window.isApplying) { wheel.accepted = true; return }
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
            readonly property bool isCurrent: ListView.isCurrentItem && !window.isScrollingBlocked
            readonly property bool isFakeSelected: window.isScrollingBlocked && index === 0
            readonly property bool isVisuallyEnlarged: isCurrent || isFakeSelected
            readonly property bool isVideo: safeFileName.startsWith("000_")
            readonly property bool matchesFilter: window.checkItemMatchesFilter(
                safeFileName, isVideo, window.currentFilter)

            readonly property real targetWidth:  isVisuallyEnlarged ? (window.itemWidth * 1.5) : (window.itemWidth * 0.5)
            readonly property real targetHeight: isVisuallyEnlarged ? (window.itemHeight + window.s(30)) : window.itemHeight

            property bool isPlayingVideo: false

            Timer {
                id: videoPlayTimer
                interval: 250
                running: delegateRoot.isVisuallyEnlarged && delegateRoot.isVideo &&
                         !window.isScrollingBlocked && !window.isFilterAnimating && !window.isItemAnimating
                onTriggered: {
                    if (delegateRoot.isVisuallyEnlarged && delegateRoot.isVideo) {
                        delegateRoot.isPlayingVideo = true
                        previewPlayer.play()
                    }
                }
            }
            onIsVisuallyEnlargedChanged: {
                if (!isVisuallyEnlarged) {
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
            anchors.verticalCenter: parent.verticalCenter
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
                    enabled: delegateRoot.matchesFilter && !window.isScrollingBlocked && !window.isApplying
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
                        source: fileUrl !== undefined ? fileUrl : ""
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
                            font.family: "JetBrains Mono"; font.pixelSize: window.s(14)
                            font.bold: window.currentFilter === modelData.name
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

            // ── Search pause/resume button (visible only during search) ───────
            Rectangle {
                id: searchControlBtn
                visible: window.currentFilter === "Search" && window.hasSearched
                width: visible ? window.s(44) : 0
                height: window.s(44); radius: window.s(10); clip: true
                color: window.isSearchPaused ? _theme.surface2 : "transparent"
                border.color: window.isSearchPaused
                    ? _theme.text
                    : Qt.rgba(_theme.surface1.r, _theme.surface1.g, _theme.surface1.b, 0.6)
                border.width: window.isSearchPaused ? window.s(2) : 1
                Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.OutBack; easing.overshoot: 0.5 } }
                Behavior on color { ColorAnimation { duration: 400; easing.type: Easing.OutQuart } }

                MouseArea {
                    id: scMouse; anchors.fill: parent; hoverEnabled: true
                    enabled: !window.isApplying; cursorShape: Qt.PointingHandCursor
                    onClicked: window.isSearchPaused = !window.isSearchPaused
                }

                Canvas {
                    width: window.s(44); height: window.s(44); anchors.centerIn: parent
                    property bool paused: window.isSearchPaused
                    property string activeColor: paused ? _theme.text
                        : (scMouse.containsMouse ? _theme.text
                        : Qt.rgba(_theme.text.r, _theme.text.g, _theme.text.b, 0.7))
                    onActiveColorChanged: requestPaint()
                    onPausedChanged: requestPaint()
                    property real scaleTrigger: window.s(1); onScaleTriggerChanged: requestPaint()
                    onPaint: {
                        var ctx = getContext("2d"); var s = window.s; ctx.reset()
                        ctx.fillStyle = activeColor
                        if (!paused) {
                            ctx.fillRect(s(15), s(14), s(4), s(16))
                            ctx.fillRect(s(25), s(14), s(4), s(16))
                        } else {
                            ctx.beginPath()
                            ctx.moveTo(s(16), s(12)); ctx.lineTo(s(32), s(22)); ctx.lineTo(s(16), s(32))
                            ctx.closePath(); ctx.fill()
                        }
                    }
                }
            }

            // ── Search box ───────────────────────────────────────────────────
            Rectangle {
                id: searchBox
                height: window.s(44)
                width: window.currentFilter === "Search" ? window.s(360) : window.s(44)
                radius: window.s(10); clip: true
                color: window.currentFilter === "Search"
                    ? Qt.rgba(_theme.surface2.r, _theme.surface2.g, _theme.surface2.b, 0.8)
                    : "transparent"
                border.color: window.currentFilter === "Search"
                    ? Qt.rgba(_theme.text.r, _theme.text.g, _theme.text.b, 0.5)
                    : Qt.rgba(_theme.surface1.r, _theme.surface1.g, _theme.surface1.b, 0.6)
                border.width: window.currentFilter === "Search" ? window.s(2) : 1
                Behavior on width       { NumberAnimation { duration: 600; easing.type: Easing.OutBack; easing.overshoot: 0.5 } }
                Behavior on color       { ColorAnimation { duration: 400; easing.type: Easing.OutQuart } }
                Behavior on border.color { ColorAnimation { duration: 400 } }

                MouseArea {
                    id: searchMouseArea; anchors.fill: parent; hoverEnabled: true
                    enabled: !window.isApplying; cursorShape: Qt.PointingHandCursor
                    onClicked: window.currentFilter = (window.currentFilter !== "Search") ? "Search" : "All"
                }

                Canvas {
                    id: searchIcon
                    width: window.s(44); height: window.s(44)
                    anchors.left: parent.left
                    anchors.leftMargin: window.currentFilter === "Search" ? window.s(5) : 0
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on anchors.leftMargin { NumberAnimation { duration: 500; easing.type: Easing.OutExpo } }
                    property string activeColor: window.currentFilter === "Search" ? _theme.text
                        : (searchMouseArea.containsMouse ? _theme.text
                        : Qt.rgba(_theme.text.r, _theme.text.g, _theme.text.b, 0.7))
                    onActiveColorChanged: requestPaint()
                    property real scaleTrigger: window.s(1); onScaleTriggerChanged: requestPaint()
                    onPaint: {
                        var ctx = getContext("2d"); var s = window.s; ctx.reset()
                        ctx.lineWidth = s(3); ctx.strokeStyle = activeColor
                        ctx.beginPath(); ctx.arc(s(18), s(18), s(7), 0, Math.PI * 2); ctx.stroke()
                        ctx.beginPath(); ctx.moveTo(s(23), s(23)); ctx.lineTo(s(31), s(31)); ctx.stroke()
                    }
                }

                TextInput {
                    id: searchInput
                    anchors.left: searchIcon.right; anchors.right: submitBtn.left
                    anchors.rightMargin: window.s(8); anchors.verticalCenter: parent.verticalCenter
                    opacity: window.currentFilter === "Search" ? 1.0 : 0.0
                    visible: opacity > 0
                    Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutQuad } }
                    color: _theme.text
                    font.family: "JetBrains Mono"; font.pixelSize: window.s(16); clip: true
                    onTextEdited: { window.hasSearched = false; searchState.searched = false }
                    onAccepted: { window.triggerOnlineSearch(); searchInput.focus = false; view.forceActiveFocus() }
                }

                Rectangle {
                    id: submitBtn
                    width: window.s(32); height: window.s(32); radius: window.s(8)
                    anchors.right: parent.right; anchors.rightMargin: window.s(8)
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: window.currentFilter === "Search" ? 1.0 : 0.0
                    visible: opacity > 0
                    Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutQuad } }
                    color: submitMouseArea.containsMouse
                        ? Qt.rgba(_theme.text.r, _theme.text.g, _theme.text.b, 0.1)
                        : "transparent"
                    border.color: submitMouseArea.containsMouse
                        ? _theme.text
                        : Qt.rgba(_theme.text.r, _theme.text.g, _theme.text.b, 0.3)
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 300 } }

                    MouseArea {
                        id: submitMouseArea; anchors.fill: parent; hoverEnabled: true
                        enabled: !window.isApplying; cursorShape: Qt.PointingHandCursor
                        onClicked: window.triggerOnlineSearch()
                    }

                    Canvas {
                        width: window.s(16); height: window.s(16); anchors.centerIn: parent
                        property string activeColor: submitMouseArea.containsMouse ? _theme.text
                            : Qt.rgba(_theme.text.r, _theme.text.g, _theme.text.b, 0.7)
                        onActiveColorChanged: requestPaint()
                        property real scaleTrigger: window.s(1); onScaleTriggerChanged: requestPaint()
                        onPaint: {
                            var ctx = getContext("2d"); var s = window.s; ctx.reset()
                            ctx.lineWidth = s(2); ctx.lineCap = "round"; ctx.lineJoin = "round"
                            ctx.strokeStyle = activeColor
                            ctx.beginPath()
                            ctx.moveTo(s(2), s(8)); ctx.lineTo(s(14), s(8))
                            ctx.moveTo(s(9), s(3)); ctx.lineTo(s(14), s(8)); ctx.lineTo(s(9), s(13))
                            ctx.stroke()
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // LIFECYCLE
    // -------------------------------------------------------------------------
    Component.onCompleted: {
        // Ensure search thumb dir exists
        Quickshell.execDetached(["bash", "-c",
            "mkdir -p '" + decodeURIComponent(window.searchDir.replace("file://", "")) + "'"])

        // Restore search state from previous session
        if (searchState.searched) {
            searchInput.text  = searchState.query
            window.searchQuery = searchState.query
            window.hasSearched = true
            window.lastSearchName = searchState.lastName
            window.isSearchPaused = true
        }

        view.forceActiveFocus()
    }

    Component.onDestruction: {
        if (window.hasSearched) {
            searchState.query   = searchInput.text
            searchState.searched = window.hasSearched
            searchState.lastName = window.lastSearchName
            Quickshell.execDetached(["bash", "-c", "echo 'pause' > /tmp/ddg_search_control"])
        } else {
            Quickshell.execDetached(["bash", "-c",
                "echo 'stop' > /tmp/ddg_search_control; " +
                "for p in $(pgrep -f ddg_search.sh); do " +
                "  if [ \"$p\" != \"$$\" ] && [ \"$p\" != \"$BASHPID\" ]; then " +
                "    kill -9 $p 2>/dev/null || true; fi; done; " +
                "pkill -f '[g]et_ddg_links.py'"])
        }
    }
}
