#!/bin/bash

# Snow Leopard Kiosk System Configuration
# Edit these values to customize your kiosk setup

# =======================
# BASIC CONFIGURATION
# =======================

# Target website URL - change this to your kiosk website
KIOSK_URL="https://your-website.com"

# Kiosk user account name (will be created if it doesn't exist)
KIOSK_USER="kiosk"

# Admin password for emergency exit (CHANGE THIS!)
# WARNING: You MUST change this password before deployment!
ADMIN_PASSWORD="changeme123"

# =======================
# NETWORK CONFIGURATION
# =======================

# Primary domain for validation and future firewall features
QUIZ_DOMAIN="your-website.com"

# FUTURE FEATURE: Firewall configuration (not currently implemented)
# Additional allowed domains for firewall (fonts, analytics, etc.)
ADDITIONAL_DOMAINS=(
    "fonts.googleapis.com"
    "fonts.gstatic.com"
    "plausible.io"
    "wikipedia.org"
)

# =======================
# SYSTEM PATHS
# =======================

# Chrome executable path
CHROME_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Kiosk user home directory
KIOSK_HOME="/Users/$KIOSK_USER"

# KioskLauncher app path
KIOSK_APP="$KIOSK_HOME/KioskLauncher.app"

# =======================
# MONITORING SETTINGS
# =======================

# How often to check if Chrome is running (seconds)
MONITOR_CHECK_INTERVAL=10

# How long to wait after launching Chrome before checking again (seconds)
MONITOR_LAUNCH_DELAY=30

# Log file for monitor script
MONITOR_LOG="/var/log/kiosk_monitor.log"

# =======================
# CHROME SECURITY FLAGS
# =======================

# Chrome launch flags for kiosk mode security
# Minimal stable flags for Snow Leopard to avoid flickering
CHROME_FLAGS=(
    "--kiosk"
    "--app=$KIOSK_URL"
    "--disable-dev-tools"
    "--disable-extensions"
    "--disable-plugins"
    "--no-first-run"
    "--no-default-browser-check"
    "--disable-component-update"
    "--disable-background-downloads"
    "--disable-add-to-shelf"
    "--disable-prompt-on-repost"
    "--disable-hang-monitor"
    "--disable-features=TranslateUI,Translate"
    "--no-service-autorun"
    "--disable-sync"
    "--disable-default-apps"
    "--disable-auto-update"
    "--disable-features=GoogleUpdateService"
    "--disable-component-updater"
)

# Additional flags that may cause flickering on Snow Leopard (commented out):
# "--disable-gpu"                                 # Can cause display issues
# "--disable-software-rasterizer"                 # Conflicts with --disable-gpu
# "--disable-features=VizDisplayCompositor"       # Display compositor problems
# "--disable-renderer-backgrounding"              # Rendering issues
# "--disable-backgrounding-occluded-windows"      # Window management problems
# "--disable-background-networking"               # May affect page loading
# "--disable-background-timer-throttling"         # Timer issues
# "--disable-ipc-flooding-protection"             # IPC problems
# "--no-sandbox"                                  # Security vs stability trade-off

# =======================
# VALIDATION FUNCTIONS
# =======================

# Function to validate configuration
validate_config() {
    local errors=0
    local warnings=0
    
    echo "🔍 Validating configuration..."
    echo ""
    
    # Check if URL is set to default
    if [ "$KIOSK_URL" = "https://your-website.com" ]; then
        echo "⚠️  Warning: Using default placeholder URL. You must change KIOSK_URL to your target website."
        warnings=$((warnings + 1))
    fi
    
    # Validate URL format
    if [[ ! "$KIOSK_URL" =~ ^https?:// ]]; then
        echo "❌ Error: KIOSK_URL must start with http:// or https://"
        errors=$((errors + 1))
    fi
    
    # Check if admin password is default
    if [ "$ADMIN_PASSWORD" = "changeme123" ]; then
        echo "⚠️  Warning: Using default admin password. You MUST change ADMIN_PASSWORD before deployment!"
        warnings=$((warnings + 1))
    fi
    
    # Check password strength
    if [ ${#ADMIN_PASSWORD} -lt 6 ]; then
        echo "⚠️  Warning: Admin password is shorter than 6 characters"
        warnings=$((warnings + 1))
    fi
    
    # Check if quiz domain is set
    if [ "$QUIZ_DOMAIN" = "your-website.com" ]; then
        echo "⚠️  Warning: QUIZ_DOMAIN is set to placeholder. Update for connectivity testing and future firewall features."
        warnings=$((warnings + 1))
    fi
    
    # Check if Chrome exists
    if [ ! -f "$CHROME_PATH" ]; then
        echo "❌ Error: Chrome not found at $CHROME_PATH"
        echo "   Download Chrome 49.0.2623.112 from: https://google-chrome.en.uptodown.com/mac/versions"
        errors=$((errors + 1))
    else
        echo "✅ Chrome found at $CHROME_PATH"
    fi
    
    # Check if kiosk user exists
    if id "$KIOSK_USER" &>/dev/null; then
        echo "✅ Kiosk user '$KIOSK_USER' exists"
    else
        echo "ℹ️  Kiosk user '$KIOSK_USER' will be created during setup"
    fi
    
    # Check monitor intervals
    if [ "$MONITOR_CHECK_INTERVAL" -lt 5 ]; then
        echo "⚠️  Warning: MONITOR_CHECK_INTERVAL is very short (${MONITOR_CHECK_INTERVAL}s)"
        warnings=$((warnings + 1))
    fi
    
    # Check if log directory exists
    local log_dir=$(dirname "$MONITOR_LOG")
    if [ ! -d "$log_dir" ]; then
        echo "⚠️  Warning: Log directory $log_dir does not exist"
        warnings=$((warnings + 1))
    fi
    
    # Summary
    echo ""
    if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
        echo "✅ Configuration is valid and ready for deployment!"
    elif [ $errors -eq 0 ]; then
        echo "⚠️  Configuration is valid but has $warnings warning(s)"
    else
        echo "❌ Configuration has $errors error(s) and $warnings warning(s)"
        echo "   Please fix errors before running setup."
    fi
    
    return $errors
}

# Function to display current configuration
show_config() {
    echo "📋 Snow Leopard Kiosk System Configuration"
    echo "==========================================="
    echo ""
    echo "🎯 Basic Settings:"
    echo "  KIOSK_URL: $KIOSK_URL"
    echo "  KIOSK_USER: $KIOSK_USER"
    echo "  ADMIN_PASSWORD: [hidden - ${#ADMIN_PASSWORD} characters]"
    echo ""
    echo "🌐 Network Settings:"
    echo "  QUIZ_DOMAIN: $QUIZ_DOMAIN"
    echo "  ADDITIONAL_DOMAINS: ${#ADDITIONAL_DOMAINS[@]} domains"
    echo ""
    echo "⚙️  System Paths:"
    echo "  CHROME_PATH: $CHROME_PATH"
    echo "  KIOSK_HOME: $KIOSK_HOME"
    echo "  KIOSK_APP: $KIOSK_APP"
    echo ""
    echo "🔍 Monitor Settings:"
    echo "  CHECK_INTERVAL: ${MONITOR_CHECK_INTERVAL}s"
    echo "  LAUNCH_DELAY: ${MONITOR_LAUNCH_DELAY}s"
    echo "  LOG_FILE: $MONITOR_LOG"
    echo ""
    echo "🔒 Chrome Security:"
    echo "  CHROME_FLAGS: ${#CHROME_FLAGS[@]} flags configured"
    echo "  Key flags: --kiosk, --disable-dev-tools, --disable-extensions"
}

# Function to show help
show_help() {
    echo "Snow Leopard Kiosk System Configuration"
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  (no args)   Show current configuration and validate"
    echo "  --help      Show this help message"
    echo "  --validate  Only run validation checks"
    echo "  --show      Only show configuration (no validation)"
    echo "  --examples  Show configuration examples"
    echo ""
    echo "Examples:"
    echo "  $0                    # Show config and validate"
    echo "  $0 --validate         # Check configuration only"
    echo "  $0 --examples         # Show example configurations"
}

# Function to show configuration examples
show_examples() {
    echo "📚 Configuration Examples"
    echo "========================"
    echo ""
    echo "🏛️  Museum/Exhibition Setup:"
    echo '  KIOSK_URL="https://your-exhibition.com"'
    echo '  KIOSK_USER="exhibit"'
    echo '  ADMIN_PASSWORD="museum2024"'
    echo '  QUIZ_DOMAIN="your-exhibition.com"'
    echo ""
    echo "🛒 Retail Information Terminal:"
    echo '  KIOSK_URL="https://store-info.company.com"'
    echo '  KIOSK_USER="retail"'
    echo '  ADMIN_PASSWORD="store123"'
    echo '  QUIZ_DOMAIN="store-info.company.com"'
    echo ""
    echo "🏢 Corporate Lobby Kiosk:"
    echo '  KIOSK_URL="https://directory.company.com"'
    echo '  KIOSK_USER="lobby"'
    echo '  ADMIN_PASSWORD="corporate456"'
    echo '  QUIZ_DOMAIN="directory.company.com"'
    echo ""
    echo "⚡ Quick Local Testing:"
    echo '  KIOSK_URL="http://localhost:8000"'
    echo '  KIOSK_USER="test"'
    echo '  ADMIN_PASSWORD="test123"'
    echo '  QUIZ_DOMAIN="localhost"'
}

# If script is run directly, handle arguments
if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    case "${1:-}" in
        --help|-h)
            show_help
            ;;
        --validate)
            validate_config
            ;;
        --show)
            show_config
            ;;
        --examples)
            show_examples
            ;;
        "")
            show_config
            echo ""
            validate_config
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
fi