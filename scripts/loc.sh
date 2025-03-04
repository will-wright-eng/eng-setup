#!/bin/bash
#
# loc_counter.sh - Count lines of code by file extension in a directory
#
# Usage:
#   ./loc_counter.sh [directory_path]
#
# If no directory_path is provided, it defaults to the current directory.

set -e

# Function to check if a file is likely binary
is_binary() {
  local file="$1"
  if file "$file" | grep -q "text"; then
    return 1  # Not binary (text file)
  else
    return 0  # Binary file
  fi
}

# Function to count lines in a file
count_lines() {
  local file="$1"
  wc -l < "$file"
}

# Function to format results
print_results() {
  # Calculate column widths
  local max_ext_len=9  # Length of "Extension"
  local max_files_len=5  # Length of "Files"
  local max_lines_len=5  # Length of "Lines"
  
  # Find maximum lengths
  while IFS="|" read -r ext files lines; do
    if [ ${#ext} -gt $max_ext_len ]; then
      max_ext_len=${#ext}
    fi
    if [ ${#files} -gt $max_files_len ]; then
      max_files_len=${#files}
    fi
    if [ ${#lines} -gt $max_lines_len ]; then
      max_lines_len=${#lines}
    fi
  done < "$1"
  
  # Print header
  printf "%-*s  %*s  %*s  %5s\n" $max_ext_len "Extension" $max_files_len "Files" $max_lines_len "Lines" "%"
  printf "%-*s  %*s  %*s  %5s\n" $max_ext_len "$(printf '%0.s-' $(seq 1 $max_ext_len))" \
                               $max_files_len "$(printf '%0.s-' $(seq 1 $max_files_len))" \
                               $max_lines_len "$(printf '%0.s-' $(seq 1 $max_lines_len))" \
                               "-----"
  
  # Print each row
  local total_lines=0
  while IFS="|" read -r ext files lines; do
    total_lines=$((total_lines + lines))
    echo "$ext|$files|$lines"
  done < "$1" > "$1.tmp"
  
  # Print sorted by line count (descending)
  sort -t"|" -k3,3nr "$1.tmp" | while IFS="|" read -r ext files lines; do
    if [ $total_lines -eq 0 ]; then
      percent=0
    else
      percent=$(echo "scale=1; ($lines * 100) / $total_lines" | bc)
    fi
    printf "%-*s  %*s  %*s  %5.1f\n" $max_ext_len "$ext" $max_files_len "$files" $max_lines_len "$lines" "$percent"
  done
  
  # Print divider
  printf "%-*s  %*s  %*s  %5s\n" $max_ext_len "$(printf '%0.s-' $(seq 1 $max_ext_len))" \
                               $max_files_len "$(printf '%0.s-' $(seq 1 $max_files_len))" \
                               $max_lines_len "$(printf '%0.s-' $(seq 1 $max_lines_len))" \
                               "-----"
  
  # Print total
  printf "%-*s  %*s  %*s  %5.1f\n" $max_ext_len "Total" \
                                  $max_files_len "$(wc -l < "$1")" \
                                  $max_lines_len "$total_lines" \
                                  "100.0"
                                  
  # Clean up temporary files
  rm -f "$1.tmp"
}

# Main script starts here

# Get directory from command line args or use current directory
if [ $# -gt 0 ]; then
  directory="$1"
  if [ ! -d "$directory" ]; then
    echo "Error: $directory is not a valid directory" >&2
    exit 1
  fi
else
  directory="."
fi

echo "Counting lines of code in $(realpath "$directory")..."

# Create temporary files
temp_file=$(mktemp)
results_file=$(mktemp)

# Find all files and process them
find "$directory" -type f -not -path "*/\.*" | while read -r file; do
  # Skip files we can't read
  if [ ! -r "$file" ]; then
    continue
  fi
  
  # Skip binary files
  if is_binary "$file"; then
    ext="[binary]"
    echo "$ext|1|0" >> "$temp_file"
    continue
  fi
  
  # Get file extension
  filename=$(basename "$file")
  if [[ "$filename" == *.* ]]; then
    ext=".${filename##*.}"
    ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
  else
    ext="[no extension]"
  fi
  
  # Count lines
  line_count=$(count_lines "$file")
  
  # Save result
  echo "$ext|1|$line_count" >> "$temp_file"
done

# Aggregate results by extension
if [ -s "$temp_file" ]; then
  sort "$temp_file" | awk -F"|" '
  {
    extensions[$1, "files"] += $2;
    extensions[$1, "lines"] += $3;
  }
  END {
    for (ext in extensions) {
      split(ext, parts, SUBSEP);
      if (parts[2] == "files") {
        printf "%s|%d|%d\n", parts[1], extensions[parts[1], "files"], extensions[parts[1], "lines"];
      }
    }
  }' | sort -u > "$results_file"
  
  # Print formatted results
  print_results "$results_file"
else
  echo "No files found."
fi

# Clean up
rm -f "$temp_file" "$results_file"
