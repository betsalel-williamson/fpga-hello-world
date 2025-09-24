#!/bin/bash

set -e

# --- Enforce non-root execution ---
if [ "$EUID" -eq 0 ]; then
  echo "Error: This script should not be run as root or with sudo." >&2
  echo "Please run it as a regular user to install OSS CAD Suite in your home directory." >&2
  exit 1
fi

# --- Configuration ---
INSTALL_BASE_DIR="$HOME/.local"
INSTALL_DIR="$INSTALL_BASE_DIR/oss-cad-suite"

# --- MODIFIED: Directly set PATH ---
ENV_SETUP_LINE="export PATH=\"$INSTALL_DIR/bin:\$PATH\""
FISH_ENV_SETUP_LINE="set -gx PATH \"$INSTALL_DIR/bin\" \$PATH" # Fish shell syntax


# --- Variables for options ---
FORCE_INSTALL=false
ARCHIVE_FILE=""

# --- Functions ---

# Function to check if a command exists
command_exists () {
  type "$1" &> /dev/null ;
}

# Function to display usage
display_usage() {
    echo "Usage: $0 [--force|-F] <path_to_oss_cad_suite_archive.tar>"
    echo ""
    echo "  --force, -F  : Force re-installation. Deletes '$INSTALL_DIR' if it exists"
    echo "                 before extraction, bypassing the idempotent check."
    echo ""
    echo "Example: $0 ~/Downloads/oss-cad-suite-darwin-arm64-20250916.tgz"
    echo "Example: $0 --force ~/Downloads/oss-cad-suite-linux-x64-20250916.tgz"
    exit 1
}


# --- Argument Parsing ---
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -F|--force)
            FORCE_INSTALL=true
            shift
            ;;
        -h|--help)
            display_usage
            ;;
        *)
            if [ -z "$ARCHIVE_FILE" ]; then
                ARCHIVE_FILE="$1"
            else
                echo "Error: Too many arguments provided. Unexpected argument: '$1'" >&2
                display_usage
            fi
            shift
            ;;
    esac
done

# --- Main Script ---

echo "--- OSS CAD Suite Installation Script ---"

# 1. Validate archive file path
if [ -z "$ARCHIVE_FILE" ]; then
    echo "Error: No archive file path provided." >&2
    display_usage
fi

# IMPORTANT: Resolve ARCHIVE_FILE to an absolute path *after* changing directory,
# but *before* other operations, in case it was a relative path.
# This ensures 'tar' finds it correctly.
ARCHIVE_FILE="$(realpath "$ARCHIVE_FILE")"
if [ $? -ne 0 ]; then
    echo "Error: Could not resolve absolute path for archive file '$ARCHIVE_FILE'." >&2
    exit 1
fi


echo "Target installation directory: $INSTALL_DIR"
echo "Archive file: $ARCHIVE_FILE"
if "$FORCE_INSTALL"; then
    echo "Force mode enabled: Existing '$INSTALL_DIR' will be deleted if found."
fi

# 2. Check for archive file existence
if [ ! -f "$ARCHIVE_FILE" ]; then
    echo "Error: Archive file '$ARCHIVE_FILE' not found." >&2
    echo "Please ensure the path is correct and the file exists, then re-run." >&2
    exit 1
fi

# 3. Remove macOS quarantine attribute (if applicable)
if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Removing macOS quarantine attribute from '$ARCHIVE_FILE'..."
    if xattr -d com.apple.quarantine "$ARCHIVE_FILE" 2>/dev/null; then
        echo "Quarantine attribute removed successfully."
    else
        echo "Could not remove quarantine attribute (it might not be present or an error occurred)."
    fi
fi

# 4. Handle installation directory based on --force option
if "$FORCE_INSTALL" && [ -d "$INSTALL_DIR" ]; then
    echo "Force mode: Deleting existing installation directory '$INSTALL_DIR'..."
    rm -rf "$INSTALL_DIR" || { echo "Error: Could not delete existing directory $INSTALL_DIR"; exit 1; }
fi

echo "Creating installation directory '$INSTALL_DIR' (if it doesn't exist)..."
mkdir -p "$INSTALL_DIR" || { echo "Error: Could not create directory $INSTALL_DIR"; exit 1; }


# 5. Extract the archive
# Note: The idempotent check now relies on the directory existing and containing something,
# as the 'environment' file will no longer be the definitive marker if we don't use it.
# However, a 'bin' directory is a good general indicator.
if ! "$FORCE_INSTALL" && [ -d "$INSTALL_DIR/bin" ]; then
    echo "OSS CAD Suite appears to be already extracted to '$INSTALL_DIR'."
    echo "Skipping extraction. Use --force to re-extract."
else
    echo "Extracting '$ARCHIVE_FILE' to '$INSTALL_DIR'..."
    # --strip-components=1 is crucial to avoid a nested directory like ~/.local/oss-cad-suite/oss-cad-suite/
    if tar -xf "$ARCHIVE_FILE" -C "$INSTALL_DIR" --strip-components=1; then
        echo "Extraction complete."
    else
        echo "Error: Failed to extract '$ARCHIVE_FILE'." >&2
        echo "Please check the archive file for corruption or disk space." >&2
        rm -rf "$INSTALL_DIR" 2>/dev/null # Clean up potentially corrupted install
        exit 1
    fi
fi

# 6. Configure shell environment
echo "Configuring shell environment (adding '$INSTALL_DIR/bin' to PATH)..."

# Determine the shell and appropriate RC file
SHELL_NAME=$(basename "$SHELL")
RC_FILE=""
CURRENT_ENV_LINE_TO_ADD=""

if [[ "$SHELL_NAME" == "bash" ]]; then
    RC_FILE="$HOME/.bashrc"
    CURRENT_ENV_LINE_TO_ADD="$ENV_SETUP_LINE"
elif [[ "$SHELL_NAME" == "zsh" ]]; then
    RC_FILE="$HOME/.zshrc"
    CURRENT_ENV_LINE_TO_ADD="$ENV_SETUP_LINE"
elif [[ "$SHELL_NAME" == "fish" ]]; then
    RC_FILE="$HOME/.config/fish/config.fish"
    CURRENT_ENV_LINE_TO_ADD="$FISH_ENV_SETUP_LINE"
else
    echo "Warning: Unsupported shell '$SHELL_NAME'. Please manually add the following line to your shell's config file:" >&2
    echo "  $ENV_SETUP_LINE" >&2
    RC_FILE="" # Prevent further actions
fi

if [ -n "$RC_FILE" ]; then
    if [ ! -f "$RC_FILE" ]; then
        echo "Creating '$RC_FILE'..."
        touch "$RC_FILE" || { echo "Error: Could not create $RC_FILE"; exit 1; }
    fi

    # Check for *any* previous environment setup line for this installation,
    # then add the *new* specific one.
    # This grep checks for lines that would source the old 'environment' file OR the new PATH export.
    if grep -qF "oss-cad-suite/environment" "$RC_FILE" || grep -qF "$INSTALL_DIR/bin" "$RC_FILE"; then
        echo "An existing OSS CAD Suite environment setup line was found in '$RC_FILE'."
        echo "Please review and update '$RC_FILE' manually if you changed the setup method."
        echo "The recommended line is: $CURRENT_ENV_LINE_TO_ADD"
    else
        echo "Adding environment setup line to '$RC_FILE'..."
        echo "" >> "$RC_FILE" # Add a newline for readability if file doesn't end with one
        echo "# OSS CAD Suite PATH setup" >> "$RC_FILE"
        echo "$CURRENT_ENV_LINE_TO_ADD" >> "$RC_FILE"
        echo "Line added. You may need to open a new terminal or run 'source $RC_FILE' for changes to take effect."
    fi
fi

echo "--- Installation Complete ---"
echo "To verify, open a new terminal or run 'source $RC_FILE' (for $SHELL_NAME) and try running: yosys -h"