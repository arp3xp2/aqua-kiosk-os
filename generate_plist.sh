#!/bin/bash

# Generate plist files from config.sh
# This script creates the LaunchDaemon plist files with correct paths

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Function to generate Chrome monitor plist
generate_chrome_plist() {
    cat > "$SCRIPT_DIR/com.kiosk.chrome.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.kiosk.chrome</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>$KIOSK_HOME/kiosk_monitor.sh</string>
    </array>
    
    <key>RunAtLoad</key>
    <true/>
    
    <key>KeepAlive</key>
    <true/>
    
    <key>UserName</key>
    <string>$KIOSK_USER</string>
    
    <key>GroupName</key>
    <string>staff</string>
    
    <key>StandardOutPath</key>
    <string>$MONITOR_LOG</string>
    
    <key>StandardErrorPath</key>
    <string>$MONITOR_LOG</string>
    
    <key>EnvironmentVariables</key>
    <dict>
        <key>DISPLAY</key>
        <string>:0</string>
        <key>HOME</key>
        <string>$KIOSK_HOME</string>
    </dict>
    
    <key>ExitTimeOut</key>
    <integer>30</integer>
</dict>
</plist>
EOF
}


# Generate plist file
echo "Generating plist file from config.sh..."
generate_chrome_plist

echo "Generated:"
echo "  - com.kiosk.chrome.plist (Chrome monitor daemon)"
echo ""
echo "This file uses the following config values:"
echo "  - KIOSK_USER: $KIOSK_USER"
echo "  - KIOSK_HOME: $KIOSK_HOME"
echo "  - MONITOR_LOG: $MONITOR_LOG"