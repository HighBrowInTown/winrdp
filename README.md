Here's the complete README with the global installation instructions included:

# WinRDP - Remote Desktop Connection Script

A lightweight bash script for establishing RDP connections to Windows machines using `xfreerdp` with enhanced features and background execution capabilities.

## Features

- **Interactive Input**: Prompts for connection parameters
- **Flexible Port Configuration**: Supports custom RDP ports (default: 3389)
- **Audio Support**: Optional audio and microphone redirection
- **Multi-Monitor Support**: Connect across multiple displays
- **Background Execution**: Runs RDP connections in the background using `nohup`
- **Auto-Reconnect**: Automatic reconnection with retry logic
- **Certificate Handling**: Automatically accepts untrusted certificates
- **System Logging**: Debug output via system logger
- **Performance Optimized**: Graphics acceleration and compression

## Prerequisites

- **Operating System**: Linux distribution with X11 or Wayland
- **Dependencies**:
  - `xfreerdp` (FreeRDP client)
  - `bash` (version 4.0+)
  - `logger` (for system logging)

### Installing Dependencies

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install freerdp2-x11
```

**RHEL/CentOS/Fedora:**
```bash
sudo dnf install freerdp
```

**Arch Linux:**
```bash
sudo pacman -S freerdp
```

## Installation

### Method 1: Local Installation
1. **Download the script:**
```bash
wget https://your-repo.com/winrdp
# or
curl -O https://your-repo.com/winrdp
```

2. **Make it executable:**
```bash
chmod +x winrdp
```

3. **Run from current directory:**
```bash
./winrdp
```

### Method 2: Global Installation (Recommended)

For system-wide access from any directory:

1. **Download and make executable:**
```bash
wget https://your-repo.com/winrdp
chmod +x winrdp
```

2. **Move to system binary directory:**
```bash
sudo mv winrdp /usr/local/bin/
```

3. **Verify installation:**
```bash
which winrdp
# Should output: /usr/local/bin/winrdp
```

4. **Test global access:**
```bash
# Now you can run from anywhere without ./
winrdp --help
```

### Alternative Global Installation Locations

If `/usr/local/bin` is not in your PATH, you can use:

```bash
# Option 1: User-specific (no sudo required)
mkdir -p ~/.local/bin
mv winrdp ~/.local/bin/
# Add to ~/.bashrc or ~/.zshrc: export PATH="$HOME/.local/bin:$PATH"

# Option 2: System-wide alternative
sudo mv winrdp /usr/bin/

# Option 3: Create symbolic link
sudo ln -s /path/to/winrdp /usr/local/bin/winrdp
```

### Verification

After global installation, you should be able to run:
```bash
# From any directory
cd /tmp
winrdp 192.168.1.100 username password

# Check version/help
winrdp --help
```

### Uninstallation

To remove the globally installed script:
```bash
sudo rm /usr/local/bin/winrdp
```

**Note**: `/usr/local/bin` is the standard location for user-installed executables and is typically included in the system PATH by default on most Linux distributions.

## Usage

### Basic Syntax
```bash
winrdp [IP[:PORT]] [USERNAME] [PASSWORD] [OPTIONS]
```

### Command-Line Options
- `--audio`: Enable audio and microphone redirection
- `--multimon`: Enable multi-monitor support
- `--verbose`: Enable debug logging to system logger

### Usage Examples

**Basic connection:**
```bash
winrdp 192.168.1.100 administrator password123
```

**Interactive mode (prompts for missing parameters):**
```bash
winrdp
```

**Custom port:**
```bash
winrdp 192.168.1.100:3390 user@domain.com password123
```

**With audio support:**
```bash
winrdp 192.168.1.100 username password --audio
```

**Multi-monitor with verbose logging:**
```bash
winrdp 192.168.1.100 username password --multimon --verbose
```

**Combination of options:**
```bash
winrdp 10.0.0.50:3391 admin@company.local MySecurePass123 --audio --multimon --verbose
```

## Configuration

The script uses the following xfreerdp parameters by default:
- Dynamic resolution adjustment
- Graphics acceleration (GFX)
- Clipboard sharing
- Auto-reconnect (3 retries)
- Certificate ignore
- Optimized compression

## Monitoring and Debugging

### Check Running Connections
```bash
ps aux | grep xfreerdp
```

### Monitor Debug Logs
```bash
# Real-time monitoring
sudo journalctl -t winrdp -f

# View recent logs
sudo journalctl -t winrdp --since "10 minutes ago"

# Alternative syslog monitoring
tail -f /var/log/syslog | grep winrdp
```

### Kill Active Connection
```bash
# Find the PID (shown when starting connection)
kill [PID]

# Or kill all xfreerdp processes
pkill xfreerdp
```

## Environment Variables

The script sets the following environment variables automatically:
- `DISPLAY`: Uses `:0` if not set
- `PATH`: Ensures standard binary locations are available

## Troubleshooting

### Common Issues

**1. xfreerdp not found**
```
ERROR: xfreerdp not found. Please install freerdp package.
```
**Solution**: Install FreeRDP using your distribution's package manager.

**2. Display connection issues**
```
Cannot connect to display
```
**Solution**: Ensure you're running from a graphical session and `DISPLAY` is set correctly.

**3. Connection refused**
```
Connection refused
```
**Solution**: 
- Verify the target IP/port
- Check if RDP is enabled on the target machine
- Verify firewall settings

**4. Authentication failures**
```
Authentication failure
```
**Solution**:
- Verify username/password
- Check domain requirements
- Ensure RDP permissions on target machine

### Debug Mode

Enable verbose logging to troubleshoot issues:
```bash
winrdp --verbose
```

Then monitor the logs:
```bash
sudo journalctl -t winrdp -f
```

## Security Considerations

- **Password Storage**: Passwords are passed as command-line arguments (visible in process lists)
- **Certificate Validation**: Script automatically accepts untrusted certificates
- **Network Security**: Uses standard RDP encryption

### Best Practices
- Use domain authentication when possible
- Run over VPN for external connections
- Consider using SSH tunnels for additional security
- Regularly update FreeRDP client

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/enhancement`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/enhancement`)
5. Create a Pull Request

## Support

For issues and questions:
- Check the [troubleshooting section](#troubleshooting)
- Review system logs with `--verbose` option
- Submit issues via GitHub Issues

## Changelog

### v1.0.0
- Initial release
- Basic RDP connection functionality
- Background execution with nohup
- Audio and multi-monitor support
- System logging integration

**Note**: This script is designed for legitimate system administration purposes. Ensure you have proper authorization before connecting to remote systems.