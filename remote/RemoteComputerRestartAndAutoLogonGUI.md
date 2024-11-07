# Remote Computer Restart and Auto Logon GUI

## Overview

This PowerShell script provides a graphical interface for selecting and restarting multiple remote computers with the additional capability of setting up automatic logon for specific user accounts. Using this tool, administrators can streamline remote restart and logon configuration processes, ideal for environments requiring multiple devices to auto logon after a reboot.

### Key Features

- **Remote Computer Selection**: Loads a list of computers from a specified text file and displays each as an option to select for restart and auto logon.
- **User-Specific Auto Logon**: Allows for user selection on each computer to configure auto logon credentials.
- **Password Options**: Supports either a common password for all selected users or unique passwords per user.
- **Credential Management**: Prompts for administrator credentials required to connect and configure each target computer.
- **WPF GUI**: Built using Windows Presentation Foundation (WPF) elements to provide an intuitive and accessible interface.

## Requirements

- **PowerShell**: Ensure PowerShell with support for Windows Presentation Foundation (WPF) is installed.
- **Administrator Permissions**: Admin privileges are required to initiate remote sessions and configure auto logon.
- **Computer List File**: The script reads target computers from a text file. Update the `$filePath` variable in the script to point to your file (e.g., `C:\PS\computers.txt`).
- **PowerShell Remoting**: Enable PowerShell remoting on all target computers for remote configuration.

## Usage

1. **Prepare the Computers List**:
   - Create a text file listing the names or IP addresses of each computer, one per line.
   - Update `$filePath` in the script to the path of this file.

2. **Run the Script**:
   - Open PowerShell and run the script. You will be prompted to enter administrator credentials for remote connections.

3. **Using the GUI**:
   - **Load Users**: Click "Load Users" to retrieve and display local users on each remote computer.
   - **Select Users and Set Auto Logon**:
     - Use checkboxes to select users on each computer for auto logon.
     - Enter individual passwords or choose the "Use same password for all users" option.
   - **Restart Computers**: Click "Restart and Auto Logon" to apply the auto logon settings and restart each selected computer.

## Script Interface

### GUI Elements

- **Load Users Button**: Loads local user accounts from each computer for selection.
- **User Selection**: Checkboxes for each user on each computer to select for auto logon configuration.
- **Password Options**: Enter passwords for selected users or choose a common password for all.
- **Restart Button**: Restarts selected computers and configures auto logon.

## Interface Preview

![Restart and Auto Logon GUI](images/RestartAutoLogonGUI.png)

## Notes

- Ensure that PowerShell remoting is enabled on all target computers to facilitate remote operations.
- Administrator credentials are required to initiate the necessary PowerShell sessions.
- Errors and status messages will appear in the PowerShell console, providing feedback on each restart and auto logon configuration.

## Security Considerations

- **Auto Logon**: Auto logon credentials are stored in the registry of each target computer, which may pose a security risk. Ensure that these settings comply with your organization's security policies.
- **Password Management**: Use secure and unique passwords where possible, especially if configuring multiple accounts for auto logon.

---

Run this script with proper permissions and ensure that target computers have the required PowerShell remoting configuration for seamless operation.
