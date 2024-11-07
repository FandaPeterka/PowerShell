# LocalUserManagementGUI

## Overview

This PowerShell script provides a comprehensive graphical interface (GUI) for managing local user accounts on a Windows machine. Using tabs to organize features, this tool allows administrators to perform essential tasks such as creating and deleting users, managing group memberships, and updating user information.

### Features
- **Create User**: Add a new local user with specified details.
- **Delete User**: Select and delete multiple local users.
- **Group Membership**: View and modify a user’s group memberships.
- **User Information**: Edit a user’s full name and description, view created and last logon times, and update the password.

## Requirements
- **PowerShell Version**: This script requires PowerShell with access to the Windows Presentation Framework (WPF) libraries.
- **Permissions**: Administrator privileges are required to modify user accounts and group memberships.

## Usage

1. **Launch Script**:
   - Open PowerShell as an administrator.
   - Run the script to open the GUI.

2. **Using the Interface**:
   - **Create User**: Enter the username, full name, password, and select the permission level (User or Administrator). Click "Create User" to add the new account.
   - **Delete User**: Select users from the list and click "Delete Selected Users" to remove them.
   - **Group Membership**: Select a user, view current group memberships, and add or remove groups as needed. Click "Save Group Memberships" to apply changes.
   - **User Information**: Select a user to view their details. Update the full name, description, and optionally change the password. Click "Save Changes" to apply updates.

## Script Interface

### Create User Tab
This tab allows you to create a new local user. Enter the user details, including username, full name, and password, and select the permission level.

### Delete User Tab
The "Delete User" tab provides a list of local users. Select the users you want to delete and click "Delete Selected Users."

### Group Membership Tab
In this tab, select a user to view and edit their group memberships. Check or uncheck groups to modify memberships, then click "Save Group Memberships."

### User Information Tab
View and edit the selected user's full name and description. This tab also displays the user’s account creation and last logon times. Optionally, change the user’s password.

## Notes

- **Error Handling**: Any issues during user creation, deletion, or modification are displayed in a message box.
- **Interface Updates**: Changes to users or groups are immediately reflected in the interface.
- **Permissions**: Ensure PowerShell is run with administrator permissions to manage local users and groups effectively.

## Example 

<table>
  <tr>
    <td><img src="/images/LocalUserManagementGUI1.png" alt="LocalUserManagementGUI1" width="350"></td>
    <td><img src="/images/LocalUserManagementGUI2.png" alt="LocalUserManagementGUI2" width="350"></td>
    <td><img src="/images/LocalUserManagementGUI3.png" alt="LocalUserManagementGUI3" width="350"></td>
    <td><img src="/images/LocalUserManagementGUI4.png" alt="LocalUserManagementGUI4" width="350"></td>
  </tr>
</table>


*The GUI features tabs for each function, making user management more intuitive and efficient.*

---

This script is ideal for administrators who need a user-friendly way to manage local accounts and group memberships on Windows systems.
