# RemoteUserAccountRemoverGUI

## Overview

This PowerShell script provides a graphical interface for managing local users on remote computers within a network. It is designed to streamline the administration of user accounts across multiple computers by enabling centralized user loading and deletion. Using this interface, administrators can connect to multiple remote computers, view a list of local users on each, and delete selected users if necessary.

### Key Features
- **Remote User Loading**: Retrieves the list of local users from each specified remote computer and displays them within a GUI.
- **User Selection and Deletion**: Allows for multi-selection of users to be deleted across remote machines in a single action.
- **Credential Management**: Prompts for administrator credentials to access and modify user accounts on remote systems.

## Requirements
- **PowerShell**: Must be run in an environment that supports PowerShell with access to Windows Presentation Foundation (WPF) libraries.
- **Admin Credentials**: Requires administrator credentials to connect to and modify users on remote computers.
- **List of Computers**: Update the path to the file containing the list of target computers in the `$filePath` variable.

## Usage

1. **Prepare Target Computers List**:
   - Ensure that the list of target computers is stored in a text file at `C:\path\to\your\computers.txt`.
   - Update the path if the file is stored elsewhere.

2. **Run the Script**:
   - Launch the script in PowerShell. The script will prompt for administrator credentials to access the remote systems.

3. **Use the GUI**:
   - **Load Users**: Click "Load Users" to retrieve and display local users on each remote computer.
   - **Select and Delete Users**: Choose users from the list and click "Delete Selected Users" to remove them from the specified computers.

## Script Interface

### Load Users Button
The "Load Users" button connects to each specified computer, retrieves local users, and displays them in scrollable lists.

### Delete Selected Users Button
The "Delete Selected Users" button removes selected users from the computers, with confirmation shown in the PowerShell console.

## Interface Preview

Here is an example of the interface layout, as seen in the GUI window:

<img src="/images/RemoteUserAccountRemoverGUI.png" alt="RemoteUserAccountRemoverGUI" width="500">

## Notes

- Ensure that remote computers allow PowerShell remoting and that the script is executed with sufficient permissions.
- For security, the script prompts for credentials upon each session initialization.
- Error messages are displayed in the PowerShell console if there are connection issues or permission errors.
