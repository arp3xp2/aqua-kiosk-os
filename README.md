# Snow Leopard Kiosk System

[![License: Sustainable Use](https://img.shields.io/badge/License-Sustainable_Use-blue.svg)](LICENSE)
[![macOS](https://img.shields.io/badge/macOS-10.6_Snow_Leopard-blue.svg)](https://en.wikipedia.org/wiki/Mac_OS_X_Snow_Leopard)
[![Chrome](https://img.shields.io/badge/Chrome-49.0.2623.112-green.svg)](https://google-chrome.en.uptodown.com/mac/versions)

> Transform any Mac OS X 10.6 Snow Leopard system into a secure, production-ready kiosk for museums, retail, education, and public displays.

## Features

- **🔒 Two-layer security**: System-level restrictions + Chrome kiosk mode
- **🚀 One-command setup**: Automated installation and configuration
- **🔄 Self-monitoring**: Auto-restarts Chrome if closed or crashed
- **⚡ Fast startup**: Optimized launch sequence via KioskLauncher.app
- **🛡️ Auto-restart protection**: Chrome automatically restarts if quit
- **🔧 Centralized config**: Single file controls all settings

## Quick Start

```bash
# 1. Clone and configure
git clone https://github.com/arp3xp2/aqua-kiosk-os.git
cd aqua-kiosk-os
nano config.sh  # Update KIOSK_URL and ADMIN_PASSWORD

# 2. Run setup (from admin account, NOT sudo)
./quick_setup.sh

# 3. Configure Parental Controls (see Manual Steps below)
```

## System Requirements

- **Mac OS X 10.6 Snow Leopard** (specifically designed for this version)
- **Chrome 49.0.2623.112** ([download here](https://google-chrome.en.uptodown.com/mac/versions))
- **Admin account** for setup and emergency access
- **Target user account** (will be created automatically if needed)

## Installation

### 1. Download and Configure

```bash
git clone https://github.com/arp3xp2/aqua-kiosk-os.git
cd aqua-kiosk-os
```

Edit `config.sh` to customize your kiosk:

```bash
# Essential settings to change:
KIOSK_URL="https://your-website.com"           # Target website
ADMIN_PASSWORD="your-secure-password"          # Change from default!
KIOSK_USER="kiosk"                             # Kiosk account name
```

### 2. Run Automated Setup

```bash
# Run from admin account (NOT as sudo)
./quick_setup.sh
```

This script will:
- Create the kiosk user account (if needed)
- Install Chrome 49.0.2623.112 for Snow Leopard
- Configure security settings and monitoring system
- Set up the monitoring daemon
- Remove Chrome auto-updater to prevent permission dialogs

### 3. Manual Steps (Required)

#### Configure Parental Controls
1. Open **System Preferences** → **Accounts** → select your kiosk user
2. Click **Enable Parental Controls**
3. Go to **Apps tab**: 
   - Enable "Use Simple Finder"
   - Allow only "Google Chrome"

#### Create Auto-Launcher
1. Open **Automator** → Create **Application**
2. Add **"Run Shell Script"** action with:
   ```bash
   bash /Users/[kiosk_user]/KioskLauncher.sh
   ```
3. Save as `KioskLauncher.app` in `/Users/[kiosk_user]/`

### 4. Enable Auto-Login (Optional)

```bash
# Configure auto-login for kiosk user
sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser -string "[kiosk_user]"
```

## Configuration

All settings are centralized in `config.sh`:

```bash
# Website Configuration
KIOSK_URL="https://your-website.com"           # Target website URL
QUIZ_DOMAIN="your-website.com"                 # Domain for security checks

# User Configuration  
KIOSK_USER="kiosk"                             # Kiosk account name
ADMIN_PASSWORD="changeme123"                   # Admin exit password (CHANGE THIS!)

# System Configuration
MONITOR_CHECK_INTERVAL=10                      # Chrome monitoring interval (seconds)
```

**Important**: Always change `ADMIN_PASSWORD` from the default value!

## Usage

### Normal Operation
- System boots → Auto-login → Chrome launches in kiosk mode
- Monitor daemon checks Chrome every 10 seconds
- If Chrome closes, it automatically restarts via KioskLauncher.app

### Emergency Exit
- Press `Cmd+Shift+Q+Q` 
- Enter admin password when prompted
- System returns to normal desktop

### Testing
```bash
# Test Chrome launch manually
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --kiosk --app=http://wikipedia.org

# Test kiosk launcher
bash /Users/[kiosk_user]/KioskLauncher.sh

# Monitor system logs
tail -f /var/log/kiosk_monitor.log
```

## Architecture

```
Boot → Auto-login → LaunchDaemon → kiosk_monitor.sh → KioskLauncher.app → Chrome Kiosk
         ↓              ↓                ↓                    ↓                ↓
    (kiosk user)   (system daemon)  (every 10s)      (fast startup)    (fullscreen)
                                        ↓
                               (relaunches if needed)
```

### Key Components

- **`quick_setup.sh`**: Automated installer and configurator
- **`KioskLauncher.sh`**: Chrome launcher script (copied to user directory)
- **`kiosk_monitor.sh`**: System monitor that launches KioskLauncher.app
- **`DefaultKeyBinding.dict`**: Key binding customizations (planned feature)
- **`com.kiosk.chrome.plist`**: LaunchDaemon for system-level monitoring

## Security Features

### What This System Provides
- **System-level restrictions**: Parental Controls limit user to Chrome only
- **Auto-restart protection**: Monitors and relaunches Chrome if closed (10-second intervals)
- **Admin emergency access**: Cmd+Shift+Q+Q + password for authorized users
- **Simple Finder**: Restricts file system access to approved locations
- **Minimal desktop exposure**: Brief desktop access before Chrome auto-restarts

### What This System Doesn't Provide
- Complete security isolation (determined users may find other methods)
- Protection against physical access to hardware
- Network-level monitoring or restrictions

**Note**: This system is designed for **trusted environments** where you want to prevent casual users from accessing the system while maintaining ease of administration. Users may briefly access the desktop if they quit Chrome, but the system automatically restarts Chrome within 10 seconds.

## Troubleshooting

### Common Issues

**Chrome won't start**
```bash
# Check if Chrome is properly installed
ls -la "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Test manual launch
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --kiosk --app=http://wikipedia.org
```

**Monitor not working**
```bash
# Check daemon status
sudo launchctl list | grep kiosk

# View logs
tail -f /var/log/kiosk_monitor.log

# Reload daemon
sudo launchctl unload /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo launchctl load /Library/LaunchDaemons/com.kiosk.chrome.plist
```

**Auto-login not working**
```bash
# Check auto-login setting
defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser

# Reset if needed
sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser -string "[kiosk_user]"
```

For more detailed troubleshooting, see [docs/troubleshooting.md](docs/troubleshooting.md).

## Use Cases

### Museums & Exhibitions
- Interactive displays with web interfaces
- Digital information kiosks  
- Self-guided tour stations

### Retail Environments
- Product information terminals
- Customer feedback systems
- Interactive catalogs

### Corporate & Public Spaces
- Lobby information displays
- Wayfinding kiosks
- Digital directories

### Educational Institutions
- Library catalog terminals
- Campus information kiosks
- Interactive learning stations

## License

This project is licensed under the Sustainable Use License - see the [LICENSE](LICENSE) file for details.

## Important Notes

- **Manual step required**: Parental Controls must be configured via System Preferences after automated setup
- **Chrome version**: Must use Chrome 49.0.2623.112 - newer versions don't support Snow Leopard
- **Emergency exit**: Admin can always exit with Cmd+Shift+Q+Q + password
- **Monitoring system**: Chrome automatically restarts within 10 seconds if closed

---

**Need help?** Check the [troubleshooting guide](docs/troubleshooting.md) or open an issue.