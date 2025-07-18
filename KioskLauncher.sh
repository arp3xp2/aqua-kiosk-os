#!/bin/bash

# Simple Kiosk Launcher for Snow Leopard
# Launches Chrome in kiosk mode

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Launch Chrome in kiosk mode with security flags from config
"$CHROME_PATH" "${CHROME_FLAGS[@]}"

# Configuration is now handled in config.sh
# Edit config.sh to change the target URL, Chrome flags, and other settings
