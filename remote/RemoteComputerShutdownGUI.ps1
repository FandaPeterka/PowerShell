# This PowerShell script provides a graphical interface for shutting down multiple computers remotely.
# It reads a list of computer names from a specified text file, allows the user to select which computers to shut down, 
# and then attempts to initiate a shutdown command on each selected computer.
# The shutdown process is handled in parallel to improve efficiency.

# Script Overview:
# - Reads computer names from a text file specified by `$filePath`.
# - Requests user credentials to establish remote sessions with each selected computer.
# - Presents a GUI where the user can select specific computers for shutdown.
# - Executes a shutdown command for each selected computer in parallel and provides feedback on success or failure.

# Usage Notes:
# - Update `$filePath` to point to your desired text file containing computer names.
# - Ensure PowerShell remoting is enabled and configured on all target computers for this script to function.
# - The script will attempt to verify if each computer shuts down successfully, and provides a summary of any failures.

Add-Type -AssemblyName PresentationFramework

# Path to the text file
$filePath = "C:\PS\computers.txt"

# Read the content of the file
$computers = Get-Content -Path $filePath

# Request credentials for connecting to computers
$credential = Get-Credential

# Create the main window
$window = New-Object System.Windows.Window
$window.Title = "Shutdown Computers"
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
$titleLabel.Content = "Select Computers to Shutdown"
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

# Add a button to shutdown selected computers
$shutdownButton = New-Object System.Windows.Controls.Button
$shutdownButton.Content = "Shutdown Selected Computers"
$shutdownButton.Width = 200
$shutdownButton.Height = 40
$shutdownButton.Margin = "10,20,0,0"
$shutdownButton.Background = [System.Windows.Media.Brushes]::Tomato
$shutdownButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($shutdownButton, 4)
[System.Windows.Controls.Grid]::SetColumn($shutdownButton, 0)
$grid.Children.Add($shutdownButton)

# Event handler to select all computers
$selectAllButton.Add_Click({
    foreach ($checkbox in $computerCheckboxes.Values) {
        $checkbox.IsChecked = $true
    }
})

# Event handler to shutdown selected computers
$shutdownButton.Add_Click({
    $selectedComputers = @()
    $failedShutdowns = @()
    $jobs = @()

    foreach ($computer in $computerCheckboxes.Keys) {
        if ($computerCheckboxes[$computer].IsChecked -eq $true) {
            $selectedComputers += $computer
        }
    }

    if ($selectedComputers.Count -eq 0) {
        Write-Host "No computers selected." -ForegroundColor Yellow
        return
    }

    # Shutdown computers in parallel using background jobs
    foreach ($computer in $selectedComputers) {
        $jobs += Start-Job -ScriptBlock {
            param ($computerName, $cred)

            try {
                # Create a session with the remote computer
                $session = New-PSSession -ComputerName $computerName -Credential $cred

                # Shutdown the remote computer
                Invoke-Command -Session $session -ScriptBlock {
                    Stop-Computer -Force
                }

                # Close the session
                Remove-PSSession -Session $session

                # Give it a few seconds to shut down
                Start-Sleep -Seconds 10

                # Check if the computer is still online
                $isOnline = Test-Connection -ComputerName $computerName -Count 1 -Quiet

                if ($isOnline) {
                    return "$computerName did not shut down properly" 
                } else {
                    return "$computerName has been successfully shut down" 
                }

            } catch {
                return "Failed to shutdown $computerName - $_"
            }
        } -ArgumentList $computer, $credential
    }

    # Wait for all jobs to complete
    $jobs | ForEach-Object { $_ | Wait-Job }

    # Collect job results
    foreach ($job in $jobs) {
        $result = Receive-Job -Job $job
        if ($result -match "did not shut down" -or $result -match "Failed") {
            $failedShutdowns += $result
        }
        Write-Host $result
    }

    # Clean up jobs
    $jobs | Remove-Job

    # Provide final summary
    if ($failedShutdowns.Count -eq 0) {
        Write-Host "All selected computers have been shut down successfully." -ForegroundColor Green
    } else {
        Write-Host "The following computers failed to shut down:" -ForegroundColor Yellow
        $failedShutdowns | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    }
})

# Show the window
$window.ShowDialog()