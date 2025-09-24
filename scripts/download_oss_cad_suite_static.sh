#!/bin/bash

set -e

# --- Change to script's directory ---
# This ensures all relative paths are resolved from the script's actual location.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR" || { echo "Error: Failed to change to script directory: $SCRIPT_DIR"; exit 1; }
echo "Changed current directory to: $SCRIPT_DIR"

# Configuration
DOWNLOAD_DIR="./oss_cad_suite_downloads"
RELEASE_DATE="2025-09-16" # The specific release date from your URLs

# Base URL for the release assets
BASE_URL="https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${RELEASE_DATE}"

# --- Determine OS and Architecture ---
KERNEL_NAME=$(uname -s)
MACHINE_ARCH=$(uname -m)
TARGET_OS_ARCH=""
FILE_EXTENSION=""

echo "Detecting OS and Architecture..."

case "${KERNEL_NAME}" in
    Linux*)
        if [[ "${MACHINE_ARCH}" == "x86_64" ]]; then
            TARGET_OS_ARCH="linux-x64"
            FILE_EXTENSION="tgz"
        elif [[ "${MACHINE_ARCH}" == "aarch64" ]]; then
            TARGET_OS_ARCH="linux-arm64"
            FILE_EXTENSION="tgz"
        else
            echo "Error: Unsupported Linux architecture: ${MACHINE_ARCH}" >&2
            exit 1
        fi
        ;;
    Darwin*)
        if [[ "${MACHINE_ARCH}" == "x86_64" ]]; then
            TARGET_OS_ARCH="darwin-x64"
            FILE_EXTENSION="tgz" 
        elif [[ "${MACHINE_ARCH}" == "arm64" ]]; then
            TARGET_OS_ARCH="darwin-arm64"
            FILE_EXTENSION="tgz" 
        else
            echo "Error: Unsupported macOS architecture: ${MACHINE_ARCH}" >&2
            exit 1
        fi
        ;;
    MINGW*|CYGWIN*|MSYS*) 
        # Git Bash on Windows, or other similar environments
        if [[ "${MACHINE_ARCH}" == "x86_64" ]]; then
            TARGET_OS_ARCH="windows-x64"
            FILE_EXTENSION="exe" # Windows executable
        else
            echo "Error: Unsupported Windows architecture: ${MACHINE_ARCH}" >&2
            exit 1
        fi
        ;;
    *)
        echo "Error: Unsupported operating system: ${KERNEL_NAME}" >&2
        exit 1
        ;;
esac

if [ -z "$TARGET_OS_ARCH" ]; then
    echo "Error: Could not determine target OS/Architecture for download." >&2
    exit 1
fi

echo "Identified target: ${TARGET_OS_ARCH}"

# --- Construct the full download URL ---
# Note: The date in the filename is often `YYYYMMDD` while the tag is `YYYY-MM-DD`
FILENAME_DATE=$(echo "${RELEASE_DATE}" | sed 's/-//g') # Convert 2025-09-16 to 20250916
ASSET_FILENAME="oss-cad-suite-${TARGET_OS_ARCH}-${FILENAME_DATE}.${FILE_EXTENSION}"
DOWNLOAD_URL="${BASE_URL}/${ASSET_FILENAME}"

echo "Constructed download URL: ${DOWNLOAD_URL}"

# --- Download the file ---
mkdir -p "$DOWNLOAD_DIR" || { echo "Error: Failed to create download directory '$DOWNLOAD_DIR'." >&2; exit 1; }

OUTPUT_PATH="${DOWNLOAD_DIR}/${ASSET_FILENAME}"

echo "Downloading '${ASSET_FILENAME}' to '$DOWNLOAD_DIR'..."

# Use curl to download the file. -L follows redirects.
command -v curl >/dev/null 2>&1 || { echo >&2 "Error: curl is required but not installed. Aborting."; exit 1; }

if [ -f "$OUTPUT_PATH" ]; then
    echo "File '$ASSET_FILENAME' already exists in '$DOWNLOAD_DIR'."
    # Optionally, you could add a robust check here if the file is *complete*
    # For now, we'll just check existence and let curl -C - handle resumption
    # if it's an incomplete file.
    echo "Attempting to resume download or verify integrity..."
    curl -L -C - -o "$OUTPUT_PATH" "$DOWNLOAD_URL"
else
    echo "Downloading '${ASSET_FILENAME}' to '$DOWNLOAD_DIR'..."
    curl -L -o "$OUTPUT_PATH" "$DOWNLOAD_URL"
fi

if [ $? -eq 0 ]; then
    echo "Successfully downloaded to: $OUTPUT_PATH"
else
    echo "Error: Failed to download asset from '${DOWNLOAD_URL}'." >&2
    rm -f "$OUTPUT_PATH" # Clean up partial download
    exit 1
fi

echo "Download complete."
