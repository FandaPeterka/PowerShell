# Remote User Log-Off GUI

## Overview

This PowerShell script provides a graphical user interface (GUI) for remotely logging off users on multiple computers within a network. Using the Windows Presentation Framework (WPF), this script allows administrators to view the current logged-in users across various computers and to select specific computers for logging off users. The interface includes options for selecting all computers or individually picking target computers for user log-off actions.

### Key Features
- **Remote User Detection**: Displays the currently logged-in user on each computer, using a simple checkbox list in the GUI.
- **Selective User Log-Off**: Allows administrators to log off users on selected computers by initiating remote sessions.
- **Select All Option**: Quickly selects all available computers, enabling mass log-off actions.
- **Credential Management**: Prompts the administrator for credentials necessary to connect to each computer and perform the log-off action.

## Requirements
- **PowerShell**: Run the script in a PowerShell environment with access to Windows Presentation Foundation (WPF) libraries.
- **Admin Credentials**: Requires administrator credentials for access to log off users on remote systems.
- **List of Computers**: Update the `$filePath` variable to point to the text file containing the list of target computers.

## Usage

1. **Prepare the Target Computers List**:
   - Ensure that the list of computers is stored in a text file at the path specified in `$filePath` (default: `C:\path\to\your\computers.txt`).
   - Adjust the path if the file is located elsewhere.

2. **Run the Script**:
   - Launch the script in PowerShell. The script will prompt for administrator credentials for remote access.

3. **Use the GUI**:
   - **Select Computers**: Use checkboxes to select specific computers for the log-off action or click "Select All" to choose all computers.
   - **Log Off Users**: Click the "Log Off Users" button to initiate the log-off process on the selected computers.

## Script Interface

### Select Computers to Log Off
Displays a list of computers with the currently logged-in user. This allows for individual selection of computers to target for log-off actions.

### Log Off Users Button
Initiates the log-off process on selected computers. A message confirms each user log-off in the PowerShell console.

## Interface Preview

Here’s an example of the interface layout in the GUI window:

![Log Off Users GUI](images/RemoteUserLogOffGUI.png)

## Notes

- Ensure that PowerShell Remoting is enabled on all target computers.
- The script requires sufficient permissions to log off users on remote systems.
- Error messages will appear in the PowerShell console for connection or permission-related issues.
