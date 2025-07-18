# Changelog

All notable changes to the Snow Leopard Kiosk System will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-07-16

### Added
- Initial public release of Snow Leopard Kiosk System
- Two-layer security architecture (System, Application)
- Centralized configuration system via `config.sh`
- Automated setup script (`quick_setup.sh`)
- Chrome kiosk mode with comprehensive security flags
- Process monitoring with automatic Chrome restart
- Key binding security to prevent escape routes
- Parental Controls integration
- Admin emergency exit (Cmd+Shift+Q+Q)
- Comprehensive documentation suite
- Chrome updater elimination to prevent permission dialogs

### Features
- **Auto-login**: Configured kiosk user automatically logs in on boot
- **Instant startup**: KioskLauncher.app provides immediate Chrome launch
- **Self-monitoring**: Daemon checks Chrome every 10 seconds
- **Escape prevention**: Disables Cmd+Q, Cmd+Tab, and other escape routes
- **Simple Finder**: Restricts file system access
- **Configuration validation**: Built-in config checking

### Security
- System-level restrictions via Parental Controls
- Application-level Chrome security flags
- Admin-only system access with password protection

### Documentation
- Complete setup guide
- Troubleshooting guide with common solutions
- Technical reference (CLAUDE.md)
- Contributing guidelines

### Compatibility
- Mac OS X 10.6 Snow Leopard (specifically designed for this version)
- Chrome 49.0.2623.112 (last version supporting Snow Leopard)
- Tested on Intel iMacs (2006-2010)

### Known Issues
- Parental Controls must be configured manually after automated setup
- Some modern web technologies may not work in Chrome 49

---

## Future Releases

Future versions will be documented here following semantic versioning:
- MAJOR version for incompatible API changes
- MINOR version for backwards-compatible functionality additions
- PATCH version for backwards-compatible bug fixes

For detailed commit history, see the git log.