# This PowerShell script provides a GUI for remotely logging off users from multiple target computers. 
# Administrators can view the current logged-in user on each specified computer, select individual or 
# multiple computers for logging off users, and use the "Select All" option for batch management.
# The script utilizes Windows Presentation Foundation (WPF) to present an interactive and user-friendly interface.

# Key functionalities:
# - Reads a list of target computers from a specified text file.
# - Prompts the administrator to enter credentials, used to connect to each remote computer.
# - Displays a GUI with checkboxes, showing each target computer and the currently logged-in user.
# - Allows selection of specific computers or all computers to apply the log-off action.
# - Uses PowerShell Remoting to connect to each selected computer, then logs off the current user.

# Notes:
# - **Update the `$filePath` variable** to the correct path where your target computer list is stored.
# - **PowerShell Remoting**: Ensure that PowerShell Remoting is enabled on each target computer.
# - **Administrator permissions** are required to perform user log-off actions on remote systems.
# - **Error handling**: Connection and permission errors are logged in the PowerShell console for troubleshooting.

Add-Type -AssemblyName PresentationFramework

# Path to the text file
$filePath = "C:\PS\computers.txt"

# Read the content of the file
$computers = Get-Content -Path $filePath

# Request credentials for connecting to computers
$credential = Get-Credential

# Create the main window
$window = New-Object System.Windows.Window
$window.Title = "Log Off Users"
$window.Width = 600
$window.Height = 500
$window.WindowStartupLocation = "CenterScreen"
$window.Background = [System.Windows.Media.Brushes]::LightGray

# Create a grid layout
$grid = New-Object System.Windows.Controls.Grid
$grid.Margin = "10"
$window.Content = $grid

# Define grid rows and columns
$grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
$grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
$grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
$grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
$grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
$grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))

$grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))

# Add a title label
$titleLabel = New-Object System.Windows.Controls.Label
$titleLabel.Content = "Select Computers to Log Off Users"
$titleLabel.FontSize = 16
$titleLabel.FontWeight = "Bold"
$titleLabel.HorizontalAlignment = "Center"
$titleLabel.Margin = "0,0,0,10"
[System.Windows.Controls.Grid]::SetRow($titleLabel, 0)
[System.Windows.Controls.Grid]::SetColumn($titleLabel, 0)
$grid.Children.Add($titleLabel)

# Create a scrollviewer for computer checkboxes
$computersScrollViewer = New-Object System.Windows.Controls.ScrollViewer
$computersScrollViewer.VerticalScrollBarVisibility = "Auto"
$computersScrollViewer.Height = 300
[System.Windows.Controls.Grid]::SetRow($computersScrollViewer, 1)
[System.Windows.Controls.Grid]::SetRowSpan($computersScrollViewer, 3)
[System.Windows.Controls.Grid]::SetColumn($computersScrollViewer, 0)
$grid.Children.Add($computersScrollViewer)

$computersStackPanel = New-Object System.Windows.Controls.StackPanel
$computersStackPanel.Orientation = "Vertical"
$computersScrollViewer.Content = $computersStackPanel

# Add checkboxes for each computer with the current logged-in user
$computerCheckboxes = @{}
foreach ($computer in $computers) {
    $loggedInUser = "Unknown"

    try {
        # Create a session with the remote computer
        $session = New-PSSession -ComputerName $computer -Credential $credential

        # Get the currently logged in user
        $loggedInUser = Invoke-Command -Session $session -ScriptBlock {
            (Get-WmiObject -Class Win32_ComputerSystem).UserName
        }

        # Close the session
        Remove-PSSession -Session $session
    } catch {
        $loggedInUser = "Error"
    }

    $checkbox = New-Object System.Windows.Controls.CheckBox
    $checkbox.Content = "$computer (User: $loggedInUser)"
    $checkbox.Margin = "0,5,0,5"
    $computersStackPanel.Children.Add($checkbox)
    $computerCheckboxes[$computer] = $checkbox
}

# Add a button to select all computers
$selectAllButton = New-Object System.Windows.Controls.Button
$selectAllButton.Content = "Select All"
$selectAllButton.Width = 100
$selectAllButton.Height = 30
$selectAllButton.Margin = "0,10,0,0"
$selectAllButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($selectAllButton, 4)
[System.Windows.Controls.Grid]::SetColumn($selectAllButton, 0)
$grid.Children.Add($selectAllButton)

# Add a button to log off users on selected computers
$logOffButton = New-Object System.Windows.Controls.Button
$logOffButton.Content = "Log Off Users"
$logOffButton.Width = 200
$logOffButton.Height = 40
$logOffButton.Margin = "10,20,0,0"
$logOffButton.Background = [System.Windows.Media.Brushes]::Tomato
$logOffButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($logOffButton, 5)
[System.Windows.Controls.Grid]::SetColumn($logOffButton, 0)
$grid.Children.Add($logOffButton)

# Event handler to select all computers
$selectAllButton.Add_Click({
    foreach ($checkbox in $computerCheckboxes.Values) {
        $checkbox.IsChecked = $true
    }
})

# Event handler to log off users on selected computers
$logOffButton.Add_Click({
    $selectedComputers = @()
    foreach ($computer in $computerCheckboxes.Keys) {
        if ($computerCheckboxes[$computer].IsChecked -eq $true) {
            $selectedComputers += $computer
        }
    }

    if ($selectedComputers.Count -eq 0) {
        Write-Host "No computers selected." -ForegroundColor Yellow
        return
    }

    foreach ($computer in $selectedComputers) {
        try {
            # Create a session with the remote computer
            $session = New-PSSession -ComputerName $computer -Credential $credential

            # Log off the current user on the remote computer
            Invoke-Command -Session $session -ScriptBlock {
                $os = Get-WmiObject -Class Win32_OperatingSystem
                $os.PSBase.Scope.Options.EnablePrivileges = $true
                $os.Win32Shutdown(4)
            }

            # Close the session
            Remove-PSSession -Session $session

            Write-Host "Current user has been logged off from computer $computer." -ForegroundColor Green
        } catch {
            Write-Host "Failed to log off user on computer $computer $_" -ForegroundColor Red
        }
    }
})

# Show the window
$window.ShowDialog()