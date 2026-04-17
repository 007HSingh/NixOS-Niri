#!/usr/bin/env bash
# generate_thumbs.sh
# Run this once (or after adding new wallpapers) to populate:
#   ~/.cache/wallpaper_picker/thumbs/       — 400-px tall JPEG thumbnails
#   ~/.cache/wallpaper_picker/colors_markers/ — zero-byte marker files encoding dominant hex
#
# The wallpaper picker watches both directories via FolderListModel so it
# will pick up new entries automatically while this script runs.

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/.config/wallpapers}"
CACHE_DIR="$HOME/.cache/wallpaper_picker"
THUMB_DIR="$CACHE_DIR/thumbs"
COLOR_DIR="$CACHE_DIR/colors_markers"

mkdir -p "$THUMB_DIR" "$COLOR_DIR"

if command -v magick &>/dev/null; then CMD="magick"; else CMD="convert"; fi

mapfile -t files < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
  \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \
  -o -iname "*.webp" -o -iname "*.gif" \
  -o -iname "*.mp4" -o -iname "*.mkv" \
  -o -iname "*.mov" -o -iname "*.webm" \) |
  sort)
total=${#files[@]}
echo "Found $total wallpapers in $WALLPAPER_DIR"

i=0
for file in "${files[@]}"; do
  ((i++)) || true
  filename=$(basename "$file")
  thumb="$THUMB_DIR/$filename"
  printf "[%3d/%3d] %s\n" "$i" "$total" "$filename"

  # ── Thumbnail ─────────────────────────────────────────────────────────────
  if [ ! -f "$thumb" ]; then
    if [[ "$filename" =~ \.(mp4|mkv|mov|webm)$ ]]; then
      # Prefix video thumbs with 000_ so the picker can identify them
      vthumb="$THUMB_DIR/000_$filename"
      if [ ! -f "$vthumb" ]; then
        ffmpeg -ss 00:00:01 -i "$file" -frames:v 1 -q:v 3 \
          -vf "scale=-2:420" "$vthumb" -y 2>/dev/null || true
      fi
      thumb="$vthumb"
      filename="000_$filename"
    else
      $CMD "$file" -thumbnail x420 -quality 80 "$thumb" 2>/dev/null || true
    fi
  fi

  # ── Color marker ─────────────────────────────────────────────────────────
  # Skip if a marker already exists for this thumb
  found=0
  for marker in "$COLOR_DIR/$filename"_HEX_*; do
    [ -e "$marker" ] && found=1 && break
  done

  if [ $found -eq 0 ] && [ -f "$thumb" ]; then
    hex=$($CMD "$thumb" -modulate 100,200 -resize "1x1^" -gravity center -extent 1x1 \
      -depth 8 -format "%[hex:p{0,0}]" info:- 2>/dev/null |
      grep -oE '[0-9A-Fa-f]{6}' | head -n 1)
    [ -n "$hex" ] && touch "$COLOR_DIR/${filename}_HEX_${hex}"
  fi
done

echo "Done. Thumbnails: $(ls "$THUMB_DIR" | wc -l)  Color markers: $(ls "$COLOR_DIR" | wc -l)"
