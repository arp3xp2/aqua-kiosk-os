# Snow Leopard Kiosk Setup Guide

## Current Status: ✅ WORKING (with improved monitor system)

**System:** Mac OS X 10.6 Snow Leopard  
**Kiosk User:** Configurable in config.sh (default: kiosk)  

## What's Working

### ✅ Core Functionality
- **Auto-login to kiosk user** on startup
- **Chrome launches in kiosk mode** automatically via monitor daemon
- **Fullscreen display** with no browser UI
- **Monitor daemon** checks Chrome every 10 seconds and relaunches if needed
- **KioskLauncher.app** provides immediate startup (no delays)
- **Wikipedia loads correctly** (http://wikipedia.org)
- **Parental Controls** prevent app switching

### ✅ Security Features
- **Parental Controls active** - only Chrome allowed, Simple Finder
- **Admin-only exit** via Cmd+Shift+Q+Q
- **Network firewall available** but disabled by default for reliability
- **System-level restrictions** prevent unauthorized access

## Current Configuration Files

### 1. KioskLauncher.sh
```bash
#!/bin/bash

# Loads from config.sh
source /Users/[kiosk_user]/config.sh
CHROME_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

"$CHROME_PATH" --kiosk --app="$KIOSK_URL" --disable-dev-tools --disable-extensions --no-first-run --no-default-browser-check --disable-component-update --disable-background-networking --no-sandbox --disable-sync --disable-default-apps --simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'
```

### 2. Auto-Start Method (NEW)
- **Monitor script:** `/Users/[kiosk_user]/kiosk_monitor.sh` runs via LaunchDaemon
- **Automator application:** `/Users/[kiosk_user]/KioskLauncher.app` launched by monitor
- **LaunchDaemon:** `/Library/LaunchDaemons/com.kiosk.chrome.plist`
- **Instant startup:** No more 2-3 minute delays

### 3. Network Configuration
- **Firewall:** Disabled (LaunchDaemon removed)
- **DNS:** Working correctly
- **Internet access:** Full (all sites accessible)

## Known Issues & Workarounds

### ✅ ksadmin Permission Dialog - RESOLVED
**Issue:** Chrome showed permission dialogs for ksadmin and GoogleSoftwareUpdateAgent on launch  
**Impact:** Resolved - no more permission dialogs  
**Solution:** Automated removal of Chrome updater components via `quick_setup.sh`  

**Permanent fix implemented:**
- Removes KeystoneRegistration framework from Chrome app bundle
- Removes GoogleSoftwareUpdate directories
- Creates dummy files to prevent updater recreation
- Adds minimal anti-update Chrome flags

**Note:** This fix is now automatically applied during setup via `quick_setup.sh`

### 🔧 Firewall LaunchDaemon Recreation
**Issue:** `/Library/LaunchDaemons/com.kiosk.firewall.plist` sometimes recreates itself  
**Solution:** Monitor and remove if network issues occur:
```bash
sudo launchctl unload /Library/LaunchDaemons/com.kiosk.firewall.plist
sudo rm /Library/LaunchDaemons/com.kiosk.firewall.plist
# Firewall was removed - no longer applicable
```

## Kiosk Deployment

### Pre-Deployment Checklist
- [ ] Auto-login to kiosk user working
- [ ] Parental Controls configured (Chrome only, Simple Finder)
- [ ] KioskLauncher.app created and added to Login Items
- [ ] Firewall disabled (verify with `whitelist_firewall.sh test`)
- [ ] Target website loads correctly in kiosk mode
- [ ] Emergency procedures documented for staff

### Staff Instructions
1. **Normal operation:** System auto-starts, ignore ksadmin dialog
2. **If stuck:** Click "Deny" on any permission dialogs
3. **Emergency exit:** Cmd+Shift+Q+Q (requires admin password)
4. **Network issues:** Contact admin to check firewall status

## Technical Architecture

```
Boot → Auto-login (kiosk user) → LaunchDaemon → kiosk_monitor.sh → KioskLauncher.app → Chrome Kiosk
                                            ↓                                           ↓
                                    (checks every 10s)                         Target Website
                                            ↓                                           ↑
                                    (relaunches if needed)      No Network Restrictions (Firewall Disabled)
```

## Success Metrics

✅ **Reliability:** Auto-starts consistently  
✅ **Security:** Prevents unauthorized access  
✅ **Usability:** Simple for staff and administrators  
✅ **Compatibility:** Works with Snow Leopard limitations  
✅ **Maintainability:** Clear documentation and emergency procedures  


## Support Information

**SSH Access:** `ssh -o HostKeyAlgorithms=+ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=+ssh-rsa,ssh-dss admin@[kiosk-ip]`  
**Admin Account:** Available for troubleshooting  

This configuration provides a working kiosk system optimized for reliability and production use on Snow Leopard.