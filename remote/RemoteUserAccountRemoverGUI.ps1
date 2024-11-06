# This PowerShell script creates a GUI for managing local user accounts across multiple remote computers. 
# Using a list of target computers, administrators can load the list of local users on each computer and 
# selectively delete users as needed. The script leverages Windows Presentation Foundation (WPF) elements 
# to provide an interactive graphical interface.

# Key functionalities:
# - Reads a list of target computers from a specified text file.
# - Prompts the user for credentials required to connect to each remote computer.
# - Displays a GUI with checkboxes representing users on each computer, allowing easy selection for deletion.
# - Establishes a PowerShell session with each computer to retrieve user lists and delete selected accounts.
# - Refreshes the user list automatically after deletions for immediate feedback.

# Notes:
# - Update the `$filePath` variable to point to the correct location of the text file containing target computers.
# - This script requires PowerShell Remoting enabled on all target computers.
# - Administrator permissions are necessary to delete users on remote systems.

Add-Type -AssemblyName PresentationFramework

# Path to the text file
$filePath = "C:\path\to\your\computers.txt"

# Read the content of the file
$computers = Get-Content -Path $filePath

# Request credentials for connecting to computers
$credential = Get-Credential

# Create the main window
$window = New-Object System.Windows.Window
$window.Title = "Manage Remote Users"
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

# Add a button to delete selected users
$deleteUsersButton = New-Object System.Windows.Controls.Button
$deleteUsersButton.Content = "Delete Selected Users"
$deleteUsersButton.Width = 200
$deleteUsersButton.Height = 40
$deleteUsersButton.Margin = "0,20,0,0"
$deleteUsersButton.Background = [System.Windows.Media.Brushes]::Tomato
$deleteUsersButton.HorizontalAlignment = "Center"
$deleteUsersButton.IsEnabled = $false
[System.Windows.Controls.Grid]::SetRow($deleteUsersButton, 7)
[System.Windows.Controls.Grid]::SetColumnSpan($deleteUsersButton, $computers.Count)
$grid.Children.Add($deleteUsersButton)

# Dictionary to keep track of users and their respective computers
$userDict = @{}

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
        $deleteUsersButton.IsEnabled = $true
    }
})

# Event handler to delete selected users
$deleteUsersButton.Add_Click({
    $selectedUsers = @()
    foreach ($computer in $computers) {
        $stackPanel = $stackPanels[$computer]
        foreach ($child in $stackPanel.Children) {
            if ($child.IsChecked -eq $true) {
                $selectedUsers += $child.Content
            }
        }
    }

    foreach ($user in $selectedUsers) {
        $computer = $userDict[$user]
        $username = $user.Split('\')[1]

        try {
            # Create a session with the remote computer
            $session = New-PSSession -ComputerName $computer -Credential $credential

            # Delete the user on the remote computer
            Invoke-Command -Session $session -ScriptBlock {
                param ($username)
                Remove-LocalUser -Name $username -ErrorAction Stop
            } -ArgumentList $username -ErrorAction Stop

            # Close the session
            Remove-PSSession -Session $session

            Write-Host "User $username has been deleted on computer $computer." -ForegroundColor Green
        } catch {
            Write-Host "Failed to delete user $username on computer $computer $_" -ForegroundColor Red
        }
    }

    # Refresh the users list
    $loadUsersButton.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent))
})

# Show the window
$window.ShowDialog()