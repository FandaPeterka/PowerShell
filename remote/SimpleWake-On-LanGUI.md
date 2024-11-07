# SimpleWake-On-LanGUI

## Overview

This PowerShell script provides a graphical interface (GUI) to wake up Virtual Machines (VMs) by sending Wake-On-LAN (WOL) magic packets to specified MAC addresses. It reads VM names and MAC addresses from a CSV file, allowing administrators to select VMs to wake up from the list and verifying each VM's status post-wake-up.

### Key Features
- **CSV-Based VM List**: Reads VM names and MAC addresses from a specified CSV file for easy management.
- **Wake-On-LAN Support**: Sends "magic packets" to MAC addresses, initiating a power-on command for each selected VM.
- **Responsive VM Check**: Confirms if each VM is awake by pinging it after sending the WOL packet.
- **GUI Interface**: Displays a selection interface with checkboxes for each VM, providing a streamlined process.
- **Select All Option**: Allows for selecting all VMs at once with a single button.

## Requirements
- **PowerShell**: Script uses PowerShell and Windows Presentation Foundation (WPF) for the GUI.
- **Administrator Permissions**: Requires permissions to send network packets and to verify VM status.
- **CSV File**: A CSV file containing VM names and MAC addresses in the format specified below.

## CSV File Format

The input CSV file should be specified in the `filePath` variable and must have a format like this:

```csv
VM1,00-14-22-01-23-45
VM2,00-14-22-67-89-AB
```

Place each VM name and MAC address on a new line, separated by a comma, without headers.

## Usage Instructions

1. **Prepare the CSV File**:
   - Ensure that the CSV file is saved in the format above and update the `$filePath` variable in the script to point to the correct location.

2. **Run the Script**:
   - Open PowerShell as an administrator and execute the script.
   - You will be prompted for administrator credentials to confirm the VM status after wake-up.

3. **Use the GUI**:
   - Select individual VMs or click "Select All" to choose all VMs.
   - Click "Wake Up Selected VMs" to initiate the wake-up process. The PowerShell console will display the progress and results for each VM.

## Notes

- Ensure each VM supports Wake-On-LAN and has it enabled in its network adapter settings.
- Confirm the network environment supports broadcasting WOL packets.
- Status messages and errors will display in the PowerShell console, allowing troubleshooting if a VM does not wake up.

## Interface Preview

Here's a quick preview of what the GUI should look like:

![Wake-On-LAN VM GUI](images/WakeOnLanVMGui.png)

The interface includes:
- **Title Label**: Displays instructions for the user.
- **VM Selection**: Checkboxes for each VM, allowing targeted wake-up.
- **Select All Button**: A quick way to select all listed VMs.
- **Wake Up Button**: Starts the WOL process for the selected VMs.

## Troubleshooting

- **No Response from VM**: Check network settings on the VM and ensure it has WOL enabled.
- **Network Issues**: Verify network configuration allows broadcasting WOL packets.
- **Permissions**: Run PowerShell as administrator for full functionality.

This script simplifies the process of waking up multiple VMs and confirming their status in a straightforward, efficient GUI. For more details, refer to the script comments or consult your system administrator.
