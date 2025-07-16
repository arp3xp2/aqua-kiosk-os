# Manual Setup Guide - Using Finder Copy Method

This guide explains how to manually set up the kiosk system by copying files via Finder and running terminal commands.

## Files to Copy

Copy these files to the iMac (e.g., to your home directory):

1. `kiosk_monitor.sh` - The monitor script that checks Chrome
2. `com.kiosk.chrome.plist` - The LaunchDaemon configuration
3. `KioskLauncher.sh` - Chrome launcher script
4. `whitelist_firewall.sh` - Firewall script (optional)

## Terminal Commands to Run

After copying the files to the iMac, run these commands in Terminal:

### 1. Copy Monitor Script
```bash
# Copy monitor script to kiosk user directory
sudo cp ~/kiosk_monitor.sh /Users/[kiosk_user]/
sudo chmod +x /Users/[kiosk_user]/kiosk_monitor.sh
sudo chown [kiosk_user]:staff /Users/[kiosk_user]/kiosk_monitor.sh
```

### 2. Install and Fix LaunchDaemon
```bash
# Fix ownership of the plist file (CRITICAL)
sudo chown root:wheel /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo chmod 644 /Library/LaunchDaemons/com.kiosk.chrome.plist
```

### 3. Create Log File
```bash
# Create log file with proper permissions
sudo touch /var/log/kiosk_monitor.log
sudo chown [kiosk_user]:staff /var/log/kiosk_monitor.log
```

### 4. Load the Daemon
```bash
# Unload if already loaded
sudo launchctl unload /Library/LaunchDaemons/com.kiosk.chrome.plist

# Load the daemon
sudo launchctl load /Library/LaunchDaemons/com.kiosk.chrome.plist
```

### 5. Verify It's Running
```bash
# Check if daemon is loaded
sudo launchctl list | grep kiosk

# Monitor the log file
tail -f /var/log/kiosk_monitor.log
```

## Complete Command Sequence

Here's the full sequence to copy and paste:

```bash
# Step 1: Copy scripts (adjust paths as needed)
sudo cp ~/kiosk_monitor.sh /Users/[kiosk_user]/
sudo chmod +x /Users/[kiosk_user]/kiosk_monitor.sh
sudo chown [kiosk_user]:staff /Users/[kiosk_user]/kiosk_monitor.sh

# Step 2: Fix daemon ownership
sudo chown root:wheel /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo chmod 644 /Library/LaunchDaemons/com.kiosk.chrome.plist

# Step 3: Create log file
sudo touch /var/log/kiosk_monitor.log
sudo chown [kiosk_user]:staff /var/log/kiosk_monitor.log

# Step 4: Reload daemon
sudo launchctl unload /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo launchctl load /Library/LaunchDaemons/com.kiosk.chrome.plist

# Step 5: Check status
sudo launchctl list | grep kiosk
tail -f /var/log/kiosk_monitor.log
```

## Troubleshooting

### "Dubious ownership" Error
If you see this error when loading the daemon:
```
launchctl: Dubious ownership on file (skipping)
```

Fix it with:
```bash
sudo chown root:wheel /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo chmod 644 /Library/LaunchDaemons/com.kiosk.chrome.plist
```

### No Log Output
If the log file is empty:
```bash
# Make sure the log file exists and has correct permissions
sudo touch /var/log/kiosk_monitor.log
sudo chown [kiosk_user]:staff /var/log/kiosk_monitor.log
```

### Chrome Not Starting
Check that KioskLauncher.app exists:
```bash
ls -la /Users/[kiosk_user]/KioskLauncher.app
```

If not, you need to create it using Automator first (see main setup guide).

## How It Works

1. The LaunchDaemon runs `kiosk_monitor.sh` at system startup
2. The monitor script checks every 10 seconds if Chrome is running
3. If Chrome isn't running, it launches KioskLauncher.app
4. KioskLauncher.app runs the Chrome kiosk command
5. This avoids the 2-3 minute startup delay of the previous method