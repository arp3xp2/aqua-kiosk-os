# Advanced Troubleshooting

## Advanced Debugging

### Chrome Process Issues
```bash
# Check if Chrome processes are running
ps aux | grep Chrome

# Kill all Chrome processes if stuck
sudo killall "Google Chrome"

# Check Chrome crash logs
ls -la ~/Library/Logs/CrashReporter/

# Test Chrome with minimal flags
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --no-sandbox --disable-web-security
```

### Daemon Debugging
```bash
# Check daemon file permissions
ls -la /Library/LaunchDaemons/com.kiosk.chrome.plist

# Validate plist syntax
sudo plutil -lint /Library/LaunchDaemons/com.kiosk.chrome.plist

# Check daemon logs in system log
sudo grep "kiosk" /var/log/system.log

# Debug daemon loading
sudo launchctl load -w /Library/LaunchDaemons/com.kiosk.chrome.plist
```

### File Permission Issues
```bash
# Fix kiosk user file permissions
sudo chown -R [kiosk_user]:staff /Users/[kiosk_user]/KioskLauncher.sh
sudo chown -R [kiosk_user]:staff /Users/[kiosk_user]/kiosk_monitor.sh
sudo chmod +x /Users/[kiosk_user]/*.sh

# Fix log file permissions
sudo chown [kiosk_user]:staff /var/log/kiosk_monitor.log
sudo chmod 644 /var/log/kiosk_monitor.log
```

## Snow Leopard Specific Issues

### Chrome Version Conflicts
```bash
# Ensure correct Chrome version for Snow Leopard
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version
# Should show: Google Chrome 49.0.2623.112

# Remove incorrect Chrome versions
sudo rm -rf "/Applications/Google Chrome.app"
# Reinstall Chrome 49.0.2623.112
```

### System Preferences Access
```bash
# Check if System Preferences is blocked
open "/Applications/System Preferences.app"

# Reset System Preferences permissions
sudo chmod 755 "/Applications/System Preferences.app"
```

## Network Debugging

### DNS Resolution Issues
```bash
# Test DNS resolution
nslookup your-website.com

# Use different DNS servers
sudo networksetup -setdnsservers "Built-in Ethernet" 8.8.8.8 8.8.4.4

# Flush DNS cache
sudo dscacheutil -flushcache
```

### Connection Testing
```bash
# Test with curl
curl -I http://your-website.com

# Test with wget (if available)
wget --spider http://your-website.com

# Check network interface
ifconfig en0
```

## System Recovery

### Emergency Boot Recovery
1. **Hold Cmd+S during boot** (Single User Mode)
2. **Mount filesystem**: `mount -uw /`
3. **Remove auto-login**: `rm /Library/Preferences/com.apple.loginwindow.plist`
4. **Remove daemon**: `rm /Library/LaunchDaemons/com.kiosk.chrome.plist`
5. **Reboot**: `reboot`

### Safe Mode Recovery
1. **Hold Shift during boot** (Safe Mode)
2. **Log in as admin**
3. **Remove kiosk configuration**
4. **Reboot normally**

## Known Limitations

### Hardware Limitations
- **Memory**: Chrome 49 requires minimum 512MB RAM
- **Display**: Minimum 1024x768 resolution recommended
- **Network**: Ethernet preferred over WiFi for stability

### Software Limitations
- **Chrome extensions**: Not supported in kiosk mode
- **File downloads**: Blocked by default in kiosk mode
- **Print dialogs**: May cause kiosk to become unresponsive

## Performance Monitoring

### System Resource Usage
```bash
# Monitor CPU usage
top -l 1 | grep "Google Chrome"

# Monitor memory usage
ps aux | grep Chrome | awk '{print $4, $11}'

# Monitor disk usage
df -h
```

### Log Analysis
```bash
# Analyze kiosk monitor log patterns
grep "ERROR\|WARN" /var/log/kiosk_monitor.log

# Check system log for kiosk-related entries
sudo grep -i "kiosk\|chrome" /var/log/system.log | tail -20
```

## Emergency Procedures

### Remote Emergency Access
```bash
# If SSH is enabled, connect remotely
ssh admin@[kiosk-ip]

# Emergency daemon stop
sudo launchctl stop com.kiosk.chrome

# Emergency Chrome kill
sudo killall "Google Chrome"
```

### Physical Emergency Access
1. **Cmd+Shift+Q+Q** + admin password (if working)
2. **Force reboot**: Hold power button 10 seconds
3. **Boot to admin account**: Hold Cmd+S or boot to Safe Mode
4. **Remove kiosk configuration** via terminal

---

**Note**: This guide covers advanced scenarios. For common issues, see the main troubleshooting section in the README.