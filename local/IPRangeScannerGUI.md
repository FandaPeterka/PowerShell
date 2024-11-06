# IPRangeScannerGUI

This PowerShell script provides a graphical user interface (GUI) for scanning a specified range of IP addresses. Administrators can use it to detect active devices within a given IP range, identify their hostnames, and log the results. This tool is designed for network management and device discovery.

## Key Features
- **IP Range Scanning**: Scans a specified range of IP addresses to detect active devices.
- **Hostname Resolution**: Attempts to resolve the hostname for each detected IP.
- **Logging**: Records all results in a log file located in `C:\path\to\your\logs`.
- **GUI for IP Range Input**: Provides input fields for the start and end IP addresses and a button to start the scan.

## Requirements
- **PowerShell**: Requires PowerShell with access to Windows Presentation Foundation (WPF) libraries for GUI functionality.
- **Network Permissions**: Ensure that you have the necessary permissions and firewall settings to connect to the IP addresses in the specified range.

## Usage

1. **Set IP Range**:
   - Input the desired start and end IP addresses in the GUI fields.

2. **Run the Script**:
   - Click "Start Scanning" to begin the scan. The script will attempt to ping each IP in the specified range and resolve the hostname of any responding devices.

3. **Review Results**:
   - Results will be displayed in the PowerShell console during the scan. A complete log of all found devices will be saved to `C:\path\to\your\logs` upon completion or application exit.

## Script Interface

### Start IP Address
The field to input the beginning of the IP range to scan.

### End IP Address
The field to input the end of the IP range to scan.

### Start Scanning Button
Initiates the scan across the specified IP range.

## Example Output

The PowerShell console will display:
- `IP Address: <IP> - Hostname: <hostname>` for each active device found.
- `No response from IP Address: <IP>` if no device is detected at an IP.

## Logs
Logs are created in the format `ScanLog_yyyyMMdd_HHmmss.txt` in the `C:\path\to\your\logs` directory, detailing the IP addresses and hostnames of all detected devices.

## Important Notes
- **Log Directory**: Ensure `C:\path\to\your\logs` has write permissions.
- **IP Range Limitations**: Large IP ranges can take significant time; adjust based on network size and need.

## Interface Preview

Below is an example layout of the GUI:

![IP Range Scanner GUI](images/IPRangeScannerGUI.png)
