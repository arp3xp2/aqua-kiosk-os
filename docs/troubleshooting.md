# Troubleshooting Guide

## 🔧 Common Problems & Solutions

### Problem: Chrome Won't Start in Kiosk Mode

**Symptoms:**
- iMac auto-logs in but no Chrome window appears
- Chrome starts but not in kiosk mode

**Check KioskLauncher.sh:**
```bash
# Test the script manually
bash /Users/[kiosk_user]/KioskLauncher.sh

# Check for errors in Console.app
```

**Common fixes:**
```bash
# Make sure Chrome is installed correctly
ls -la "/Applications/Google Chrome.app"

# Check script permissions
chmod +x /Users/[kiosk_user]/KioskLauncher.sh

# Test Chrome manually
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --kiosk --app=http://wikipedia.org
```

---

### Problem: Users Can Access Chrome Settings

**Symptoms:**
- Users can press F12 to open developer tools
- Users can access chrome://settings/
- Parental Controls not working

**Solution - Enable Parental Controls:**
1. **System Preferences** → **Accounts**
2. Select **kiosk** user (or your configured user)
3. **☑ Enable parental controls**
4. **Open Parental Controls**
5. **Apps tab:**
   - **☑ Use Simple Finder**
   - **☑ Only allow selected applications**
   - **☑ Google Chrome** (only)

---

### Problem: Auto-Login Not Working

**Symptoms:**
- Login screen appears instead of auto-login
- Wrong user auto-logs in

**Fix auto-login:**
```bash
# Check current setting
defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser

# Should show: [kiosk_user]

# Fix if wrong/missing
sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser -string "[kiosk_user]"

# Restart to test
sudo shutdown -r now
```

---

### Problem: Website Won't Load

**Symptoms:**
- Chrome launches but target site shows "Cannot connect"
- Network connectivity issues

**Solution:**
```bash
# Check if your target website resolves
dig your-website.com

# Test connectivity manually
ping your-website.com

# Check Chrome can access the site
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --app=http://your-website.com
```

---

### Problem: Kiosk Monitor Not Working

**Symptoms:**
- Chrome doesn't restart when closed
- Monitor daemon not running

**Check monitor status:**
```bash
# Check if daemon is loaded
sudo launchctl list | grep kiosk

# Check monitor log
tail -f /var/log/kiosk_monitor.log

# Reload daemon if needed
sudo launchctl unload /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo launchctl load /Library/LaunchDaemons/com.kiosk.chrome.plist
```

---

## 📞 Remote Admin Access

### SSH Access (if enabled)
```bash
# From another computer on same network
ssh admin@[kiosk-ip-address]

# Check system status remotely
sudo launchctl list | grep kiosk
```

### VNC/Screen Sharing (if enabled)
1. **Connect via Screen Sharing**
2. **Switch to admin user**
3. **Run diagnostic commands**

---

## 🔄 Reset Everything

### Complete Kiosk Reset
```bash
# 1. Remove auto-login
sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser

# 2. Remove Chrome daemon
sudo launchctl unload /Library/LaunchDaemons/com.kiosk.chrome.plist
sudo rm /Library/LaunchDaemons/com.kiosk.chrome.plist

# 3. Restart
sudo shutdown -r now
```

---

## 📋 Pre-Deployment Checklist

### Test Everything:
- [ ] **iMac auto-logs into kiosk user**
- [ ] **Chrome launches automatically in kiosk mode**
- [ ] **Target website loads correctly**
- [ ] **Can interact with website properly**
- [ ] **Cannot access Chrome settings** (F12, chrome://settings blocked)
- [ ] **Cannot switch to other apps** (Cmd+Tab blocked)
- [ ] **Admin exit works** (Cmd+Shift+Q+Q + password)
- [ ] **Chrome auto-restarts** when closed

### Emergency Kit:
- [ ] **Admin account password**
- [ ] **Emergency access plan** written down
- [ ] **Backup system** (if critical deployment)
- [ ] **Network cable** (for hardwired connection)
- [ ] **This troubleshooting guide** printed out

---

## 📱 Quick Reference Commands

```bash
# Check daemon status
sudo launchctl list | grep kiosk

# Check monitor log
tail -f /var/log/kiosk_monitor.log

# Test Chrome manually
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --kiosk --app=http://wikipedia.org

# Test kiosk launcher
bash /Users/[kiosk_user]/KioskLauncher.sh

# Check auto-login setting
defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser
```

---

## ⚠️ Important Notes

1. **Always test the complete setup** before deployment
2. **Have a backup plan** (second computer, mobile hotspot, etc.)
3. **Print this guide** - you might not have internet access to read it
4. **Know your admin password** - write it down securely
5. **Test emergency procedures** at least once before going live
6. **Monitor system logs** for any unexpected behavior