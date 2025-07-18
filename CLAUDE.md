# Snow Leopard Kiosk System

## Architecture
- **System Level**: Parental Controls restrict user to Chrome only + Simple Finder
- **Application Level**: Chrome kiosk mode with security flags
- **Monitoring**: kiosk_monitor.sh daemon checks Chrome every 10 seconds

## Key Components
- **`quick_setup.sh`**: Main automated installer (run from admin account, NOT sudo)
- **`KioskLauncher.sh`**: Chrome launcher script (copied to user directory)
- **`kiosk_monitor.sh`**: Monitor daemon that launches KioskLauncher.app for faster startup
- **`DefaultKeyBinding.dict`**: Key binding customizations (planned feature)
- **`com.kiosk.chrome.plist`**: LaunchDaemon for system-level monitoring

## Configuration (config.sh)
- **KIOSK_URL**: Target website URL
- **ADMIN_PASSWORD**: Admin exit password (default: "changeme123" - CHANGE THIS!)
- **KIOSK_USER**: Kiosk username (default: "kiosk")
- **QUIZ_DOMAIN**: Target website domain for security checks

## Essential Commands
```bash
# Setup
./quick_setup.sh

# Test Chrome manually
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --kiosk --app=http://wikipedia.org

# Test kiosk launcher
bash /Users/[kiosk_user]/KioskLauncher.sh

# Monitor logs
tail -f /var/log/kiosk_monitor.log

# Daemon management
sudo launchctl load /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo launchctl unload /Library/LaunchDaemons/com.kiosk.chrome.plist

# Auto-login configuration
sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser -string "[kiosk_user]"
```

## System Requirements
- **Mac OS X 10.6 Snow Leopard**
- **Chrome 49.0.2623.112** (specific version for Snow Leopard)
- **Admin account** for setup and emergency access
- **Kiosk user account** (created automatically if needed)

## Security & Exit
- **Exit kiosk**: Cmd+Shift+Q+Q + admin password
- **Manual step**: Parental Controls must be configured via System Preferences after automated setup
- **File locations**: Runtime files in `/Users/[kiosk_user]/`, system daemon in `/Library/LaunchDaemons/`, logs in `/var/log/kiosk_monitor.log`