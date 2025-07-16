# Contributing to Snow Leopard Kiosk System

Thank you for your interest in contributing to the Snow Leopard Kiosk System! This project helps preserve the functionality of older Mac hardware by providing a secure kiosk solution.

## 🤝 How to Contribute

### Reporting Issues

1. **Check existing issues** to avoid duplicates
2. **Use issue templates** when available
3. **Include system information**:
   - Mac OS X version (must be 10.6.x)
   - Hardware model
   - Chrome version (should be 49.0.2623.112)
   - Relevant error messages or logs

### Suggesting Features

1. **Open a discussion** before implementing major features
2. **Consider Snow Leopard limitations** - features must work on 10.6
3. **Focus on reliability** over complexity

### Code Contributions

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature-name`
3. **Make your changes**
4. **Test thoroughly** on actual Snow Leopard hardware if possible
5. **Submit a pull request**

## 📋 Development Guidelines

### Code Style

- **Bash scripts**: Use ShellCheck for validation
- **Clear variable names**: Self-documenting code
- **Comments**: Explain *why*, not just *what*
- **Error handling**: Always check for failures
- **Compatibility**: Test on Snow Leopard (10.6.8)

### Testing Requirements

Before submitting:

1. **Test the complete setup** from scratch
2. **Verify all security features** work as expected
3. **Check Chrome launches** in kiosk mode
4. **Confirm auto-restart** functionality
5. **Test emergency exit** procedures

### Documentation

- **Update relevant docs** when changing functionality
- **Add examples** for new features
- **Keep troubleshooting guide** current
- **Document any new dependencies**

## 🏗️ Development Setup

### Setting Up Development Environment

1. **Snow Leopard VM** (if no hardware available):
   ```bash
   # VirtualBox or VMware can run Snow Leopard
   # Requires legitimate Mac OS X 10.6 license
   ```

2. **Chrome 49.0.2623.112**:
   - Download from: https://google-chrome.en.uptodown.com/mac/versions
   - This is the last version supporting Snow Leopard

3. **Testing checklist**:
   - [ ] Clean Snow Leopard installation
   - [ ] Admin account for setup
   - [ ] Test user account for kiosk
   - [ ] Network connectivity

### Key Areas for Contribution

- **Hardware compatibility**: Testing on different Mac models
- **Security improvements**: Enhanced escape prevention
- **Configuration options**: More flexible setup
- **Documentation**: Tutorials, guides, translations
- **Bug fixes**: Especially edge cases

## 🔒 Security Considerations

When contributing security-related code:

1. **Maintain the three-layer approach**: System, Application, Network
2. **Don't introduce new vulnerabilities**
3. **Document security implications**
4. **Test escape prevention thoroughly**
5. **Consider physical access scenarios**

## 📝 Pull Request Process

1. **Update documentation** for any changes
2. **Add to CHANGELOG.md** if applicable
3. **Ensure all tests pass**
4. **Request review** from maintainers
5. **Be responsive** to feedback

### PR Title Format
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation only
- `refactor:` Code restructuring
- `test:` Test additions/changes

## 🌟 Code of Conduct

- **Be respectful** and constructive
- **Welcome newcomers** and help them contribute
- **Focus on the issue**, not the person
- **Respect Snow Leopard** as a legitimate platform

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Recognition

Contributors will be recognized in:
- Git history
- CHANGELOG.md (for significant contributions)
- Special mentions for major features

## 💡 Tips for Success

1. **Start small**: Fix a typo or improve documentation
2. **Ask questions**: Use discussions for clarification
3. **Test on real hardware**: VMs can behave differently
4. **Preserve compatibility**: Don't break existing setups
5. **Think about edge cases**: Older hardware has quirks

Thank you for helping preserve and improve kiosk functionality for Snow Leopard systems!