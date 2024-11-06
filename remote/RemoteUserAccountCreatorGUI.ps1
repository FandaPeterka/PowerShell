Add-Type -AssemblyName PresentationFramework

# Path to the text file
$filePath = "C:\Path\To\Your\computers.txt"

# Read the content of the file
$computers = Get-Content -Path $filePath

# Request credentials for connecting to computers
$credential = Get-Credential

# Create the main window
$window = New-Object System.Windows.Window
$window.Title = "Create New User"
$window.Width = 600
$window.Height = 500
$window.WindowStartupLocation = "CenterScreen"
$window.Background = [System.Windows.Media.Brushes]::LightGray

# Create a grid layout
$grid = New-Object System.Windows.Controls.Grid
$grid.Margin = "10"
$window.Content = $grid

# Define grid rows and columns
for ($i = 0; $i -lt 8; $i++) {
    $grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
}
for ($j = 0; $j -lt 3; $j++) {
    $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
}

# Add a title label
$titleLabel = New-Object System.Windows.Controls.Label
$titleLabel.Content = "Create New User"
$titleLabel.FontSize = 24
$titleLabel.FontWeight = "Bold"
$titleLabel.HorizontalAlignment = "Center"
$titleLabel.Margin = "0,0,0,20"
[System.Windows.Controls.Grid]::SetRow($titleLabel, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($titleLabel, 3)
$grid.Children.Add($titleLabel)

# Create labels and textboxes for username and password
$usernameLabel = New-Object System.Windows.Controls.Label
$usernameLabel.Content = "Username:"
$usernameLabel.VerticalAlignment = "Center"
$usernameLabel.HorizontalAlignment = "Right"
$usernameLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($usernameLabel, 1)
[System.Windows.Controls.Grid]::SetColumn($usernameLabel, 0)
$grid.Children.Add($usernameLabel)

$usernameTextBox = New-Object System.Windows.Controls.TextBox
$usernameTextBox.Margin = "0,0,0,10"
$usernameTextBox.Width = 150
[System.Windows.Controls.Grid]::SetRow($usernameTextBox, 1)
[System.Windows.Controls.Grid]::SetColumn($usernameTextBox, 1)
$grid.Children.Add($usernameTextBox)

$fullnameLabel = New-Object System.Windows.Controls.Label
$fullnameLabel.Content = "Full Name:"
$fullnameLabel.VerticalAlignment = "Center"
$fullnameLabel.HorizontalAlignment = "Right"
$fullnameLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($fullnameLabel, 2)
[System.Windows.Controls.Grid]::SetColumn($fullnameLabel, 0)
$grid.Children.Add($fullnameLabel)

$fullnameTextBox = New-Object System.Windows.Controls.TextBox
$fullnameTextBox.Margin = "0,0,0,10"
$fullnameTextBox.Width = 150
[System.Windows.Controls.Grid]::SetRow($fullnameTextBox, 2)
[System.Windows.Controls.Grid]::SetColumn($fullnameTextBox, 1)
$grid.Children.Add($fullnameTextBox)

$passwordLabel = New-Object System.Windows.Controls.Label
$passwordLabel.Content = "Password:"
$passwordLabel.VerticalAlignment = "Center"
$passwordLabel.HorizontalAlignment = "Right"
$passwordLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($passwordLabel, 3)
[System.Windows.Controls.Grid]::SetColumn($passwordLabel, 0)
$grid.Children.Add($passwordLabel)

$passwordTextBox = New-Object System.Windows.Controls.PasswordBox
$passwordTextBox.Margin = "0,0,0,10"
$passwordTextBox.Width = 150
[System.Windows.Controls.Grid]::SetRow($passwordTextBox, 3)
[System.Windows.Controls.Grid]::SetColumn($passwordTextBox, 1)
$grid.Children.Add($passwordTextBox)

# Create a label and combobox for permissions
$permissionLabel = New-Object System.Windows.Controls.Label
$permissionLabel.Content = "Permission:"
$permissionLabel.VerticalAlignment = "Center"
$permissionLabel.HorizontalAlignment = "Right"
$permissionLabel.Margin = "0,0,10,10"
[System.Windows.Controls.Grid]::SetRow($permissionLabel, 4)
[System.Windows.Controls.Grid]::SetColumn($permissionLabel, 0)
$grid.Children.Add($permissionLabel)

$permissionComboBox = New-Object System.Windows.Controls.ComboBox
$permissionComboBox.Margin = "0,0,0,10"
$permissionComboBox.Width = 150
$permissionComboBox.Items.Add("User")
$permissionComboBox.Items.Add("Administrator")
[System.Windows.Controls.Grid]::SetRow($permissionComboBox, 4)
[System.Windows.Controls.Grid]::SetColumn($permissionComboBox, 1)
$grid.Children.Add($permissionComboBox)

# Create a label and scrollviewer for computers
$computersLabel = New-Object System.Windows.Controls.Label
$computersLabel.Content = "Target Computers:"
$computersLabel.VerticalAlignment = "Center"
$computersLabel.HorizontalAlignment = "Left"
$computersLabel.Margin = "0,0,0,10"
[System.Windows.Controls.Grid]::SetRow($computersLabel, 1)
[System.Windows.Controls.Grid]::SetColumn($computersLabel, 2)
$grid.Children.Add($computersLabel)

$computersScrollViewer = New-Object System.Windows.Controls.ScrollViewer
$computersScrollViewer.Margin = "0,0,0,10"
$computersScrollViewer.Width = 200
$computersScrollViewer.Height = 300
$computersScrollViewer.VerticalScrollBarVisibility = "Auto"
[System.Windows.Controls.Grid]::SetRow($computersScrollViewer, 2)
[System.Windows.Controls.Grid]::SetRowSpan($computersScrollViewer, 5)
[System.Windows.Controls.Grid]::SetColumn($computersScrollViewer, 2)
$grid.Children.Add($computersScrollViewer)

$computersStackPanel = New-Object System.Windows.Controls.StackPanel
$computersStackPanel.Orientation = "Vertical"
$computersScrollViewer.Content = $computersStackPanel

# Add "Select All" checkbox
$selectAllCheckBox = New-Object System.Windows.Controls.CheckBox
$selectAllCheckBox.Content = "Select All"
$selectAllCheckBox.Margin = "0,0,0,10"
$computersStackPanel.Children.Add($selectAllCheckBox)

foreach ($computer in $computers) {
    $computerCheckBox = New-Object System.Windows.Controls.CheckBox
    $computerCheckBox.Content = $computer
    $computerCheckBox.Margin = "0,5,0,5"
    $computersStackPanel.Children.Add($computerCheckBox)
}

$selectAllCheckBox.Add_Checked({
    foreach ($child in $computersStackPanel.Children) {
        if ($child -is [System.Windows.Controls.CheckBox]) {
            $child.IsChecked = $true
        }
    }
})

$selectAllCheckBox.Add_Unchecked({
    foreach ($child in $computersStackPanel.Children) {
        if ($child -is [System.Windows.Controls.CheckBox]) {
            $child.IsChecked = $false
        }
    }
})

# Create a button to create the user
$createButton = New-Object System.Windows.Controls.Button
$createButton.Content = "Create User"
$createButton.Width = 150
$createButton.Height = 40
$createButton.Margin = "0,20,0,0"
$createButton.Background = [System.Windows.Media.Brushes]::LightSteelBlue
[System.Windows.Controls.Grid]::SetRow($createButton, 7)
[System.Windows.Controls.Grid]::SetColumnSpan($createButton, 3)
$createButton.HorizontalAlignment = "Center"
$grid.Children.Add($createButton)

# Event handler for the button click
$createButton.Add_Click({
    $newUsername = $usernameTextBox.Text
    $newFullName = $fullnameTextBox.Text
    $newPassword = $passwordTextBox.Password
    $securePassword = ConvertTo-SecureString $newPassword -AsPlainText -Force
    $permission = $permissionComboBox.SelectedItem

    $selectedComputers = @()
    foreach ($child in $computersStackPanel.Children) {
        if ($child -is [System.Windows.Controls.CheckBox] -and $child.Content -ne "Select All" -and $child.IsChecked -eq $true) {
            $selectedComputers += $child.Content
        }
    }

    foreach ($computer in $selectedComputers) {
        try {
            # Create a session with the remote computer
            $session = New-PSSession -ComputerName $computer -Credential $credential

            # Create a new local user on the remote computer
            Invoke-Command -Session $session -ScriptBlock {
                param ($newUsername, $newFullName, $securePassword, $permission)
                                # Create a new user
                New-LocalUser -Name $newUsername -Password $securePassword -FullName $newFullName -Description "User account for $newFullName"

                Start-Sleep -Seconds 2 # Add a delay to ensure the user is created

                # Add the user to the appropriate group based on selected permission
                if ($permission -eq "Administrator") {
                    Add-LocalGroupMember -Group "Administrators" -Member $newUsername -ErrorAction Stop
                } else {
                    Add-LocalGroupMember -Group "Users" -Member $newUsername -ErrorAction Stop
                }
            } -ArgumentList $newUsername, $newFullName, $securePassword, $permission -ErrorAction Stop

            # Close the session
            Remove-PSSession -Session $session

            Write-Host "New user $newUsername has been created on computer $computer." -ForegroundColor Green
        } catch {
            Write-Host "Failed to create user $newUsername on computer $computer $_" -ForegroundColor Red
        }
    }

    $window.Close()
})

# Show the window
$window.ShowDialog()