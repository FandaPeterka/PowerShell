# RemoteComputerShutdownGUI

## Overview

This PowerShell script provides a graphical user interface (GUI) for managing remote shutdowns across multiple computers within a network. It allows administrators to select computers from a list and initiate a shutdown on each selected machine, making network management more efficient. The interface is built using Windows Presentation Foundation (WPF) elements for ease of use.

### Key Features
- **Remote Computer Selection**: Loads a list of target computers from a specified file, displaying each as a selectable option in the GUI.
- **Select All Functionality**: Includes a "Select All" button to easily select all computers in the list.
- **Remote Shutdown Execution**: Initiates a remote shutdown for each selected computer, utilizing PowerShell remoting.
- **Credential Management**: Prompts the administrator for credentials required to connect to each target computer securely.

## Requirements
- **PowerShell**: Compatible with PowerShell environments supporting Windows Presentation Foundation (WPF).
- **Admin Permissions**: Requires administrator credentials to initiate shutdowns on remote systems.
- **Computer List File**: Ensure the path in the `$filePath` variable points to a text file containing the list of target computers (e.g., `C:\path\to\your\computers.txt`).

## Usage

1. **Prepare Target Computers List**:
   - Create a text file listing each computer's name or IP address, one per line, and save it to the location specified in `$filePath`.
   - Update the `$filePath` in the script if necessary to match the location of your file.

2. **Run the Script**:
   - Open PowerShell and execute the script. You will be prompted for administrator credentials to access the remote computers.

3. **Use the GUI**:
   - **Select Computers**: Use the checkboxes to choose individual computers for shutdown, or use the "Select All" button to select all computers.
   - **Initiate Shutdown**: Click "Shutdown Selected Computers" to shut down each chosen computer. Progress and any errors will be displayed in the PowerShell console.

## Script Interface

### GUI Elements

- **Title Label**: Displays instructions at the top of the interface.
- **Computer Selection**: Provides checkboxes for each computer, allowing targeted shutdowns.
- **Select All Button**: Quickly selects all available computers in the list.
- **Shutdown Button**: Initiates shutdowns on selected computers with a single click.

## Interface Preview

![Remote Computer Shutdown GUI](images/RemoteComputerShutdownGUI.png)

## Notes

- PowerShell remoting must be enabled on all target computers for the script to work.
- The script should be run with the necessary permissions to initiate shutdowns on remote systems.
- Error messages and updates on progress will appear in the PowerShell console during execution.
