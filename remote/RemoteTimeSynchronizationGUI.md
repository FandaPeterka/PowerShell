# RemoteTimeSynchronizationGUI

## Overview

This PowerShell script provides a graphical interface to set the same date and time on multiple remote computers. The script reads computer names from a text file, prompts the user to enter the desired date and time, and applies these settings to all listed computers. It automates time synchronization across a network, which can be useful in scenarios where consistent time settings are critical.

### Key Features
- **Graphical Date/Time Input**: Uses a GUI to input the desired date and time settings.
- **Automated Time Synchronization**: Applies specified date and time settings across multiple computers in one action.
- **Credential Management**: Prompts for administrator credentials for connecting to remote computers.
- **Session Handling**: Creates, manages, and closes sessions with each target computer for secure time-setting operations.

## Requirements
- **PowerShell**: Must be run in an environment that supports PowerShell with access to Windows Presentation Foundation (WPF) libraries.
- **Admin Credentials**: Requires administrator credentials to access and modify settings on remote computers.
- **Remote Computers List**: Ensure the list of target computers is stored in a text file specified by `$computerListPath`.

## Usage

1. **Prepare Target Computers List**:
   - Save the names of target computers in a text file at the path specified by `$computerListPath` (default: `C:\path\to\your\computers.txt`).
   - Update the path in the script if your file is stored elsewhere.

2. **Run the Script**:
   - Execute the script in PowerShell. You will be prompted to enter credentials for remote access.

3. **Use the GUI**:
   - **Enter Date and Time**: Use the GUI to specify the desired date and time for synchronization.
   - **Apply Time Settings**: The script will then set the specified time on each listed computer.

## Notes

- **Error Handling**: The script logs success or failure for each target computer, providing feedback for successful or failed connections and actions.
- **Session Management**: All sessions are securely created and closed with each target computer to ensure no unauthorized access remains.
- **Administrator Permissions**: Administrator-level access is required on each target machine for time-setting operations.

## Interface Preview

Here is an example of the interface layout, as seen in the GUI window:

<img src="/images/RemoteTimeSynchronizationGUI.png" alt="RemoteTimeSynchronizationGUI" width="300">

## Important Considerations
- Ensure that each remote computer allows PowerShell remoting and that the script is executed with adequate permissions.
- The script requires a valid date and time format; otherwise, it will prompt an error message.

This tool streamlines the time synchronization process, making it accessible and efficient for network administrators.
