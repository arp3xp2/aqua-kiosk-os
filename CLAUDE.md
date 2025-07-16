# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Snow Leopard Kiosk System** for Mac OS X 10.6 that creates a secure, production-ready kiosk environment using Chrome in fullscreen mode with system-level restrictions.

### Core Architecture

The system uses a two-layer security approach:
1. **System Level**: Parental Controls restrict user to Chrome only and Simple Finder
2. **Application Level**: Chrome kiosk mode with security flags

### Key Components

- **`quick_setup.sh`**: Main automated installer (run from admin account)
- **`KioskLauncher.sh`**: Simple bash script that launches Chrome in kiosk mode
- **`kiosk_monitor.sh`**: Monitor script that checks Chrome status and relaunches via KioskLauncher.app
- **`DefaultKeyBinding.dict`**: Disables Cmd+Q, Cmd+Tab, and other escape keys
- **`com.kiosk.chrome.plist`**: LaunchDaemon for running kiosk_monitor.sh

### User Setup

- **Admin account**: Used for setup and emergency access
- **Kiosk user** (configurable): Auto-login user restricted by Parental Controls
- **Auto-login**: Configured via `com.apple.loginwindow` preferences

## Common Commands

### Setup Commands
```bash
# Run initial setup (from admin account, NOT as sudo)
./quick_setup.sh

# Manual setup if automated fails
sudo cp KioskLauncher.sh /Users/[kiosk_user]/
sudo cp kiosk_monitor.sh /Users/[kiosk_user]/
sudo chmod +x /Users/[kiosk_user]/*.sh
sudo chown [kiosk_user]:staff /Users/[kiosk_user]/*.sh

# Manual daemon setup via Finder copy method
# 1. Copy files to iMac via Finder
# 2. On the iMac terminal:
sudo cp ~/kiosk_monitor.sh /Users/[kiosk_user]/
sudo chmod +x /Users/[kiosk_user]/kiosk_monitor.sh
sudo chown [kiosk_user]:staff /Users/[kiosk_user]/kiosk_monitor.sh

# Fix daemon ownership and load
sudo chown root:wheel /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo chmod 644 /Library/LaunchDaemons/com.kiosk.chrome.plist

# Create log file with proper permissions
sudo touch /var/log/kiosk_monitor.log
sudo chown [kiosk_user]:staff /var/log/kiosk_monitor.log

# Reload daemon
sudo launchctl unload /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo launchctl load /Library/LaunchDaemons/com.kiosk.chrome.plist
```

### Testing Commands
```bash
# Test Chrome launch manually
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --kiosk --app=http://wikipedia.org

# Test kiosk launcher script
bash /Users/[kiosk_user]/KioskLauncher.sh

# Check monitor log
tail -f /var/log/kiosk_monitor.log

```

### Chrome Updater Removal (Manual)
```bash
# Remove KeystoneRegistration framework (eliminates ksadmin/GoogleSoftwareUpdateAgent dialogs)
sudo rm -rf "/Applications/Google Chrome.app/Contents/Versions/49.0.2623.87/Google Chrome Framework.framework/Frameworks/KeystoneRegistration.framework"

# Remove GoogleSoftwareUpdate directories
rm -rf ~/Library/Google/GoogleSoftwareUpdate/
sudo rm -rf /Library/Google/GoogleSoftwareUpdate/

# Create dummy files to prevent recreation
touch ~/Library/Google/GoogleSoftwareUpdate
chmod 000 ~/Library/Google/GoogleSoftwareUpdate
sudo mkdir -p /Library/Google/
sudo touch /Library/Google/GoogleSoftwareUpdate
sudo chmod 000 /Library/Google/GoogleSoftwareUpdate
sudo chown nobody:nogroup /Library/Google/GoogleSoftwareUpdate

# Note: This is automatically handled by quick_setup.sh
```


### System Configuration
```bash
# Configure auto-login
sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser -string "[kiosk_user]"

# Check auto-login setting
defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser

# Chrome daemon management
sudo launchctl load /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo launchctl unload /Library/LaunchDaemons/com.kiosk.chrome.plist

# Complete system reset
sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser
sudo launchctl unload /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo rm /Library/LaunchDaemons/com.kiosk.chrome.plist
```

## Configuration Variables

### In `config.sh` (all configuration centralized):
- `KIOSK_URL`: Target website URL (default: "https://your-website.com")
- `QUIZ_DOMAIN`: Target website domain (default: "your-website.com")
- `ADMIN_PASSWORD`: Admin exit password (default: "changeme123")
- `KIOSK_USER`: Kiosk username (default: "kiosk")

### In `KioskLauncher.sh`:
- Loads configuration from `config.sh`
- `CHROME_PATH`: Path to Chrome executable


## Documentation Structure

- **`docs/setup-guide.md`**: Current working configuration and deployment procedures
- **`docs/troubleshooting.md`**: Common problems, emergency procedures, and quick fixes

## System Requirements

- **Mac OS X 10.6 Snow Leopard**
- **Chrome 49.0.2623.112** (specific version for Snow Leopard)
- **Admin account** for setup
- **Existing user account** (configurable) for kiosk mode

## Security Notes

- Parental Controls must be configured manually via System Preferences
- Exit kiosk mode: `Cmd+Shift+Q+Q` + admin password
- Emergency procedures documented in `docs/troubleshooting.md`

## File Structure

- **Root scripts**: `quick_setup.sh`, `KioskLauncher.sh`, `kiosk_monitor.sh`
- **Runtime files**: Configuration scripts target `/Users/[kiosk_user]/` directory
- **System integration**: Daemons install to `/Library/LaunchDaemons/`
- **Logs**: `/var/log/kiosk_monitor.log`

## Important Notes

- **Enhanced security**: Key bindings disable Cmd+Q/Cmd+Tab, Chrome auto-restarts via monitor daemon
- **Monitor system**: Uses kiosk_monitor.sh to launch KioskLauncher.app for faster startup
- **Monitor approach**: Daemon checks Chrome every 10 seconds and relaunches if needed
- **Deployment ready**: Suitable for production use with robust escape prevention
- **Manual step required**: Parental Controls must be configured via System Preferences after setup
- **Emergency exit**: Cmd+Shift+Q+Q still works for admin access (not disabled by key bindings)
- **Configuration**: All settings centralized in `config.sh` for easy customization