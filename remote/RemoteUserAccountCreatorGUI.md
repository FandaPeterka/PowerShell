# RemoteUserAccountCreatorGUI

## Overview

This PowerShell script provides a graphical interface for remotely creating local user accounts on multiple target computers. It simplifies the process of setting up new user accounts across a network, allowing administrators to input necessary account details and apply them to selected computers. The interface also includes options for specifying permission levels for each user.

### Key Features
- **Remote User Creation**: Enables administrators to create user accounts on multiple remote computers simultaneously.
- **Customizable User Details**: Input fields for username, full name, password, and permission level (User or Administrator).
- **Credential Management**: Prompts for secure administrator credentials to authorize account creation on remote systems.

## Requirements
- **PowerShell**: Ensure that PowerShell is installed with access to Windows Presentation Foundation (WPF) libraries.
- **Admin Credentials**: Administrator credentials are required to create user accounts on remote computers.
- **Computer List File**: Update the `$filePath` variable to point to a text file containing a list of target computers (e.g., `C:\path\to\your\computers.txt`).

## Usage

1. **Prepare Target Computers List**:
   - Ensure that the target computers are listed in a text file located at the path specified in `$filePath`. Adjust the path if necessary.

2. **Run the Script**:
   - Open PowerShell and execute the script. A credential prompt will appear, allowing administrators to provide credentials for remote access.

3. **Use the GUI**:
   - **Enter User Details**: Fill in the required fields such as username, full name, password, and permission level.
   - **Select Target Computers**: Use the checkboxes to select the computers on which to create the new account.
   - **Create User**: Click "Create User" to apply the account settings to each selected computer.

## Script Interface

### Create User Button
The "Create User" button connects to each selected computer, applies the specified user details, and assigns the chosen permission level.

### Permission Level Dropdown
A dropdown menu to select either "User" or "Administrator" for the new account, determining the user's access rights on each target computer.

## Interface Preview

Here is a sample layout of the interface displayed in the GUI:

![Create User GUI](/images/RemoteUserAccountCreatorGUI.png)

## Notes

- Ensure PowerShell remoting is enabled on all target computers.
- The script will prompt for credentials to establish each remote session securely.
- Any connection errors or permission issues will be displayed in the PowerShell console for troubleshooting.
