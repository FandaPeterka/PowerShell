# Script Overview: Remote User Account Creation GUI

![Create User GUI](images/RemoteUserAccountCreatorGUI.png)

This PowerShell script provides a graphical user interface (GUI) for remotely creating user accounts on multiple target computers. The script reads a list of target computer names from a text file, prompts the user for their credentials, and enables the user to input information for a new account. It allows customization of account details such as username, full name, password, and permission level (User or Administrator).

## How It Works

1. **Load Computers List**: 
   The script reads the list of target computers from a specified text file. Each computer in the list will be displayed as a selectable checkbox in the GUI.

2. **Credential Prompt**:
   The script prompts the user to enter their credentials, which will be used to establish a remote session with each target computer.

3. **User Interface (GUI)**:
   The main GUI window is generated using .NET's PresentationFramework library and consists of input fields for:
   - Username
   - Full Name
   - Password (input hidden for security)
   - Permission Level (dropdown to select "User" or "Administrator")
   The GUI also includes a selectable list of computers, allowing the user to apply the new account creation on multiple computers at once.

4. **Account Creation**:
   When the "Create User" button is clicked, the script:
   - Connects to each selected target computer using a remote session.
   - Executes commands on each target computer to create a new local user with the specified details.
   - Adds the new user to either the "Users" or "Administrators" group, based on the chosen permission level.

5. **Session Management**:
   The script securely manages each session, establishing and closing connections to each computer individually to ensure security.

## Important Notes
- **Path Configuration**: Update `$filePath` to point to your list of computers.
- **Permissions**: Ensure the script is run with appropriate permissions to create users on remote computers.
- **GUI Customization**: This GUI is flexible and can be customized for other administrative tasks if desired.

This script is designed to simplify the remote user management process, making it more accessible to administrators through an intuitive GUI.
