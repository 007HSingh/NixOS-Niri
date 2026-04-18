#!/usr/bin/env bash
# ddg_search.sh  — thumbnail downloader for the wallpaper picker DDG search
# Called by WallpaperPicker.qml via Quickshell.execDetached.
# Reads full-URL/thumb-URL pairs from get_ddg_links.py stdout, downloads
# thumbnails into the search cache, and appends to search_map.txt so the
# apply logic can later fetch the full-resolution image.

QUERY="$1"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
CACHE_DIR="$HOME/.cache/wallpaper_picker"
SEARCH_DIR="$CACHE_DIR/search_thumbs"
MAP_FILE="$CACHE_DIR/search_map.txt"
CONTROL_FILE="/tmp/ddg_search_control"
LOG_FILE="/tmp/qs_ddg_downloader.log"

echo "=== Starting search for: $QUERY ===" >"$LOG_FILE"

mkdir -p "$SEARCH_DIR"

python3 -u "$SCRIPT_DIR/get_ddg_links.py" "$QUERY" | while IFS='|' read -r thumb_url full_url; do

  state=$(cat "$CONTROL_FILE" 2>/dev/null | tr -d '[:space:]')

  if [[ $state == "stop" ]]; then
    echo "Stop signal received. Exiting." >>"$LOG_FILE"
    exit 0
  fi

  while [[ $state == "pause" ]]; do
    sleep 1
    state=$(cat "$CONTROL_FILE" 2>/dev/null | tr -d '[:space:]')
  done

  [ -z "$thumb_url" ] || [ -z "$full_url" ] && continue

  uuid=$(date +%s%N)
  ext="${full_url##*.}"
  ext="${ext%%\?*}"
  ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
  [[ ! $ext =~ ^(jpg|jpeg|png|webp|gif)$ ]] && ext="jpg"

  is_webp=0
  if [[ $ext == "webp" ]]; then
    is_webp=1
    ext="jpg"
  fi

  filename="ddg_${uuid}.${ext}"
  filepath="$SEARCH_DIR/$filename"
  tmppath="${filepath}.tmp"

  echo "Downloading thumb: $thumb_url -> $filename" >>"$LOG_FILE"

  curl -s -L -m 8 -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$thumb_url" -o "$tmppath"

  state=$(cat "$CONTROL_FILE" 2>/dev/null | tr -d '[:space:]')
  if [[ $state == "stop" ]]; then
    echo "Stop signal during download. Discarding." >>"$LOG_FILE"
    rm -f "$tmppath"
    exit 0
  fi

  if [ -s "$tmppath" ]; then
    actual_mime=$(file -b --mime-type "$tmppath")
    if [[ ! $actual_mime =~ ^image/ ]]; then
      echo "ERROR: Thumb is not an image ($actual_mime). Discarding." >>"$LOG_FILE"
      rm -f "$tmppath"
    else
      if [[ $actual_mime == "image/webp" ]] || [ $is_webp -eq 1 ]; then
        magick "$tmppath" "$filepath" 2>/dev/null || mv "$tmppath" "$filepath"
        rm -f "$tmppath"
      else
        mv "$tmppath" "$filepath"
      fi
      echo "$filename|$full_url" >>"$MAP_FILE"
      echo "Success: $filename saved." >>"$LOG_FILE"
    fi
  else
    echo "ERROR: Empty/failed download for $thumb_url" >>"$LOG_FILE"
    rm -f "$tmppath"
  fi
done

echo "=== Pipeline finished ===" >>"$LOG_FILE"
