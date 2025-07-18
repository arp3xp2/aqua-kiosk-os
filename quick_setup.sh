#!/bin/bash

# Quick Setup Script for Snow Leopard Kiosk
# Automates the entire kiosk setup process
# NOTE: Firewall disabled by default - manual setup recommended for current working config

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Configuration is now loaded from config.sh
# Edit config.sh to change these values

echo -e "${BLUE}===============================================${NC}"
echo -e "${BLUE}  Snow Leopard Kiosk Quick Setup${NC}"
echo -e "${BLUE}===============================================${NC}"
echo ""

# Function to print colored status
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Function to check if running as admin
check_admin() {
    if [ "$EUID" -eq 0 ]; then
        print_error "Don't run this script as root. It will use sudo when needed."
        exit 1
    fi
}

# Function to validate configuration
validate_config() {
    print_info "Validating configuration..."
    
    if [ "$QUIZ_DOMAIN" = "your-website.com" ]; then
        print_error "Please edit QUIZ_DOMAIN in config.sh first!"
        exit 1
    fi
    
    if [ "$ADMIN_PASSWORD" = "admin123" ]; then
        print_warning "Using default admin password. Please change it in config.sh!"
    fi
    
    print_status "Configuration validated"
}

# Function to test internet connectivity
test_connectivity() {
    print_info "Testing internet connectivity..."
    
    if curl -s --max-time 10 "http://$QUIZ_DOMAIN" > /dev/null 2>&1; then
        print_status "Quiz website is accessible"
    else
        print_error "Cannot reach quiz website: $QUIZ_DOMAIN"
        print_info "Please check the domain name in config.sh and internet connection"
        exit 1
    fi
}

# Function to setup Chrome 49
setup_chrome() {
    print_info "Checking Chrome installation..."
    
    if [ -d "/Applications/Google Chrome.app" ]; then
        print_status "Chrome is already installed"
    else
        print_warning "Chrome not found. Please install Chrome 49.0.2623.112 first."
        print_info "Download from: https://google-chrome.en.uptodown.com/mac/versions"
        exit 1
    fi
}

# Function to remove Chrome updater to prevent permission dialogs
remove_chrome_updater() {
    print_info "Removing Chrome updater components to prevent permission dialogs..."
    
    # Find Chrome version directory
    local chrome_version_dir
    chrome_version_dir=$(find "/Applications/Google Chrome.app/Contents/Versions" -name "49.0.2623.*" -type d | head -1)
    
    if [ -z "$chrome_version_dir" ]; then
        print_warning "Chrome version directory not found, skipping updater removal"
        return
    fi
    
    # Remove KeystoneRegistration framework
    local keystone_framework="$chrome_version_dir/Google Chrome Framework.framework/Frameworks/KeystoneRegistration.framework"
    if [ -d "$keystone_framework" ]; then
        sudo rm -rf "$keystone_framework"
        print_status "KeystoneRegistration framework removed"
    fi
    
    # Remove keystone promote script
    local keystone_script="$chrome_version_dir/Google Chrome Framework.framework/Resources/keystone_promote_postflight.sh.disabled"
    if [ -f "$keystone_script" ]; then
        sudo rm -f "$keystone_script"
        print_status "Keystone promote script removed"
    fi
    
    # Remove GoogleSoftwareUpdate directories
    if [ -d "$HOME/Library/Google/GoogleSoftwareUpdate" ]; then
        rm -rf "$HOME/Library/Google/GoogleSoftwareUpdate"
        print_status "User GoogleSoftwareUpdate directory removed"
    fi
    
    # Create dummy files to prevent recreation
    touch "$HOME/Library/Google/GoogleSoftwareUpdate" 2>/dev/null || true
    chmod 000 "$HOME/Library/Google/GoogleSoftwareUpdate" 2>/dev/null || true
    
    # Create system-level dummy files
    sudo mkdir -p /Library/Google/ 2>/dev/null || true
    sudo touch /Library/Google/GoogleSoftwareUpdate 2>/dev/null || true
    sudo chmod 000 /Library/Google/GoogleSoftwareUpdate 2>/dev/null || true
    sudo chown nobody:nogroup /Library/Google/GoogleSoftwareUpdate 2>/dev/null || true
    
    # Create dummy file for kiosk user if different from current user
    if [ "$KIOSK_USER" != "$USER" ]; then
        sudo mkdir -p "/Users/$KIOSK_USER/Library/Google/" 2>/dev/null || true
        sudo touch "/Users/$KIOSK_USER/Library/Google/GoogleSoftwareUpdate" 2>/dev/null || true
        sudo chmod 000 "/Users/$KIOSK_USER/Library/Google/GoogleSoftwareUpdate" 2>/dev/null || true
        sudo chown nobody:nogroup "/Users/$KIOSK_USER/Library/Google/GoogleSoftwareUpdate" 2>/dev/null || true
    fi
    
    print_status "Chrome updater components removed - no more permission dialogs"
}

# Function to setup kiosk user (create if needed)
setup_kiosk_user() {
    print_info "Setting up kiosk user account..."
    
    # Check if user exists
    if id "$KIOSK_USER" &>/dev/null; then
        print_status "Kiosk user '$KIOSK_USER' already exists"
        
        # Check if home directory exists
        if [ -d "/Users/$KIOSK_USER" ]; then
            print_status "Home directory exists"
        else
            print_error "Home directory /Users/$KIOSK_USER not found!"
            exit 1
        fi
    else
        print_info "Creating new kiosk user '$KIOSK_USER'..."
        
        # Create user using dscl
        sudo dscl . create /Users/$KIOSK_USER
        sudo dscl . create /Users/$KIOSK_USER UserShell /bin/bash
        sudo dscl . create /Users/$KIOSK_USER RealName "Kiosk User"
        sudo dscl . create /Users/$KIOSK_USER UniqueID 503
        sudo dscl . create /Users/$KIOSK_USER PrimaryGroupID 503
        sudo dscl . create /Users/$KIOSK_USER NFSHomeDirectory /Users/$KIOSK_USER
        
        # Create home directory
        sudo mkdir -p /Users/$KIOSK_USER
        sudo chown $KIOSK_USER:$KIOSK_USER /Users/$KIOSK_USER
        
        print_status "Kiosk user '$KIOSK_USER' created"
    fi
}

# Function to setup auto-login
setup_autologin() {
    print_info "Configuring auto-login..."
    
    sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser -string "$KIOSK_USER"
    
    print_status "Auto-login configured"
}

# Function to copy kiosk files
setup_kiosk_files() {
    print_info "Setting up kiosk files..."
    
    local kiosk_home="/Users/$KIOSK_USER"
    
    # Copy and configure KioskLauncher.sh
    if [ -f "KioskLauncher.sh" ]; then
        sudo cp KioskLauncher.sh "$kiosk_home/"
        sudo chown $KIOSK_USER:staff "$kiosk_home/KioskLauncher.sh"
        sudo chmod +x "$kiosk_home/KioskLauncher.sh"
        print_status "KioskLauncher.sh configured"
    else
        print_error "KioskLauncher.sh not found!"
        exit 1
    fi
    
    # Copy and configure kiosk_monitor.sh
    if [ -f "kiosk_monitor.sh" ]; then
        sudo cp kiosk_monitor.sh "$kiosk_home/"
        sudo chown $KIOSK_USER:staff "$kiosk_home/kiosk_monitor.sh"
        sudo chmod +x "$kiosk_home/kiosk_monitor.sh"
        print_status "kiosk_monitor.sh configured"
    else
        print_error "kiosk_monitor.sh not found!"
        exit 1
    fi
    
}


# Function to setup key bindings for kiosk security
setup_key_bindings() {
    print_info "Setting up keyboard security (disable Cmd+Q, Cmd+Tab, etc.)..."
    
    local kiosk_home="/Users/$KIOSK_USER"
    local keybindings_dir="$kiosk_home/Library/KeyBindings"
    
    # Create KeyBindings directory if it doesn't exist
    sudo mkdir -p "$keybindings_dir"
    
    # Copy DefaultKeyBinding.dict to disable dangerous key combinations
    if [ -f "DefaultKeyBinding.dict" ]; then
        sudo cp DefaultKeyBinding.dict "$keybindings_dir/"
        sudo chown $KIOSK_USER:staff "$keybindings_dir/DefaultKeyBinding.dict"
        print_status "Key bindings configured - Cmd+Q, Cmd+Tab, etc. disabled"
    else
        print_error "DefaultKeyBinding.dict not found!"
        exit 1
    fi
}

# Function to setup Chrome auto-restart daemon
setup_chrome_daemon() {
    print_info "Setting up Chrome auto-restart daemon..."
    
    local daemon_plist="/Library/LaunchDaemons/com.kiosk.chrome.plist"
    
    # Generate plist file with current config
    print_info "Generating plist files from config..."
    ./generate_plist.sh
    
    # Copy the Chrome launcher daemon
    if [ -f "com.kiosk.chrome.plist" ]; then
        sudo cp com.kiosk.chrome.plist "$daemon_plist"
        sudo chown root:wheel "$daemon_plist"
        sudo chmod 644 "$daemon_plist"
        
        # Create log file with proper permissions
        sudo touch "$MONITOR_LOG"
        sudo chown $KIOSK_USER:staff "$MONITOR_LOG"
        
        # Load the daemon (but don't start it yet - will start on reboot)
        print_status "Chrome auto-restart daemon configured"
        print_warning "Chrome daemon will start on next reboot, or load manually with: sudo launchctl load $daemon_plist"
    else
        print_error "com.kiosk.chrome.plist not found!"
        exit 1
    fi
}


# Function to test complete setup
test_setup() {
    print_info "Testing complete setup..."
    
    print_info "Testing Chrome launch..."
    if /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version > /dev/null 2>&1; then
        print_status "Chrome can be launched"
    else
        print_warning "Chrome launch test failed"
    fi
    
    print_status "Setup testing completed"
}

# Function to display final instructions
show_final_instructions() {
    echo ""
    echo -e "${GREEN}===============================================${NC}"
    echo -e "${GREEN}  Setup Complete!${NC}"
    echo -e "${GREEN}===============================================${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Set up Parental Controls:"
    echo "   - System Preferences → Accounts"
    echo "   - Select '$KIOSK_USER' user"
    echo "   - Enable Parental Controls"
    echo "   - Apps tab: Only allow Google Chrome"
    echo ""
    echo "2. Test the setup:"
    echo "   - Restart the iMac"
    echo "   - Should auto-login to kiosk user"
    echo "   - Chrome should auto-launch and auto-restart if closed"
    echo ""
    echo -e "${BLUE}Security features enabled:${NC}"
    echo "   - Cmd+Q, Cmd+Tab, Cmd+W disabled via key bindings"
    echo "   - Chrome auto-restarts if user exits (KeepAlive daemon)"
    echo "   - Parental Controls restrict to Chrome only"
    echo ""
    echo -e "${BLUE}Admin access:${NC}"
    echo "   - Exit kiosk: Cmd+Shift+Q+Q → enter password (still works)"
    echo "   - Switch users to admin account"
    echo ""
    echo -e "${BLUE}Emergency restore:${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  Remember to configure Parental Controls manually!${NC}"
}

# Main setup process
main() {
    check_admin
    validate_config
    test_connectivity
    setup_chrome
    remove_chrome_updater
    setup_kiosk_user
    setup_autologin
    setup_kiosk_files
    setup_key_bindings
    setup_chrome_daemon
    test_setup
    show_final_instructions
}

# Run main function
main "$@"