#!/bin/bash

# Script to download CRX files for browser extensions
# Based on the extension IDs from browser-extensions.py

set -euo pipefail

# Extension IDs with their names (from browser-extensions.py)
declare -A EXTENSIONS=(
    ["mghlhfaogogibkliffpabpjoekdnenha"]="tabs-to-clipboard"
    ["eimadpbcbfnmbkopoojfekhnkhdbieeh"]="dark-reader"
    ["nlnkcinjjeoojlhdiedbbolilahmnldj"]="tab-sorter"
    ["fmkadmapgofadopljbjfkapdkoienihi"]="react-developer-tools"
    ["elglafmpaeiffddlclplkhgkplbdccca"]="wayback-machine-lookup"
    ["gppongmhjkpfnbhagpmjfkannfbllamg"]="wappalyzer"
    ["nngceckbapebfimnlniiiahkandclblb"]="bitwarden"
)

# Output directory (defaults to current directory, can be overridden)
REPO_ROOT=$(git rev-parse --show-toplevel)
OUTPUT_DIR="${REPO_ROOT}/extensions"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Function to download a CRX file
download_crx() {
    local id="$1"
    local name="$2"
    local filename="${OUTPUT_DIR}/${name}.crx"
    # Updated URL format that works with Chrome Web Store API
    # Includes prodversion, acceptformat, and installsource parameters
    local url="https://clients2.google.com/service/update2/crx?response=redirect&prodversion=120.0&acceptformat=crx2,crx3&x=id%3D${id}%26installsource%3Dondemand%26uc"

    echo "Downloading ${name} (${id})..."

    if curl -L -f -s -o "$filename" "$url"; then
        # Verify the file is not empty
        if [ ! -s "$filename" ]; then
            echo "✗ Downloaded file is empty: ${filename}"
            rm -f "$filename"
            return 1
        fi
        echo "✓ Successfully downloaded: ${filename}"
    else
        echo "✗ Failed to download ${name} (${id})"
        return 1
    fi
}

# Download all extensions
echo "Downloading browser extension CRX files..."
echo "Output directory: ${OUTPUT_DIR}"
echo ""

failed=0
for id in "${!EXTENSIONS[@]}"; do
    name="${EXTENSIONS[$id]}"
    if ! download_crx "$id" "$name"; then
        ((failed++)) || true
    fi
done

echo ""
if [ $failed -eq 0 ]; then
    echo "✓ All extensions downloaded successfully!"
    exit 0
else
    echo "✗ Failed to download $failed extension(s)"
    exit 1
fi
