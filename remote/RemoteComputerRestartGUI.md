# RemoteComputerRestartGUI

## Overview

This PowerShell script provides a graphical user interface (GUI) for managing remote restarts across multiple computers. It allows administrators to select computers from a list and initiate a restart on each selected machine, streamlining network maintenance tasks. The interface is built using Windows Presentation Foundation (WPF) elements and is designed for quick and easy use.

### Key Features
- **Remote Computer Selection**: Loads a list of target computers from a specified file, displaying each as a selectable option.
- **Select All Functionality**: Includes a "Select All" button to select all computers in the list.
- **Remote Restart Execution**: Initiates a remote restart for each selected computer, using PowerShell remoting.
- **Credential Management**: Prompts the administrator for credentials required to connect to each target computer.

## Requirements
- **PowerShell**: Compatible with environments supporting PowerShell and Windows Presentation Foundation (WPF).
- **Admin Permissions**: Requires administrator credentials to initiate restarts on remote systems.
- **Computer List File**: Ensure the path in the `$filePath` variable points to a text file with the list of target computers (e.g., `C:\path\to\your\computers.txt`).

## Usage

1. **Prepare Target Computers List**:
   - Create a text file with each computer's name or IP address, one per line, and save it to the path specified in `$filePath`.
   - Update `$filePath` in the script if needed.

2. **Run the Script**:
   - Open PowerShell and run the script. You will be prompted for administrator credentials to access the remote systems.

3. **Use the GUI**:
   - **Select Computers**: Use the checkboxes to select individual computers for restart. Alternatively, click "Select All" to choose all computers.
   - **Initiate Restart**: Click "Restart Selected Computers" to restart each chosen computer. Progress and any errors will display in the PowerShell console.

## Script Interface

### GUI Elements

- **Title Label**: Displays instructions at the top of the interface.
- **Computer Selection**: Checkboxes for each computer, enabling selection for targeted restarts.
- **Select All Button**: Quickly selects all available computers in the list.
- **Restart Button**: Restarts selected computers with the click of a button.

## Interface Preview

<img src="/images/RemoteComputerRestartGUI.png" alt="RemoteComputerRestartGUI" width="300">

## Notes

- Ensure that PowerShell remoting is enabled on all target computers.
- The script must be run with appropriate permissions for remote restart capabilities.
- Error messages and progress updates will appear in the PowerShell console during execution.
