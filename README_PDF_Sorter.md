# JW Reports PDF Auto-Sorter

Automatically sorts PDFs from Downloads to Google Drive folders based on filename.

## Folder Structure

```
Google Drive/
└── JW Reports/
    ├── Private Customers/     (your private files)
    └── Car Guys - Shared/      (files to share with others)
```

## How It Works

### Auto-Detect Keywords
PDFs are automatically sorted based on filename:

**→ Car Guys - Shared:**
- Contains "car guys"
- Contains "rego"
- Contains "shared"
- Contains "dealer"
- Contains "fleet"

**→ Private Customers:**
- Everything else (default)

## Usage Options

### Option 1: Double-Click Sort (Easiest)
1. Double-click `quick_sort.command`
2. Sorts all PDFs in Downloads

### Option 2: Sort Single File
```bash
./sort_single_pdf.sh "/path/to/file.pdf"
```

Force a specific folder:
```bash
./sort_single_pdf.sh "/path/to/file.pdf" shared
./sort_single_pdf.sh "/path/to/file.pdf" private
```

### Option 3: Auto-Monitor (Background)
```bash
./monitor_downloads.sh
```
Runs continuously and sorts PDFs as they download.

### Option 4: Sort All PDFs
```bash
./sort_pdfs.sh
```

## Examples

| Filename | Destination |
|----------|-------------|
| `1IWP463_Ford_Territory.pdf` | Private Customers |
| `car guys_report_may.pdf` | Car Guys - Shared |
| `rego_check_12345.pdf` | Car Guys - Shared |
| `shared_inspection.pdf` | Car Guys - Shared |

## Setup Checklist

1. ✅ Install Google Drive for Desktop
2. ✅ Sign in to Google Drive
3. ✅ Choose "Mirror files" (recommended)
4. ✅ Run `quick_sort.command` to test

## Access From Any Device

**iPhone:**
1. Open Files app
2. Tap Browse
3. Select Google Drive
4. Navigate to JW Reports folder

**Any computer:**
- Files sync automatically via Google Drive

## Log File

Check `pdf_sort_log.txt` to see what was moved and when.
