#! /bin/bash

create_env_example() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: dotenvex <path-to-env-file>"
        return 1
    fi

    local ENV_FILE="$1"
    local ENV_EXAMPLE_FILE="${ENV_FILE}.example"

    awk -F '=' '/=/ {
        if (tolower($1) ~ /(key|token|secret|password)/) {
            print $1 "=REDACTED"
        } else {
            print $1 "=" $2
        }
    } ! /=/ { print }' "$ENV_FILE" > "$ENV_EXAMPLE_FILE"
    echo "Example environment file created: $ENV_EXAMPLE_FILE"
}

alias dotenvex="create_env_example"

cnote () {
    local input="$1"
    local filename="$(date +"%Y%m%d")-$input.md"
    local filedir="$HOME/repos/cyber-epistemics/website/site/content/blog"
    local filepath="$filedir/$filename"
    local msg="---
author: \"Will Wright\"
title: \"${input}\"
date: $(date +%Y-%m-%dT%H:%M:%S-07:00)
# description: \"${input}\"
tags: [\"blog\", \"project\", \"static\", \"tags\"] #include full list to trim from
categories: [\"cnote auto-generated\", \"blogging\"]
series: [\"cnote auto-generated\"]
aliases: [\"${input}\"]
ShowToc: true
TocOpen: false
draft: true
---

*intro*

## first section

*content*

## references

- [ref 1]()
"
    echo "$msg"
    if test -e "$filepath"; then
        echo "...file exists; not overwritten"
        cursor "$filepath"
    else
        touch "$filepath"
        echo "$msg" >> "$filepath"
        cursor "$filepath"
    fi
}

aisay() {
    sgpt --no-cache "$*" | tee >(say)
}

# Unrar TV episodes into organized folders
# Usage: unrar_tv [start_directory] [keyword] [output_directory]
# Extracts RAR files containing the specified keyword into organized folders
# Example: unrar_tv /path/to/files "Watchmen.S01E" output-dir
unrar_tv() {
    # Default values
    local start_dir="${1:-.}"  # Use current directory if not specified
    local keyword="${2:-}"     # No default keyword
    local output_dir="${3:-unrar-output}"

    # Check for unrar
    if ! command -v unrar &> /dev/null; then
        echo "[ERROR] unrar is not installed" >&2
        return 1
    fi

    # Create output directory
    mkdir -p "$output_dir" || { echo "[ERROR] Failed to create output directory" >&2; return 1; }

    echo "[INFO] Starting extraction process..."
    echo "[INFO] Source directory: $start_dir"
    echo "[INFO] Keyword: ${keyword:-<none>}"
    echo "[INFO] Output directory: $output_dir"

    # Process RAR files
    find "$start_dir" -type f -name '*.rar' | while read -r rar_file; do
        local dir_path=$(dirname "$rar_file")

        # If keyword is provided, check if path contains it
        if [[ -z "$keyword" ]] || [[ "$dir_path" == *"$keyword"* ]]; then
            echo "[INFO] Processing: $rar_file"

            local base_name=$(basename "$rar_file" .rar)
            local extraction_path="$output_dir/$base_name"

            mkdir -p "$extraction_path"
            if unrar x "$rar_file" "$extraction_path/"; then
                echo "[INFO] Successfully extracted: $base_name"
            else
                echo "[ERROR] Failed to extract: $rar_file" >&2
            fi
        fi
    done

    echo "[INFO] Extraction process complete"
    echo "followup commands"
    echo "mv **/*.mkv ."
    echo "rm -r */"
}
