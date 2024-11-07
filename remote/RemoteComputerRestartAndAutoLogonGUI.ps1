# This PowerShell script provides a GUI for selecting and restarting multiple remote computers,
# with the added functionality of setting an automatic logon for specified user accounts.
# The script enables administrators to:
# - Load a list of target computers from a specified file.
# - Use checkboxes to select users on each computer to enable auto logon upon restart.
# - Set unique or common passwords for selected accounts to enable auto logon after the restart.
# - Perform remote restarts and apply registry changes to configure auto logon using Windows Presentation Foundation (WPF) elements.

# Script Features:
# - Reads a list of computers from a specified text file.
# - Prompts for administrator credentials to initiate sessions on remote computers.
# - Displays a GUI with buttons for loading users and initiating restart with auto logon.
# - Offers an option to use a common password or individual passwords for each selected user.
# - Uses PowerShell remoting to set registry values on each computer for auto logon, then initiates a restart.
# - Displays shutdown and restart status messages in the PowerShell console.

# Requirements:
# - PowerShell with support for Windows Presentation Foundation (WPF).
# - Administrator permissions for the credentials used to connect to remote computers.
# - PowerShell remoting enabled on all target computers.

# Important Notes:
# - Ensure that the $filePath variable is set to the correct path of a text file containing the list of target computers.
# - The common or individual passwords set for auto logon should comply with security policies.
# - Auto logon settings will remain on the computers unless manually changed or disabled.

Add-Type -AssemblyName PresentationFramework

# Path to the text file
$filePath = "C:\PS\computers.txt"

# Read the content of the file
$computers = Get-Content -Path $filePath

# Request credentials for connecting to computers
$credential = Get-Credential

# Create the main window
$window = New-Object System.Windows.Window
$window.Title = "Restart Computers and Auto Logon"
$window.Width = 1000
$window.Height = 600
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
for ($j = 0; $j -lt $computers.Count; $j++) {
    $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
}

# Add a button to load users
$loadUsersButton = New-Object System.Windows.Controls.Button
$loadUsersButton.Content = "Load Users"
$loadUsersButton.Width = 150
$loadUsersButton.Height = 40
$loadUsersButton.Margin = "0,20,0,0"
$loadUsersButton.Background = [System.Windows.Media.Brushes]::LightSteelBlue
$loadUsersButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($loadUsersButton, 6)
[System.Windows.Controls.Grid]::SetColumnSpan($loadUsersButton, $computers.Count)
$grid.Children.Add($loadUsersButton)

# Add a button to restart selected computers
$restartButton = New-Object System.Windows.Controls.Button
$restartButton.Content = "Restart and Auto Logon"
$restartButton.Width = 200
$restartButton.Height = 40
$restartButton.Margin = "0,20,0,0"
$restartButton.Background = [System.Windows.Media.Brushes]::Tomato
$restartButton.HorizontalAlignment = "Center"
$restartButton.IsEnabled = $false
[System.Windows.Controls.Grid]::SetRow($restartButton, 7)
[System.Windows.Controls.Grid]::SetColumnSpan($restartButton, $computers.Count)
$grid.Children.Add($restartButton)

# Dictionary to keep track of users and their respective computers
$userDict = @{}
$passwords = @{}

# Create a scrollviewer and stackpanel for each computer
$scrollViewers = @{}
$stackPanels = @{}

for ($j = 0; $j -lt $computers.Count; $j++) {
    $computer = $computers[$j]
    
    # Create a label for the computer
    $computerLabel = New-Object System.Windows.Controls.Label
    $computerLabel.Content = $computer
    $computerLabel.FontSize = 16
    $computerLabel.FontWeight = "Bold"
    $computerLabel.HorizontalAlignment = "Center"
    $computerLabel.Margin = "0,0,0,10"
    [System.Windows.Controls.Grid]::SetRow($computerLabel, 0)
    [System.Windows.Controls.Grid]::SetColumn($computerLabel, $j)
    $grid.Children.Add($computerLabel)
    
    $scrollViewer = New-Object System.Windows.Controls.ScrollViewer
    $scrollViewer.Margin = "0,0,0,10"
    $scrollViewer.VerticalScrollBarVisibility = "Auto"
    [System.Windows.Controls.Grid]::SetRow($scrollViewer, 1)
    [System.Windows.Controls.Grid]::SetRowSpan($scrollViewer, 5)
    [System.Windows.Controls.Grid]::SetColumn($scrollViewer, $j)
    $grid.Children.Add($scrollViewer)
    
    $stackPanel = New-Object System.Windows.Controls.StackPanel
    $stackPanel.Orientation = "Vertical"
    $scrollViewer.Content = $stackPanel
    
    $scrollViewers[$computer] = $scrollViewer
    $stackPanels[$computer] = $stackPanel
}

# Event handler to load users
$loadUsersButton.Add_Click({
    foreach ($computer in $computers) {
        $stackPanel = $stackPanels[$computer]
        $stackPanel.Children.Clear()

        try {
            # Create a session with the remote computer
            $session = New-PSSession -ComputerName $computer -Credential $credential

            # Get the list of local users on the remote computer
            $users = Invoke-Command -Session $session -ScriptBlock {
                Get-LocalUser | Select-Object Name
            }

            foreach ($user in $users) {
                $checkbox = New-Object System.Windows.Controls.CheckBox
                $checkbox.Content = "$($computer)\$($user.Name)"
                $checkbox.Margin = "0,5,0,5"
                $stackPanel.Children.Add($checkbox)

                $userDict["$($computer)\$($user.Name)"] = $computer
            }

            # Close the session
            Remove-PSSession -Session $session
        } catch {
            Write-Host "Failed to connect to computer $computer $_" -ForegroundColor Red
        }
    }

    if ($userDict.Count -gt 0) {
        $restartButton.IsEnabled = $true
    }
})

# Event handler to restart computers and set auto logon
$restartButton.Add_Click({
    # Request passwords for selected users
    $selectedUsers = @{}
    foreach ($computer in $computers) {
        $stackPanel = $stackPanels[$computer]
        foreach ($child in $stackPanel.Children) {
            if ($child.IsChecked -eq $true) {
                $selectedUsers["$($computer)\$($child.Content.Split('\')[1])"] = $computer
            }
        }
    }

    # If no users selected, exit
    if ($selectedUsers.Count -eq 0) {
        Write-Host "No users selected." -ForegroundColor Yellow
        return
    }

    # Create a window to enter passwords
    $passwordWindow = New-Object System.Windows.Window
    $passwordWindow.Title = "Enter Passwords for Selected Users"
    $passwordWindow.Width = 400
    $passwordWindow.Height = 400
    $passwordWindow.WindowStartupLocation = "CenterScreen"
    $passwordWindow.Background = [System.Windows.Media.Brushes]::LightGray

    # Create a grid layout for the password window
    $passwordGrid = New-Object System.Windows.Controls.Grid
    $passwordGrid.Margin = "10"

    # Define grid rows and columns for the password window
    for ($i = 0; $i -lt ($selectedUsers.Count * 2 + 6); $i++) {
        $passwordGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
    }
    $passwordGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))

    # Add checkbox for using the same password
    $useSamePasswordCheckbox = New-Object System.Windows.Controls.CheckBox
    $useSamePasswordCheckbox.Content = "Use same password for all users"
    $useSamePasswordCheckbox.HorizontalAlignment = "Left"
    $useSamePasswordCheckbox.VerticalAlignment = "Center"
    [System.Windows.Controls.Grid]::SetRow($useSamePasswordCheckbox, 0)
    [System.Windows.Controls.Grid]::SetColumn($useSamePasswordCheckbox, 0)
    $passwordGrid.Children.Add($useSamePasswordCheckbox)

    # Add a common password field
    $commonPasswordLabel = New-Object System.Windows.Controls.Label
    $commonPasswordLabel.Content = "Common Password"
    $commonPasswordLabel.HorizontalAlignment = "Left"
    $commonPasswordLabel.VerticalAlignment = "Center"
    [System.Windows.Controls.Grid]::SetRow($commonPasswordLabel, 1)
    [System.Windows.Controls.Grid]::SetColumn($commonPasswordLabel, 0)
    $passwordGrid.Children.Add($commonPasswordLabel)

    $commonPasswordBox = New-Object System.Windows.Controls.PasswordBox
    $commonPasswordBox.HorizontalAlignment = "Left"
    $commonPasswordBox.VerticalAlignment = "Center"
    $commonPasswordBox.Width = 200
    [System.Windows.Controls.Grid]::SetRow($commonPasswordBox, 2)
    [System.Windows.Controls.Grid]::SetColumn($commonPasswordBox, 0)
    $passwordGrid.Children.Add($commonPasswordBox)
    $commonPasswordLabel.Visibility = "Collapsed"
    $commonPasswordBox.Visibility = "Collapsed"

    # Add password fields for each selected user
    $rowIndex = 3
    $passwordBoxes = @{}
    foreach ($user in $selectedUsers.Keys) {
        $label = New-Object System.Windows.Controls.Label
        $label.Content = "Password for $user"
        $label.HorizontalAlignment = "Left"
        $label.VerticalAlignment = "Center"
        [System.Windows.Controls.Grid]::SetRow($label, $rowIndex)
        [System.Windows.Controls.Grid]::SetColumn($label, 0)
        $passwordGrid.Children.Add($label)

        $passwordBox = New-Object System.Windows.Controls.PasswordBox
        $passwordBox.HorizontalAlignment = "Left"
        $passwordBox.VerticalAlignment = "Center"
        $passwordBox.Width = 200
                [System.Windows.Controls.Grid]::SetRow($passwordBox, $rowIndex + 1)
        [System.Windows.Controls.Grid]::SetColumn($passwordBox, 0)
        $passwordGrid.Children.Add($passwordBox)

        $passwordBoxes[$user] = $passwordBox
        $rowIndex += 2
    }

    # Add a submit button
    $submitPasswordButton = New-Object System.Windows.Controls.Button
    $submitPasswordButton.Content = "Submit"
    $submitPasswordButton.Width = 100
    $submitPasswordButton.Height = 30
    $submitPasswordButton.Margin = "0,20,0,0"
    $submitPasswordButton.HorizontalAlignment = "Center"
    [System.Windows.Controls.Grid]::SetRow($submitPasswordButton, $rowIndex + 2)
    [System.Windows.Controls.Grid]::SetColumn($submitPasswordButton, 0)
    $passwordGrid.Children.Add($submitPasswordButton)

    # Event handler for the useSamePasswordCheckbox
    $useSamePasswordCheckbox.Add_Checked({
        $commonPasswordLabel.Visibility = "Visible"
        $commonPasswordBox.Visibility = "Visible"
        foreach ($passwordBox in $passwordBoxes.Values) {
            $passwordBox.Password = ""
            $passwordBox.IsEnabled = $false
        }
    })

    $useSamePasswordCheckbox.Add_Unchecked({
        $commonPasswordLabel.Visibility = "Collapsed"
        $commonPasswordBox.Visibility = "Collapsed"
        foreach ($passwordBox in $passwordBoxes.Values) {
            $passwordBox.Password = ""
            $passwordBox.IsEnabled = $true
        }
    })

    # Event handler for submit button
    $submitPasswordButton.Add_Click({
        if ($useSamePasswordCheckbox.IsChecked -eq $true) {
            $commonPassword = $commonPasswordBox.Password
            foreach ($user in $passwordBoxes.Keys) {
                $passwords[$user] = $commonPassword
            }
        } else {
            foreach ($user in $passwordBoxes.Keys) {
                $passwords[$user] = $passwordBoxes[$user].Password
            }
        }
        $passwordWindow.Close()
    })

    # Make the password window scrollable
    $scrollViewer = New-Object System.Windows.Controls.ScrollViewer
    $scrollViewer.VerticalScrollBarVisibility = "Auto"
    $scrollViewer.Content = $passwordGrid
    $passwordWindow.Content = $scrollViewer

    # Show the password window
    $passwordWindow.ShowDialog()

    # Restart computers with auto logon
    foreach ($user in $selectedUsers.Keys) {
        $computer = $selectedUsers[$user]
        $username = $user.Split('\')[1]
        $password = $passwords[$user]

        try {
            # Create a session with the remote computer
            $session = New-PSSession -ComputerName $computer -Credential $credential

            # Set auto logon and restart computer
            Invoke-Command -Session $session -ScriptBlock {
                param ($username, $password)

                # Set registry for auto logon
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Value "1"
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Value $username
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Value $password
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultDomainName" -Value "."

                # Restart computer
                Restart-Computer -Force
            } -ArgumentList $username, $password

            # Close the session
            Remove-PSSession -Session $session

            Write-Host "Computer $computer has been set for auto logon and restarted." -ForegroundColor Green
        } catch {
            Write-Host "Failed to set auto logon or restart computer $computer $_" -ForegroundColor Red
        }
    }
})

# Show the window
$window.ShowDialog()