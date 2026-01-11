#!/usr/bin/env python3
"""
Script to extract CRX files (handles both CRX2 and CRX3 formats)
"""

import sys
import zipfile
import io
import os


def extract_crx(crx_path, output_dir):
    """Extract a CRX file to the specified output directory."""
    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    with open(crx_path, 'rb') as f:
        data = f.read()

        # Check if file is empty
        if len(data) == 0:
            raise ValueError("CRX file is empty (0 bytes)")

        # Read magic number
        if len(data) < 4:
            raise ValueError(f"File too small to be a CRX file ({len(data)} bytes)")

        magic = data[:4]

        if magic == b'Cr24':
            # CRX format - find ZIP file start
            # ZIP files start with "PK\x03\x04"
            zip_start = data.find(b'PK\x03\x04')
            if zip_start < 0:
                raise ValueError("Could not find ZIP data in CRX file (missing PK header)")

            # Extract from ZIP start position
            zip_data = data[zip_start:]
            try:
                with zipfile.ZipFile(io.BytesIO(zip_data), 'r') as z:
                    z.extractall(output_dir)
            except zipfile.BadZipFile as e:
                raise ValueError(f"Invalid ZIP file in CRX: {e}")
        else:
            # Might be a plain ZIP file
            try:
                with zipfile.ZipFile(io.BytesIO(data), 'r') as z:
                    z.extractall(output_dir)
            except zipfile.BadZipFile:
                # Check if it's HTML (common when download fails)
                if data.startswith(b'<'):
                    raise ValueError("Downloaded file appears to be HTML, not a CRX file (download may have failed)")
                raise ValueError(f"File is not a valid CRX or ZIP file (magic: {magic})")


def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <crx_file> <output_dir>", file=sys.stderr)
        sys.exit(1)

    crx_file = sys.argv[1]
    output_dir = sys.argv[2]

    if not os.path.exists(crx_file):
        print(f"Error: CRX file not found: {crx_file}", file=sys.stderr)
        sys.exit(1)

    try:
        extract_crx(crx_file, output_dir)
    except Exception as e:
        print(f"Error extracting CRX file: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
