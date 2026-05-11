#!/bin/bash

# Monitor Downloads folder and auto-sort new PDFs
# Run this in the background to watch for new files

DOWNLOADS_DIR="/Users/jamiewatson 1/Downloads"
LOG_FILE="/Users/jamiewatson 1/CascadeProjects/JwReportAP/pdf_sort_log.txt"
SCRIPT_DIR="/Users/jamiewatson 1/CascadeProjects/JwReportAP"

echo "🔍 Monitoring Downloads for new PDFs..."
echo "Press Ctrl+C to stop"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Monitor started" >> "$LOG_FILE"

# Use fswatch if available, otherwise use polling
if command -v fswatch &> /dev/null; then
    # fswatch is installed - use efficient file watching
    fswatch -o "$DOWNLOADS_DIR" | while read f; do
        # Check for new PDFs
        find "$DOWNLOADS_DIR" -maxdepth 1 -name "*.pdf" -type f -newer "$LOG_FILE" 2>/dev/null | while read pdf; do
            if [ -f "$pdf" ]; then
                echo "📄 New PDF detected: $(basename "$pdf")"
                "$SCRIPT_DIR/sort_single_pdf.sh" "$pdf"
                # Show notification
                osascript -e 'display notification "PDF sorted to Google Drive" with title "JW Reports"' 2>/dev/null
            fi
        done
    done
else
    # Polling method (works without fswatch)
    echo "Note: Install fswatch for better performance: brew install fswatch"
    
    while true; do
        # Find PDFs modified in last 10 seconds
        find "$DOWNLOADS_DIR" -maxdepth 1 -name "*.pdf" -type f -mmin -0.2 2>/dev/null | while read pdf; do
            if [ -f "$pdf" ]; then
                # Check if already processed (file moved away)
                if [ -f "$pdf" ]; then
                    echo "📄 New PDF detected: $(basename "$pdf")"
                    "$SCRIPT_DIR/sort_single_pdf.sh" "$pdf"
                    osascript -e 'display notification "PDF sorted to Google Drive" with title "JW Reports"' 2>/dev/null
                fi
            fi
        done
        sleep 5
    done
fi
