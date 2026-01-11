#!/bin/bash

# Script to extract CRX files (handles both CRX2 and CRX3 formats)

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <crx_file> <output_dir>"
    exit 1
fi

CRX_FILE="$1"
OUTPUT_DIR="$2"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="${SCRIPT_DIR}/extract-crx.py"

# Use Python script to extract CRX files
python3 "$PYTHON_SCRIPT" "$CRX_FILE" "$OUTPUT_DIR"
