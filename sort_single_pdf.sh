#!/bin/bash

# Sort a single PDF file to the appropriate folder
# Usage: ./sort_single_pdf.sh "/path/to/file.pdf" [optional: force folder]
# Force folder options: "private" or "shared"

PRIVATE_DIR="/Users/jamiewatson 1/Google Drive/JW Reports/Private Customers"
SHARED_DIR="/Users/jamiewatson 1/Google Drive/JW Reports/Car Guys - Shared"
LOG_FILE="/Users/jamiewatson 1/CascadeProjects/JwReportAP/pdf_sort_log.txt"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <pdf_path> [private|shared]"
    echo "Example: $0 ~/Downloads/report.pdf shared"
    exit 1
fi

pdf_path="$1"
force_folder="${2:-}"

if [ ! -f "$pdf_path" ]; then
    echo "Error: File not found: $pdf_path"
    exit 1
fi

filename=$(basename "$pdf_path")
lowername=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

# Determine destination
if [ "$force_folder" == "shared" ]; then
    dest_dir="$SHARED_DIR"
    dest_name="Car Guys - Shared"
elif [ "$force_folder" == "private" ]; then
    dest_dir="$PRIVATE_DIR"
    dest_name="Private Customers"
else
    # Auto-detect based on filename
    if [[ "$lowername" == *"car guys"* ]] || \
       [[ "$lowername" == *"rego"* ]] || \
       [[ "$lowername" == *"shared"* ]] || \
       [[ "$lowername" == *"dealer"* ]] || \
       [[ "$lowername" == *"fleet"* ]]; then
        dest_dir="$SHARED_DIR"
        dest_name="Car Guys - Shared"
    else
        dest_dir="$PRIVATE_DIR"
        dest_name="Private Customers"
    fi
fi

# Create directories if needed
mkdir -p "$dest_dir"

# Handle duplicate filenames
if [ -f "$dest_dir/$filename" ]; then
    timestamp=$(date '+%Y%m%d_%H%M%S')
    base_name="${filename%.pdf}"
    filename="${base_name}_${timestamp}.pdf"
fi

# Move the file
if mv "$pdf_path" "$dest_dir/$filename"; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - MOVED: $filename -> $dest_name" >> "$LOG_FILE"
    echo "✓ Moved to: $dest_name/$filename"
    echo "✓ Full path: $dest_dir/$filename"
else
    echo "✗ Error: Failed to move file"
    exit 1
fi
