#!/bin/bash

# JW Reports PDF Sorter
# Automatically sorts PDFs from Downloads to appropriate Google Drive folders
# Trigger words: "car guys", "rego", "shared" -> Car Guys - Shared folder
# Everything else -> Private Customers folder

DOWNLOADS_DIR="/Users/jamiewatson 1/Downloads"
PRIVATE_DIR="/Users/jamiewatson 1/Google Drive/JW Reports/Private Customers"
SHARED_DIR="/Users/jamiewatson 1/Google Drive/JW Reports/Car Guys - Shared"
LOG_FILE="/Users/jamiewatson 1/CascadeProjects/JwReportAP/pdf_sort_log.txt"

# Create directories if they don't exist
mkdir -p "$PRIVATE_DIR"
mkdir -p "$SHARED_DIR"

# Function to determine destination based on filename
determine_destination() {
    local filename="$1"
    local lowername=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    
    # Check for Car Guys indicators
    if [[ "$lowername" == *"car guys"* ]] || \
       [[ "$lowername" == *"rego"* ]] || \
       [[ "$lowername" == *"shared"* ]] || \
       [[ "$lowername" == *"dealer"* ]] || \
       [[ "$lowername" == *"fleet"* ]]; then
        echo "SHARED"
    else
        echo "PRIVATE"
    fi
}

# Log function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    echo "$1"
}

# Main processing
log_message "=== PDF Sort Started ==="

# Find all PDFs in Downloads
find "$DOWNLOADS_DIR" -maxdepth 1 -name "*.pdf" -type f | while read pdf_path; do
    filename=$(basename "$pdf_path")
    
    # Determine destination
    dest_type=$(determine_destination "$filename")
    
    if [ "$dest_type" == "SHARED" ]; then
        dest_dir="$SHARED_DIR"
        dest_name="Car Guys - Shared"
    else
        dest_dir="$PRIVATE_DIR"
        dest_name="Private Customers"
    fi
    
    # Check if file already exists in destination
    if [ -f "$dest_dir/$filename" ]; then
        # Add timestamp to filename
        timestamp=$(date '+%Y%m%d_%H%M%S')
        base_name="${filename%.pdf}"
        new_filename="${base_name}_${timestamp}.pdf"
        log_message "File exists, renaming: $filename -> $new_filename"
        filename="$new_filename"
    fi
    
    # Move the file
    if mv "$pdf_path" "$dest_dir/$filename"; then
        log_message "MOVED: $filename -> $dest_name"
    else
        log_message "ERROR: Failed to move $filename"
    fi
done

log_message "=== PDF Sort Complete ==="
log_message ""
