#!/bin/bash

# --- Configuration ---
REPO_URL="https://github.com/your-username/UltraPrompt.git"
TARGET_DIR="UltraPrompt"

# --- 1. Sync Repository ---
if [ ! -d "$TARGET_DIR" ]; then
    echo "📂 Directory $TARGET_DIR not found. Cloning..."
    git clone "$REPO_URL" "$TARGET_DIR"
else
    echo "🔄 Directory $TARGET_DIR found. Checking for updates..."
    # Move into the dir, pull, and come back
    (cd "$TARGET_DIR" && git pull)
fi

# --- 2. Validate .md files ---
# Checks if there is at least one .md file in the folder
if ! ls "$TARGET_DIR"/*.md >/dev/null 2>&1; then
    echo "❌ Error: No .md files found in $TARGET_DIR."
    exit 1
fi

# --- 3. Handle CLI Flags ---
# Usage: ./script.sh -p prompt.md -q "My question" -f "file1.go,file2.go"
while getopts "p:q:f:" opt; do
  case $opt in
    p) PROMPT_FILE="$optarg" ;;
    q) USER_QUERY="$optarg" ;;
    f) INCLUDE_FILES="$optarg" ;;
    *) echo "Usage: $0 -p prompt_file -q query -f 'file1,file2'"; exit 1 ;;
  esac
done

# Check required flags
if [[ -z "$PROMPT_FILE" || -z "$USER_QUERY" ]]; then
    echo "❌ Error: -p (prompt) and -q (query) are required."
    exit 1
fi

# --- 4. Generate Output ---
echo "--- START OF PROMPT ---"

# Append the Prompt File (from the synced directory)
if [ -f "$TARGET_DIR/$PROMPT_FILE" ]; then
    cat "$TARGET_DIR/$PROMPT_FILE"
else
    echo "Error: Prompt file $PROMPT_FILE not found in $TARGET_DIR"
    exit 1
fi

echo -e "\n\n### USER QUERY ###"
echo "$USER_QUERY"

# Append included files
if [[ -n "$INCLUDE_FILES" ]]; then
    # Convert comma-separated string to array
    IFS=',' read -ra ADDR <<< "$INCLUDE_FILES"
    for file in "${ADDR[@]}"; do
        file=$(echo "$file" | xargs) # trim whitespace
        if [ -f "$file" ]; then
            echo -e "\n\n### FILE: $file ###"
            cat "$file"
        else
            echo -e "\n\n⚠️ Warning: File $file not found."
        fi
    done
fi

echo -e "\n--- END OF PROMPT ---"