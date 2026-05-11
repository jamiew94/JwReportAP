#!/bin/bash

# JW Reports PDF Sorter v2.0 - 3-Underscore System
# Updated sorting logic for new filename format

DOWNLOADS_DIR="/Users/jamiewatson 1/Downloads"
PRIVATE_DIR="/Users/jamiewatson 1/Google Drive/JW Reports/Private Customers"
SHARED_DIR="/Users/jamiewatson 1/Google Drive/JW Reports/Car Guys - Shared"
LOG_FILE="/Users/jamiewatson 1/Desktop/JW Reports Commands/sort_log.txt"

mkdir -p "$PRIVATE_DIR"
mkdir -p "$SHARED_DIR"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    echo "$1"
}

# Find PDFs with exactly 3 underscores
find "$DOWNLOADS_DIR" -maxdepth 1 -name "*.pdf" -type f ! -name ".*" | while read pdf_path; do
    filename=$(basename "$pdf_path")
    
    # Count underscores (excluding .pdf extension)
    name_no_ext="${filename%.pdf}"
    underscore_count=$(echo "$name_no_ext" | tr -cd '_' | wc -c)
    
    # SAFETY: Must have exactly 3 underscores
    if [ "$underscore_count" -ne 3 ]; then
        log_message "SKIP: $filename (underscores=$underscore_count, need 3)"
        continue
    fi
    
    # SORTING LOGIC
    if [[ "$filename" == CarGuys_*.pdf ]]; then
        dest_dir="$SHARED_DIR"
        dest_name="Car Guys - Shared"
    else
        dest_dir="$PRIVATE_DIR"
        dest_name="Private Customers"
    fi
    
    # Handle duplicates
    if [ -f "$dest_dir/$filename" ]; then
        timestamp=$(date '+%Y%m%d_%H%M%S')
        name_no_ext="${filename%.pdf}"
        filename="${name_no_ext}_${timestamp}.pdf"
    fi
    
    # Move file
    if mv "$pdf_path" "$dest_dir/$filename" 2>/dev/null; then
        log_message "MOVED: $filename → $dest_name"
    else
        log_message "ERROR: Failed to move $filename"
    fi
done
