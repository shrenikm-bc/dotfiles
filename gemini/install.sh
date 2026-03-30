#!/bin/bash

# --- 1. Setup ---
# Resolve the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# NEW: Source is the .gemini subdirectory
SRC_DIR="$SCRIPT_DIR/.gemini"
DEST_DIR="$HOME/.gemini"

# --- 2. Validation ---
# Ensure the source .gemini folder actually exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Source directory not found at $SRC_DIR"
    exit 1
fi

# Create destination if it doesn't exist
if [ ! -d "$DEST_DIR" ]; then
    echo "Creating directory: $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

echo "Syncing from $SRC_DIR to $DEST_DIR..."

# --- 3. The Loop ---
# Loop through visible (*) and hidden (.*) files inside the source
for source_path in "$SRC_DIR"/* "$SRC_DIR"/.*; do
    
    filename=$(basename "$source_path")

    # --- SAFETY FILTERS ---
    # 1. Ignore '.' (current dir) and '..' (parent dir)
    if [[ "$filename" == "." || "$filename" == ".." ]]; then
        continue
    fi
    
    # 2. Check if the file actually exists
    if [ ! -e "$source_path" ]; then
        continue
    fi

    # --- EXCLUSION LIST ---
    # Keep generic system exclusions just in case.
    case "$filename" in
        ".git" | ".gitignore")
            continue
            ;;
    esac

    target_path="$DEST_DIR/$filename"

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        echo "Skipping: $filename (Target already exists)"
    else
        ln -s "$source_path" "$target_path"
        echo "Linked:   $filename"
    fi
done

echo "---"
echo "Done."
