#!/usr/bin/env bash

# Function to generate a bar string
get_bar() {
    local val=$1
    local label=$2
    local width=15
    local filled=$(( val * width / 100 ))
    [ "$filled" -lt 0 ] && filled=0
    [ "$filled" -gt "$width" ] && filled="$width"
    local empty=$(( width - filled ))
    
    local res
    res=$(printf " %-4s " "$label")
    for ((i=0; i<filled; i++)); do res+="█"; done
    for ((i=0; i<empty; i++)); do res+="░"; done
    res+=$(printf " %3d%%" "$val")
    echo "$res"
}

# Stats
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | cut -d. -f1)
ram_usage=$(free | grep Mem | awk '{printf "%d", $3/$2 * 100}')
disk_usage=$(df / --output=pcent | tail -1 | tr -dc '0-9')

# Dashboard lines
dash=(
    ""
    "   󱄅  SYSTEM DASHBOARD"
    "   ──────────────────────────────"
    "  $(get_bar "$cpu_usage" "CPU")"
    "  $(get_bar "$ram_usage" "RAM")"
    "  $(get_bar "$disk_usage" "DSK")"
    "   ──────────────────────────────"
)

# Cat file path
CAT_FILE="$(dirname "$0")/cat.txt"

# Merge cat and dashboard side-by-side
{
    idx=0
    while IFS= read -r line || [ -n "$line" ]; do
        # Pad cat line to 18 chars for alignment
        printf "%-18s" "$line"
        if [ $idx -lt ${#dash[@]} ]; then
            echo "${dash[$idx]}"
        else
            echo ""
        fi
        ((idx++))
    done < "$CAT_FILE"
    
    # If dashboard has more lines than the cat, print them
    while [ $idx -lt ${#dash[@]} ]; do
        printf "%-18s" ""
        echo "${dash[$idx]}"
        ((idx++))
    done
} | lolcat -f
