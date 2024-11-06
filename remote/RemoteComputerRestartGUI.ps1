# This PowerShell script provides a graphical interface for restarting multiple remote computers simultaneously.
# It is designed to simplify remote administration by allowing administrators to select computers from a list and initiate
# restarts with a single button click. The script uses Windows Presentation Foundation (WPF) elements to display the interface.

# Key functionalities:
# - Reads a list of target computers from a specified text file.
# - Prompts the user for credentials required to connect to each remote computer.
# - Displays a GUI with checkboxes for each computer, allowing easy selection of computers to restart.
# - Offers a "Select All" button to quickly select all computers in the list.
# - Establishes a PowerShell session with each selected computer to execute the restart command remotely.

# Notes:
# - Update the `$filePath` variable to point to the correct location of the text file containing the list of computers.
# - This script requires PowerShell remoting to be enabled on all target computers.
# - Administrator permissions are necessary to initiate restarts on the specified remote systems.
# - Error messages and progress information are displayed in the PowerShell console during execution.

Add-Type -AssemblyName PresentationFramework

# Path to the text file
$filePath = "C:\PS\computers.txt"

# Read the content of the file
$computers = Get-Content -Path $filePath

# Request credentials for connecting to computers
$credential = Get-Credential

# Create the main window
$window = New-Object System.Windows.Window
$window.Title = "Restart Computers"
$window.Width = 400
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

$grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))

# Add a title label
$titleLabel = New-Object System.Windows.Controls.Label
$titleLabel.Content = "Select Computers to Restart"
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
[System.Windows.Controls.Grid]::SetRow($computersScrollViewer, 1)
[System.Windows.Controls.Grid]::SetRowSpan($computersScrollViewer, 2)
[System.Windows.Controls.Grid]::SetColumn($computersScrollViewer, 0)
$grid.Children.Add($computersScrollViewer)

$computersStackPanel = New-Object System.Windows.Controls.StackPanel
$computersStackPanel.Orientation = "Vertical"
$computersScrollViewer.Content = $computersStackPanel

# Add checkboxes for each computer
$computerCheckboxes = @{}
foreach ($computer in $computers) {
    $checkbox = New-Object System.Windows.Controls.CheckBox
    $checkbox.Content = $computer
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
[System.Windows.Controls.Grid]::SetRow($selectAllButton, 3)
[System.Windows.Controls.Grid]::SetColumn($selectAllButton, 0)
$grid.Children.Add($selectAllButton)

# Add a button to restart selected computers
$restartButton = New-Object System.Windows.Controls.Button
$restartButton.Content = "Restart Selected Computers"
$restartButton.Width = 200
$restartButton.Height = 40
$restartButton.Margin = "10,20,0,0"
$restartButton.Background = [System.Windows.Media.Brushes]::Tomato
$restartButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($restartButton, 4)
[System.Windows.Controls.Grid]::SetColumn($restartButton, 0)
$grid.Children.Add($restartButton)

# Event handler to select all computers
$selectAllButton.Add_Click({
    foreach ($checkbox in $computerCheckboxes.Values) {
        $checkbox.IsChecked = $true
    }
})

# Event handler to restart selected computers
$restartButton.Add_Click({
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

            # Restart the remote computer
            Invoke-Command -Session $session -ScriptBlock {
                Restart-Computer -Force
            }

            # Close the session
            Remove-PSSession -Session $session

            Write-Host "Computer $computer has been restarted." -ForegroundColor Green
        } catch {
            Write-Host "Failed to restart computer $computer $_" -ForegroundColor Red
        }
    }
})

# Show the window
$window.ShowDialog()