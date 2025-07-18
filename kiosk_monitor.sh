#!/bin/bash

# Kiosk Monitor Script for Snow Leopard
# Monitors Chrome kiosk process and restarts via KioskLauncher.app if needed

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Use config values
CHECK_INTERVAL="$MONITOR_CHECK_INTERVAL"
LOG_FILE="$MONITOR_LOG"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log_message "Kiosk monitor started"

# Main monitoring loop
while true; do
    # Check if Chrome is running in kiosk mode
    # Use ps instead of pgrep for better cross-user visibility
    if ! ps aux | grep -i "chrome" | grep -i "\-\-kiosk" | grep -v grep > /dev/null 2>&1; then
        log_message "Chrome kiosk not running, launching KioskLauncher.app"
        
        # Launch the Automator app
        open -a "$KIOSK_APP" 2>&1 | tee -a "$LOG_FILE"
        
        # Give Chrome time to start before checking again
        sleep $MONITOR_LAUNCH_DELAY
    fi
    
    # Regular check interval
    sleep $CHECK_INTERVAL
done