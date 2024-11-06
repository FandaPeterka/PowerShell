# This PowerShell script provides a User Management GUI for local accounts on a Windows machine.
# It allows administrators to create, delete, and manage user accounts, group memberships, and user information,
# all through a user-friendly graphical interface built with Windows Presentation Foundation (WPF).

# Key Features:
# - **Create User**: Enables the creation of a new local user account with specified details (username, full name, password).
# - **Delete User**: Allows selection and deletion of multiple local users.
# - **Group Membership**: Displays current group memberships of a selected user, allowing for modification.
# - **User Information**: Allows administrators to edit user details like full name and description, view the creation and last logon times, and update the password.

# Notes:
# - **Administrative Permissions**: This script requires PowerShell to be run with administrator privileges to modify local user accounts and groups.
# - **Dependencies**: Ensure that PowerShell can access WPF (Windows Presentation Framework) libraries for the graphical interface.
# - **Error Handling**: Errors and exceptions are displayed via message boxes for ease of troubleshooting.

# Usage:
# 1. Run the script in an elevated PowerShell session to launch the GUI.
# 2. Use the provided tabs to manage user accounts:
#    - "Create User" tab to add new users.
#    - "Delete User" tab to remove selected users.
#    - "Group Membership" tab to view and adjust group memberships for a selected user.
#    - "User Information" tab to view or modify user information, including changing the password.
#
# This tool is ideal for system administrators seeking an efficient, GUI-based method for managing local users and groups on Windows systems.

Add-Type -AssemblyName PresentationFramework

function GetUserGroupMemberships {
    param (
        [string]$username
    )
    $userGroups = Get-LocalGroup | Where-Object {
        (Get-LocalGroupMember -Group $_.Name | ForEach-Object { $_.Name }) -contains $username
    }
    return $userGroups
}

# Create the main window
$window = New-Object System.Windows.Window
$window.Title = "User Management"
$window.Width = 800
$window.Height = 600
$window.WindowStartupLocation = "CenterScreen"
$window.Background = [System.Windows.Media.Brushes]::LightGray
$window.SizeToContent = "WidthAndHeight"
$window.ResizeMode = "CanResize"

# Create a TabControl
$tabControl = New-Object System.Windows.Controls.TabControl

# Create TabItems for "Create User", "Delete User", "Group Membership", and "User Information"
$createUserTab = New-Object System.Windows.Controls.TabItem
$createUserTab.Header = "Create User"

$deleteUserTab = New-Object System.Windows.Controls.TabItem
$deleteUserTab.Header = "Delete User"

$groupMembershipTab = New-Object System.Windows.Controls.TabItem
$groupMembershipTab.Header = "Group Membership"

$userInfoTab = New-Object System.Windows.Controls.TabItem
$userInfoTab.Header = "User Information"

$tabControl.Items.Add($createUserTab)
$tabControl.Items.Add($deleteUserTab)
$tabControl.Items.Add($groupMembershipTab)
$tabControl.Items.Add($userInfoTab)
$window.Content = $tabControl

### Create User Tab ###
$createGrid = New-Object System.Windows.Controls.Grid
$createGrid.Margin = "10"
$createUserTab.Content = $createGrid

# Define grid rows and columns
for ($i = 0; $i -lt 6; $i++) {
    $createGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
}
for ($j = 0; $j -lt 2; $j++) {
    $createGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
}

# Add a title label
$createTitleLabel = New-Object System.Windows.Controls.Label
$createTitleLabel.Content = "Create New Local User"
$createTitleLabel.FontSize = 18
$createTitleLabel.FontWeight = "Bold"
$createTitleLabel.HorizontalAlignment = "Center"
$createTitleLabel.Margin = "0,0,0,10"
[System.Windows.Controls.Grid]::SetRow($createTitleLabel, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($createTitleLabel, 2)
$createGrid.Children.Add($createTitleLabel)

# Create labels and textboxes for username and password
$createUsernameLabel = New-Object System.Windows.Controls.Label
$createUsernameLabel.Content = "Username:"
$createUsernameLabel.VerticalAlignment = "Center"
$createUsernameLabel.HorizontalAlignment = "Right"
$createUsernameLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($createUsernameLabel, 1)
[System.Windows.Controls.Grid]::SetColumn($createUsernameLabel, 0)
$createGrid.Children.Add($createUsernameLabel)

$createUsernameTextBox = New-Object System.Windows.Controls.TextBox
$createUsernameTextBox.Margin = "0,0,0,10"
$createUsernameTextBox.Width = 200
[System.Windows.Controls.Grid]::SetRow($createUsernameTextBox, 1)
[System.Windows.Controls.Grid]::SetColumn($createUsernameTextBox, 1)
$createGrid.Children.Add($createUsernameTextBox)

$createFullnameLabel = New-Object System.Windows.Controls.Label
$createFullnameLabel.Content = "Full Name:"
$createFullnameLabel.VerticalAlignment = "Center"
$createFullnameLabel.HorizontalAlignment = "Right"
$createFullnameLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($createFullnameLabel, 2)
[System.Windows.Controls.Grid]::SetColumn($createFullnameLabel, 0)
$createGrid.Children.Add($createFullnameLabel)

$createFullnameTextBox = New-Object System.Windows.Controls.TextBox
$createFullnameTextBox.Margin = "0,0,0,10"
$createFullnameTextBox.Width = 200
[System.Windows.Controls.Grid]::SetRow($createFullnameTextBox, 2)
[System.Windows.Controls.Grid]::SetColumn($createFullnameTextBox, 1)
$createGrid.Children.Add($createFullnameTextBox)

$createPasswordLabel = New-Object System.Windows.Controls.Label
$createPasswordLabel.Content = "Password:"
$createPasswordLabel.VerticalAlignment = "Center"
$createPasswordLabel.HorizontalAlignment = "Right"
$createPasswordLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($createPasswordLabel, 3)
[System.Windows.Controls.Grid]::SetColumn($createPasswordLabel, 0)
$createGrid.Children.Add($createPasswordLabel)

$createPasswordTextBox = New-Object System.Windows.Controls.PasswordBox
$createPasswordTextBox.Margin = "0,0,0,10"
$createPasswordTextBox.Width = 200
[System.Windows.Controls.Grid]::SetRow($createPasswordTextBox, 3)
[System.Windows.Controls.Grid]::SetColumn($createPasswordTextBox, 1)
$createGrid.Children.Add($createPasswordTextBox)

# Create a label and combobox for permissions
$createPermissionLabel = New-Object System.Windows.Controls.Label
$createPermissionLabel.Content = "Permission:"
$createPermissionLabel.VerticalAlignment = "Center"
$createPermissionLabel.HorizontalAlignment = "Right"
$createPermissionLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($createPermissionLabel, 4)
[System.Windows.Controls.Grid]::SetColumn($createPermissionLabel, 0)
$createGrid.Children.Add($createPermissionLabel)

$createPermissionComboBox = New-Object System.Windows.Controls.ComboBox
$createPermissionComboBox.Margin = "0,0,0,10"
$createPermissionComboBox.Width = 200
$createPermissionComboBox.Items.Add("User")
$createPermissionComboBox.Items.Add("Administrator")
[System.Windows.Controls.Grid]::SetRow($createPermissionComboBox, 4)
[System.Windows.Controls.Grid]::SetColumn($createPermissionComboBox, 1)
$createGrid.Children.Add($createPermissionComboBox)

# Create a button to create the user
$createButton = New-Object System.Windows.Controls.Button
$createButton.Content = "Create User"
$createButton.Width = 150
$createButton.Height = 30
$createButton.Margin = "0,20,0,0"
$createButton.Background = [System.Windows.Media.Brushes]::LightSteelBlue
$createButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($createButton, 5)
[System.Windows.Controls.Grid]::SetColumnSpan($createButton, 2)
$createGrid.Children.Add($createButton)

# Event handler for the button click
$createButton.Add_Click({
    $newUsername = $createUsernameTextBox.Text
    $newFullName = $createFullnameTextBox.Text
    $newPassword = $createPasswordTextBox.Password
    $securePassword = ConvertTo-SecureString $newPassword -AsPlainText -Force
    $permission = $createPermissionComboBox.SelectedItem

    try {
        # Create a new local user
        New-LocalUser -Name $newUsername -Password $securePassword -FullName $newFullName -Description "User account for $newFullName" -AccountNeverExpires

        Start-Sleep -Seconds 2 # Add a delay to ensure the user is created

        # Add the user to the appropriate group based on selected permission
        if ($permission -eq "Administrator") {
            Add-LocalGroupMember -Group "Administrators" -Member $newUsername -ErrorAction Stop
        } else {
            Add-LocalGroupMember -Group "Users" -Member $newUsername -ErrorAction Stop
        }

        [System.Windows.MessageBox]::Show("New user $newUsername has been created.", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        UpdateUserLists
    } catch {
        [System.Windows.MessageBox]::Show("Failed to create user $newUsername. Error: $($_.Exception.Message)", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }

    $createUsernameTextBox.Clear()
    $createFullnameTextBox.Clear()
    $createPasswordTextBox.Clear()
    $createPermissionComboBox.SelectedIndex = -1
})

### Delete User Tab ###
$deleteGrid = New-Object System.Windows.Controls.Grid
$deleteGrid.Margin = "10"
$deleteUserTab.Content = $deleteGrid

# Define grid rows and columns
for ($i = 0; $i -lt 5; $i++) {
    $deleteGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
}
for ($j = 0; $j -lt 2; $j++) {
   $deleteGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
}

# Add a title label
$deleteTitleLabel = New-Object System.Windows.Controls.Label
$deleteTitleLabel.Content = "Delete Local User"
$deleteTitleLabel.FontSize = 18
$deleteTitleLabel.FontWeight = "Bold"
$deleteTitleLabel.HorizontalAlignment = "Center"
$deleteTitleLabel.Margin = "0,0,0,10"
[System.Windows.Controls.Grid]::SetRow($deleteTitleLabel, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($deleteTitleLabel, 2)
$deleteGrid.Children.Add($deleteTitleLabel)

# Create a ScrollViewer for the user list
$scrollViewer = New-Object System.Windows.Controls.ScrollViewer
$scrollViewer.VerticalScrollBarVisibility = "Auto"
$scrollViewer.Margin = "0,10,0,10"
[System.Windows.Controls.Grid]::SetRow($scrollViewer, 1)
[System.Windows.Controls.Grid]::SetRowSpan($scrollViewer, 3)
[System.Windows.Controls.Grid]::SetColumnSpan($scrollViewer, 2)
$deleteGrid.Children.Add($scrollViewer)

# Create a StackPanel to hold the checkboxes
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = "Vertical"
$scrollViewer.Content = $stackPanel

# Create a button to delete selected users
$deleteButton = New-Object System.Windows.Controls.Button
$deleteButton.Content = "Delete Selected Users"
$deleteButton.Width = 200
$deleteButton.Height = 30
$deleteButton.Margin = "0,20,0,0"
$deleteButton.Background = [System.Windows.Media.Brushes]::Tomato
$deleteButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($deleteButton, 4)
[System.Windows.Controls.Grid]::SetColumnSpan($deleteButton, 2)
$deleteGrid.Children.Add($deleteButton)

# Event handler for the delete button click
$deleteButton.Add_Click({
    $selectedUsers = @()
    foreach ($child in $stackPanel.Children) {
        if ($child.IsChecked -eq $true) {
            $selectedUsers += $child.Content
        }
    }

    if ($selectedUsers.Count -eq 0) {
        [System.Windows.MessageBox]::Show("Please select at least one user to delete.", "Warning", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    $confirmation = [System.Windows.MessageBox]::Show("Are you sure you want to delete the selected users?", "Confirmation", [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)
    
    if ($confirmation -eq [System.Windows.MessageBoxResult]::Yes) {
        foreach ($user in $selectedUsers) {
            try {
                # Delete the local user
                Remove-LocalUser -Name $user -ErrorAction Stop
                [System.Windows.MessageBox]::Show("User $user has been deleted.", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
            } catch {
                [System.Windows.MessageBox]::Show("Failed to delete user $user. Error: $($_.Exception.Message)", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
            }
        }

        # Refresh the user list
        UpdateUserLists
    }
})

### Group Membership Tab ###
$manageGroupsGrid = New-Object System.Windows.Controls.Grid
$manageGroupsGrid.Margin = "10"
$groupMembershipTab.Content = $manageGroupsGrid

# Define grid rows and columns
for ($i = 0; $i -lt 6; $i++) {
    $manageGroupsGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
}
for ($j = 0; $j -lt 2; $j++) {
    $manageGroupsGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
}

# Add a title label
$manageGroupsTitleLabel = New-Object System.Windows.Controls.Label
$manageGroupsTitleLabel.Content = "Group Membership"
$manageGroupsTitleLabel.FontSize = 18
$manageGroupsTitleLabel.FontWeight = "Bold"
$manageGroupsTitleLabel.HorizontalAlignment = "Center"
$manageGroupsTitleLabel.Margin = "0,0,0,10"
[System.Windows.Controls.Grid]::SetRow($manageGroupsTitleLabel, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($manageGroupsTitleLabel, 2)
$manageGroupsGrid.Children.Add($manageGroupsTitleLabel)

# Create a label and combobox for selecting user
$manageGroupsUserLabel = New-Object System.Windows.Controls.Label
$manageGroupsUserLabel.Content = "Select User:"
$manageGroupsUserLabel.VerticalAlignment = "Center"
$manageGroupsUserLabel.HorizontalAlignment = "Right"
$manageGroupsUserLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($manageGroupsUserLabel, 1)
[System.Windows.Controls.Grid]::SetColumn($manageGroupsUserLabel, 0)
$manageGroupsGrid.Children.Add($manageGroupsUserLabel)

$manageGroupsUserComboBox = New-Object System.Windows.Controls.ComboBox
$manageGroupsUserComboBox.Margin = "0,0,0,10"
$manageGroupsUserComboBox.Width = 200
[System.Windows.Controls.Grid]::SetRow($manageGroupsUserComboBox, 1)
[System.Windows.Controls.Grid]::SetColumn($manageGroupsUserComboBox, 1)
$manageGroupsGrid.Children.Add($manageGroupsUserComboBox)

# Create a TextBlock for displaying user's current groups
$currentGroupsTextBlock = New-Object System.Windows.Controls.TextBlock
$currentGroupsTextBlock.Margin = "10,0,0,10"
$currentGroupsTextBlock.HorizontalAlignment = "Left"
[System.Windows.Controls.Grid]::SetRow($currentGroupsTextBlock, 2)
[System.Windows.Controls.Grid]::SetColumnSpan($currentGroupsTextBlock, 2)
$manageGroupsGrid.Children.Add($currentGroupsTextBlock)

# Create a ScrollViewer for the group list
$groupsScrollViewer = New-Object System.Windows.Controls.ScrollViewer
$groupsScrollViewer.VerticalScrollBarVisibility = "Auto"
$groupsScrollViewer.Margin = "0,10,0,10"
[System.Windows.Controls.Grid]::SetRow($groupsScrollViewer, 3)
[System.Windows.Controls.Grid]::SetRowSpan($groupsScrollViewer, 1)
[System.Windows.Controls.Grid]::SetColumnSpan($groupsScrollViewer, 2)
$manageGroupsGrid.Children.Add($groupsScrollViewer)

# Create a StackPanel to hold the checkboxes for groups
$groupsStackPanel = New-Object System.Windows.Controls.StackPanel
$groupsStackPanel.Orientation = "Vertical"
$groupsScrollViewer.Content = $groupsStackPanel

# Populate the StackPanel with checkboxes for each group
$localGroups = Get-LocalGroup
foreach ($group in $localGroups) {
    $checkbox = New-Object System.Windows.Controls.CheckBox
    $checkbox.Content = $group.Name
    $checkbox.Margin = "5,5,0,5"
    $groupsStackPanel.Children.Add($checkbox)
}

# Event handler for user selection change
$manageGroupsUserComboBox.Add_SelectionChanged({
    $selectedUser = $manageGroupsUserComboBox.SelectedItem
    if ($null -ne $selectedUser) {
        # Clear current checkboxes
        foreach ($child in $groupsStackPanel.Children) {
            $child.IsChecked = $false
        }

        # Get groups the selected user is a member of
        $userGroups = GetUserGroupMemberships -username $selectedUser

        # Check the checkboxes for the groups the user is a member of
        foreach ($userGroup in $userGroups) {
            foreach ($child in $groupsStackPanel.Children) {
                if ($child.Content -eq $userGroup.Name) {
                    $child.IsChecked = $true
                }
            }
        }

        # Display user's current groups
        $currentGroupsTextBlock.Text = "Current Groups: " + ($userGroups | ForEach-Object { $_.Name } | Out-String).Trim()
    }
})

# Create a button to save group membership changes
$saveGroupsButton = New-Object System.Windows.Controls.Button
$saveGroupsButton.Content = "Save Group Memberships"
$saveGroupsButton.Width = 200
$saveGroupsButton.Height = 30
$saveGroupsButton.Margin = "0,20,0,0"
$saveGroupsButton.Background = [System.Windows.Media.Brushes]::LightSteelBlue
$saveGroupsButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($saveGroupsButton, 4)
[System.Windows.Controls.Grid]::SetColumnSpan($saveGroupsButton, 2)
$manageGroupsGrid.Children.Add($saveGroupsButton)

# Event handler for the save button click
$saveGroupsButton.Add_Click({
    $selectedUser = $manageGroupsUserComboBox.SelectedItem
    if ($null -eq $selectedUser) {
        [System.Windows.MessageBox]::Show("Please select a user.", "Warning", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    $currentGroups = GetUserGroupMemberships -username $selectedUser

    foreach ($child in $groupsStackPanel.Children) {
        if ($child.IsChecked -eq $true -and -not ($currentGroups.Name -contains $child.Content)) {
                        Add-LocalGroupMember -Group $child.Content -Member $selectedUser -ErrorAction Stop
        } elseif ($child.IsChecked -eq $false -and ($currentGroups.Name -contains $child.Content)) {
            Remove-LocalGroupMember -Group $child.Content -Member $selectedUser -ErrorAction Stop
        }
    }

    [System.Windows.MessageBox]::Show("Group memberships for $selectedUser have been updated.", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    UpdateUserLists
})

### User Information Tab ###
$userInfoGrid = New-Object System.Windows.Controls.Grid
$userInfoGrid.Margin = "10"
$userInfoTab.Content = $userInfoGrid

# Define grid rows and columns
for ($i = 0; $i -lt 8; $i++) {
    $userInfoGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
}
for ($j = 0; $j -lt 2; $j++) {
    $userInfoGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
}

# Add a title label
$userInfoTitleLabel = New-Object System.Windows.Controls.Label
$userInfoTitleLabel.Content = "User Information"
$userInfoTitleLabel.FontSize = 18
$userInfoTitleLabel.FontWeight = "Bold"
$userInfoTitleLabel.HorizontalAlignment = "Center"
$userInfoTitleLabel.Margin = "0,0,0,10"
[System.Windows.Controls.Grid]::SetRow($userInfoTitleLabel, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($userInfoTitleLabel, 2)
$userInfoGrid.Children.Add($userInfoTitleLabel)

# Create a label and combobox for selecting user
$userInfoUserLabel = New-Object System.Windows.Controls.Label
$userInfoUserLabel.Content = "Select User:"
$userInfoUserLabel.VerticalAlignment = "Center"
$userInfoUserLabel.HorizontalAlignment = "Right"
$userInfoUserLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($userInfoUserLabel, 1)
[System.Windows.Controls.Grid]::SetColumn($userInfoUserLabel, 0)
$userInfoGrid.Children.Add($userInfoUserLabel)

$userInfoUserComboBox = New-Object System.Windows.Controls.ComboBox
$userInfoUserComboBox.Margin = "0,0,0,10"
$userInfoUserComboBox.Width = 200
[System.Windows.Controls.Grid]::SetRow($userInfoUserComboBox, 1)
[System.Windows.Controls.Grid]::SetColumn($userInfoUserComboBox, 1)
$userInfoGrid.Children.Add($userInfoUserComboBox)

# Create labels and textboxes for displaying and editing user information
$userInfoLabels = @{}
$userInfoFields = @("FullName", "Description", "Created", "LastLogon")
for ($i = 0; $i -lt $userInfoFields.Length; $i++) {
    $label = New-Object System.Windows.Controls.Label
    $label.Content = $userInfoFields[$i] + ":"
    $label.VerticalAlignment = "Center"
    $label.HorizontalAlignment = "Right"
    $label.Margin = "0,0,10,10"
    [System.Windows.Controls.Grid]::SetRow($label, $i + 2)
    [System.Windows.Controls.Grid]::SetColumn($label, 0)
    $userInfoGrid.Children.Add($label)

    $value = New-Object System.Windows.Controls.TextBox
    $value.Margin = "0,0,10,10"
    if ($userInfoFields[$i] -eq "Created" -or $userInfoFields[$i] -eq "LastLogon") {
        $value.IsReadOnly = $true
    }
    $userInfoGrid.Children.Add($value)

    [System.Windows.Controls.Grid]::SetRow($value, $i + 2)
    [System.Windows.Controls.Grid]::SetColumn($value, 1)
    $userInfoLabels[$userInfoFields[$i]] = $value
}

# Add a label and password box for changing user password
$changePasswordLabel = New-Object System.Windows.Controls.Label
$changePasswordLabel.Content = "Change Password:"
$changePasswordLabel.VerticalAlignment = "Center"
$changePasswordLabel.HorizontalAlignment = "Right"
$changePasswordLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($changePasswordLabel, $userInfoFields.Length + 2)
[System.Windows.Controls.Grid]::SetColumn($changePasswordLabel, 0)
$userInfoGrid.Children.Add($changePasswordLabel)

$changePasswordBox = New-Object System.Windows.Controls.PasswordBox
$changePasswordBox.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($changePasswordBox, $userInfoFields.Length + 2)
[System.Windows.Controls.Grid]::SetColumn($changePasswordBox, 1)
$userInfoGrid.Children.Add($changePasswordBox)

# Add a button to save changes
$saveUserInfoButton = New-Object System.Windows.Controls.Button
$saveUserInfoButton.Content = "Save Changes"
$saveUserInfoButton.Width = 200
$saveUserInfoButton.Height = 30
$saveUserInfoButton.Margin = "0,20,0,0"
$saveUserInfoButton.Background = [System.Windows.Media.Brushes]::LightSteelBlue
$saveUserInfoButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($saveUserInfoButton, $userInfoFields.Length + 3)
[System.Windows.Controls.Grid]::SetColumnSpan($saveUserInfoButton, 2)
$userInfoGrid.Children.Add($saveUserInfoButton)

# Function to update user lists in other tabs
function UpdateUserLists {
    $localUsers = Get-LocalUser | Where-Object { $_.Name -notin @('Administrator', 'DefaultAccount', 'Guest', 'WDAGUtilityAccount') }

    # Update delete user tab
    $stackPanel.Children.Clear()
    foreach ($user in $localUsers) {
        $checkbox = New-Object System.Windows.Controls.CheckBox
        $checkbox.Content = $user.Name
        $checkbox.Margin = "5,5,0,5"
        $stackPanel.Children.Add($checkbox)
    }

    # Update group membership tab
    $manageGroupsUserComboBox.Items.Clear()
    foreach ($user in $localUsers) {
        $manageGroupsUserComboBox.Items.Add($user.Name)
    }

    # Update user information tab
    $userInfoUserComboBox.Items.Clear()
    foreach ($user in $localUsers) {
        $userInfoUserComboBox.Items.Add($user.Name)
    }

    # Clear current checkboxes
    foreach ($child in $groupsStackPanel.Children) {
        $child.IsChecked = $false
    }

    # If a user is selected, update group membership checkboxes
    $selectedUser = $manageGroupsUserComboBox.SelectedItem
    if ($null -ne $selectedUser) {
        $userGroups = GetUserGroupMemberships -username $selectedUser

        foreach ($userGroup in $userGroups) {
            foreach ($child in $groupsStackPanel.Children) {
                if ($child.Content -eq $userGroup.Name) {
                    $child.IsChecked = $true
                }
            }
        }
    }
}

# Initial population of user lists
UpdateUserLists

# Event handler for user selection change in User Information tab
$userInfoUserComboBox.Add_SelectionChanged({
    $selectedUser = $userInfoUserComboBox.SelectedItem
    if ($null -ne $selectedUser) {
        $user = Get-LocalUser -Name $selectedUser
        $userInfoLabels["FullName"].Text = $user.FullName
        $userInfoLabels["Description"].Text = $user.Description
        if ($null -ne $user.Created) {
            $userInfoLabels["Created"].Text = $user.Created.ToString()
        }
        if ($null -ne $user.LastLogon) {
            $userInfoLabels["LastLogon"].Text = $user.LastLogon.ToString()
        }
    }
})

# Event handler for save button click in User Information tab
$saveUserInfoButton.Add_Click({
    $selectedUser = $userInfoUserComboBox.SelectedItem
    if ($null -eq $selectedUser) {
        [System.Windows.MessageBox]::Show("Please select a user.", "Warning", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    try {
        # Update user information
        $userParams = @{
            FullName = $userInfoLabels["FullName"].Text
            Description = $userInfoLabels["Description"].Text
        }

        # Update the local user
        Set-LocalUser -Name $selectedUser @userParams -ErrorAction Stop

        # Change password if specified
        $newPassword = $changePasswordBox.Password
        if ($newPassword) {
            $securePassword = ConvertTo-SecureString $newPassword -AsPlainText -Force
            Set-LocalUser -Name $selectedUser -Password $securePassword -ErrorAction Stop
        }

        [System.Windows.MessageBox]::Show("User information for $selectedUser has been updated.", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        UpdateUserLists
    } catch {
        [System.Windows.MessageBox]::Show("Failed to update user information for $selectedUser. Error: $($_.Exception.Message)",
                    "Error", [System.Windows.MessageBoxButton],
                                        [System.Windows.MessageBoxImage]::Error)
    }

    $changePasswordBox.Clear()
})

# Initial population of user lists
UpdateUserLists

# Show the window
$window.ShowDialog()