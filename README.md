# Snow Leopard Kiosk System

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-10.6_Snow_Leopard-blue.svg)](https://en.wikipedia.org/wiki/Mac_OS_X_Snow_Leopard)
[![Chrome](https://img.shields.io/badge/Chrome-49.0.2623.112-green.svg)](https://google-chrome.en.uptodown.com/mac/versions)

A secure, production-ready kiosk system for Mac OS X 10.6 Snow Leopard using Chrome in fullscreen mode with comprehensive system-level security restrictions. Perfect for exhibitions, museums, public displays, and controlled access environments.

## 🚀 Features

### Two-Layer Security Architecture
1. **System Level**: Parental Controls restrict user to Chrome only with Simple Finder
2. **Application Level**: Chrome kiosk mode with comprehensive security flags

### Core Functionality
- **Fullscreen Chrome kiosk mode** with no browser UI
- **Auto-login and automatic startup** with configurable user account
- **Self-monitoring system** detects and auto-restarts Chrome if closed
- **Admin emergency exit** via secure key sequence (Cmd+Shift+Q+Q)
- **Centralized configuration** via single config file
- **Chrome updater elimination** prevents permission dialogs
- **Key binding security** disables common escape routes (Cmd+Q, Cmd+Tab, etc.)

## 📋 Requirements

- **Mac OS X 10.6 Snow Leopard** (specifically designed for this version)
- **Chrome 49.0.2623.112** ([download link](https://google-chrome.en.uptodown.com/mac/versions))
- **Admin account** for setup and emergency access
- **Target user account** (will be created if it doesn't exist)

## ⚡ Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/arp3xp2/aqua-kiosk-os.git
cd aqua-kiosk-os
```

### 2. Configure Your Kiosk
```bash
# Edit the configuration file
nano config.sh

# Key settings to update:
# - KIOSK_URL: Your target website
# - ADMIN_PASSWORD: Change from default!
# - KIOSK_USER: Kiosk account name

# Verify your configuration
./config.sh
```

### 3. Run Automated Setup
```bash
# Run from admin account (NOT with sudo)
./quick_setup.sh
```

### 4. Configure Parental Controls (Manual Step)
After running setup, configure Parental Controls:
1. Open **System Preferences** → **Accounts** → select kiosk user
2. Click **Enable Parental Controls**
3. Go to **Apps tab**: Enable "Use Simple Finder" and allow only "Google Chrome"

### 5. Create Auto-Launcher
1. Open **Automator** → Create **Application**
2. Add **"Run Shell Script"** action with: `bash /Users/kiosk/KioskLauncher.sh` (or your configured user)
3. Save as `KioskLauncher.app` in `/Users/kiosk/` (or your configured user's home)

## 🔧 Configuration

All system settings are centralized in `config.sh`. Key configuration options:

```bash
# Target website URL
KIOSK_URL="https://your-website.com"

# Kiosk user account (created if needed)
KIOSK_USER="kiosk"

# Admin password for emergency exit
ADMIN_PASSWORD="your-secure-password"

# Monitor check interval (seconds)
MONITOR_CHECK_INTERVAL=10

# Chrome security flags (pre-configured for Snow Leopard)
CHROME_FLAGS=(...)
```

Run `./config.sh --examples` to see configuration examples for different use cases.

## 🏗️ Architecture

```
Boot → Auto-login → LaunchDaemon → Monitor Script → KioskLauncher.app → Chrome Kiosk
         ↓                              ↓                                      ↓
    (kiosk user)              (checks every 10s)                     Target Website
                                        ↓
                              (relaunches if needed)
```

## 💡 Use Cases

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

## 🛡️ Security Considerations

### What This System Provides
- Prevents common escape routes (Cmd+Q, Cmd+Tab, etc.)
- Restricts file system access via Simple Finder
- Monitors and auto-restarts the kiosk application
- Admin-only system access with password protection

### What This System Doesn't Provide
- Complete security isolation (determined users may find other methods)
- Protection against physical access to hardware
- Network-level monitoring or restrictions

This system is designed for **trusted environments** where you want to prevent casual users from accessing the system while maintaining ease of administration.

## 📚 Documentation

- [`docs/setup-guide.md`](docs/setup-guide.md) - Detailed setup instructions
- [`docs/troubleshooting.md`](docs/troubleshooting.md) - Common issues and solutions
- [`CLAUDE.md`](CLAUDE.md) - Technical reference and development notes

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:
- Code style and standards
- Testing requirements
- Pull request process
- Issue reporting

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Designed specifically for Mac OS X 10.6 Snow Leopard compatibility
- Uses the last Chrome version (49.0.2623.112) that supports Snow Leopard
- Built for reliability in exhibition and public display environments

## ⚠️ Important Notes

- **Manual step required**: Parental Controls must be configured via System Preferences after automated setup
- **Chrome version**: Must use Chrome 49.0.2623.112 - newer versions don't support Snow Leopard
- **Emergency exit**: Admin can always exit with Cmd+Shift+Q+Q + password

---

For support, please check the [troubleshooting guide](docs/troubleshooting.md) or open an issue.