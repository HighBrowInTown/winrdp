Here's the updated README reflecting all the latest enhancements to the WinRDP script:

# WinRDP - Remote Desktop Connection Script

A robust bash script for establishing RDP connections to Windows machines using `xfreerdp` with comprehensive input validation, retry logic, and enhanced error handling.

## Features

- **Comprehensive Input Validation**: Validates IP addresses, hostnames, port numbers, and connectivity
- **Unified Retry Logic**: Re-enter all inputs when any validation fails for consistent user experience
- **Host Connectivity Testing**: Multi-method connectivity verification (netcat, telnet, bash TCP)
- **Credential Pre-validation**: Tests RDP authentication before launching GUI
- **Interactive Input**: Prompts for missing connection parameters
- **Flexible Port Configuration**: Supports custom RDP ports (default: 3389)
- **Audio Support**: Optional audio and microphone redirection
- **Multi-Monitor Support**: Connect across multiple displays
- **Background Execution**: Runs RDP connections in the background using `nohup`
- **Auto-Reconnect**: Automatic reconnection with retry logic
- **Certificate Handling**: Automatically accepts untrusted certificates
- **System Logging**: Debug output via system logger
- **Performance Optimized**: Graphics acceleration and compression
- **Help System**: Built-in help with usage examples

## Prerequisites

- **Operating System**: Linux distribution with X11 or Wayland
- **Dependencies**:
  - `xfreerdp` (FreeRDP client)
  - `bash` (version 4.0+)
  - `logger` (for system logging)
  - `nc` (netcat) or `telnet` (for connectivity testing - optional but recommended)

### Installing Dependencies

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install freerdp2-x11 netcat-openbsd
```

**RHEL/CentOS/Fedora:**
```bash
sudo dnf install freerdp netcat
```

**Arch Linux:**
```bash
sudo pacman -S freerdp gnu-netcat
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

# Check help
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
- `--help, -h`: Show help message and exit

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

**Get help:**
```bash
winrdp --help
```

## Input Validation & Error Handling

The script performs comprehensive validation of all inputs:

### **Host Validation**
- **IP Address Format**: Validates IPv4 format and octet ranges (0-255)
- **Hostname Format**: Validates FQDN format and length restrictions
- **Port Range**: Ensures ports are within valid range (1-65535)
- **Connectivity Testing**: Verifies host is reachable on specified port

### **Credential Validation**
- **Pre-connection Testing**: Tests authentication before launching GUI
- **Timeout Protection**: 15-second timeout for credential testing

### **Retry Logic**
- **Unified Re-entry**: Any validation failure requires re-entering ALL inputs
- **Maximum Attempts**: 3 attempts before giving up
- **Clear Error Messages**: Detailed feedback with troubleshooting guidance

### **Example Error Scenarios**

**Invalid IP Address:**
```bash
$ winrdp 999.999.999.999 admin password
ERROR: Invalid IP address or hostname format: 999.999.999.999
Input validation failed. (Attempt 2/3)
Please re-enter all connection details:

Enter destination IP/hostname (or IP:PORT): 192.168.1.100
Enter username: admin
Enter password: [hidden]
```

**Unreachable Host:**
```bash
$ winrdp 192.168.1.99 admin password
ERROR: Cannot connect to 192.168.1.99:3389
  - Check if the host is reachable
  - Verify the IP address/hostname is correct
  - Ensure RDP service is running on port 3389
```

**Authentication Failure:**
```bash
$ winrdp 192.168.1.100 wronguser password
ERROR: Authentication failed with provided credentials
Input validation failed. (Attempt 2/3)
Please re-enter all connection details:
```

## Configuration

The script uses the following xfreerdp parameters by default:
- Dynamic resolution adjustment
- Graphics acceleration (GFX with progressive and small cache)
- Clipboard sharing
- Auto-reconnect (3 retries)
- Certificate ignore
- Optimized compression (level 2)
- Disabled themes and wallpaper for performance

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
ERROR: Cannot connect to [host]:[port]
```
**Solution**: 
- Verify the target IP/hostname and port
- Check if RDP is enabled on the target machine
- Verify firewall settings
- Ensure the host is reachable

**4. Authentication failures**
```
ERROR: Authentication failed with provided credentials
```
**Solution**:
- Verify username/password are correct
- Check domain requirements (use domain\username or user@domain format)
- Ensure RDP permissions are granted on target machine
- Verify account is not locked or disabled

**5. Invalid input formats**
```
ERROR: Invalid IP address or hostname format
ERROR: Invalid port number (must be 1-65535)
```
**Solution**: Follow the format guidelines and retry with correct input.

### Debug Mode

Enable verbose logging to troubleshoot issues:
```bash
winrdp --verbose
```

Then monitor the logs:
```bash
sudo journalctl -t winrdp -f
```

### Connectivity Testing Tools

The script automatically detects and uses available connectivity testing tools:
- **netcat (nc)**: Primary method - fast and reliable
- **telnet**: Fallback method if netcat unavailable
- **bash TCP redirection**: Built-in fallback (always available)

Install recommended tools:
```bash
# Ubuntu/Debian
sudo apt install netcat-openbsd telnet

# RHEL/Fedora
sudo dnf install netcat telnet

# Arch Linux
sudo pacman -S gnu-netcat inetutils
```

## Security Considerations

- **Password Visibility**: Passwords passed as command-line arguments may be visible in process lists
- **Certificate Validation**: Script automatically accepts untrusted certificates
- **Network Security**: Uses standard RDP encryption
- **Credential Testing**: Pre-validates credentials with minimal exposure

### Best Practices
- Use domain authentication when possible
- Run over VPN for external connections
- Consider using SSH tunnels for additional security layer
- Regularly update FreeRDP client
- Use strong passwords and enable account lockout policies
- Monitor connection logs for suspicious activity

## Performance Optimization

The script includes several performance optimizations:
- **Graphics Acceleration**: GFX with progressive rendering
- **Compression**: Level 2 compression for optimal balance
- **Resource Management**: Disabled themes and wallpaper
- **Small Cache**: Optimized for low-latency connections
- **Dynamic Resolution**: Automatic resolution adjustment

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
- Include debug logs when reporting problems

## Changelog

### v2.0.0
- Added unified retry logic requiring complete input re-entry
- Added comprehensive input validation (IP, hostname, port, connectivity)
- Added credential pre-validation before GUI launch
- Added host connectivity testing with multiple fallback methods
- Enhanced error messages with troubleshooting guidance
- Added help system with usage examples
- Improved debug logging and system integration
- Replaced script self-calling with direct xfreerdp execution

### v1.0.0
- Initial release
- Basic RDP connection functionality
- Background execution with nohup
- Audio and multi-monitor support
- System logging integration

**Note**: This script is designed for legitimate system administration purposes. Ensure you have proper authorization before connecting to remote systems.