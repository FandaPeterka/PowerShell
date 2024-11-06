# PowerShell script to set the same time on multiple computers listed in a text file.
# This script provides a graphical interface (GUI) for entering the desired date and time, which
# is then synchronized across all specified remote computers.
# The script uses PowerShell Remoting to connect to each computer and requires admin credentials.

# Key functionalities:
# - Prompts the user for date and time to set, using a GUI form for easy input.
# - Reads a list of target computers from a specified text file.
# - Requests admin credentials to create sessions with each computer.
# - Sets the specified date and time on each computer.
# - Provides feedback for each computer, indicating whether the time setting was successful.

# Notes:
# - Ensure the `$computerListPath` variable points to the correct file path containing the list of computers.
# - PowerShell Remoting must be enabled on each target computer.
# - Administrator permissions are required for setting the date and time on remote systems.

$computerListPath = "C:\PS\computers.txt"

# Function to show the date/time input dialog
function Show-DateTimeDialog {
    Add-Type -AssemblyName PresentationFramework

    $window = New-Object Windows.Window
    $window.Title = "Enter Date and Time"
    $window.SizeToContent = "WidthAndHeight"
    $window.Width = 400
    $window.Height = 300
    $window.WindowStartupLocation = "CenterScreen"

    $stackPanel = New-Object Windows.Controls.StackPanel
    $stackPanel.Orientation = "Vertical"
    $stackPanel.Margin = "20"

    $textBlock = New-Object Windows.Controls.TextBlock
    $textBlock.Text = "Please enter the date and time to set:"
    $textBlock.Margin = "0,0,0,10"
    $stackPanel.Children.Add($textBlock)

    $grid = New-Object Windows.Controls.Grid
    $grid.Margin = "0,10,0,10"

    for ($i = 0; $i -lt 6; $i++) {
        $grid.ColumnDefinitions.Add((New-Object Windows.Controls.ColumnDefinition))
        $grid.RowDefinitions.Add((New-Object Windows.Controls.RowDefinition))
    }

    $labels = @("Year", "Month", "Day", "Hour", "Minute", "Second")
    $textBoxes = @()

    $currentDate = Get-Date

    for ($i = 0; $i -lt 6; $i++) {
        $label = New-Object Windows.Controls.TextBlock
        $label.Text = $labels[$i]
        $label.Margin = "5"
        $label.VerticalAlignment = "Center"
        $grid.Children.Add($label)
        [Windows.Controls.Grid]::SetRow($label, $i)
        [Windows.Controls.Grid]::SetColumn($label, 0)

        $textBox = New-Object Windows.Controls.TextBox
        $textBox.Width = 100
        $textBox.Margin = "5"
        switch ($labels[$i]) {
            "Year" { $textBox.Text = $currentDate.Year }
            "Month" { $textBox.Text = $currentDate.Month }
            "Day" { $textBox.Text = $currentDate.Day }
            "Hour" { $textBox.Text = $currentDate.Hour }
            "Minute" { $textBox.Text = $currentDate.Minute }
            "Second" { $textBox.Text = $currentDate.Second }
        }
        $grid.Children.Add($textBox)
        [Windows.Controls.Grid]::SetRow($textBox, $i)
        [Windows.Controls.Grid]::SetColumn($textBox, 1)

        $textBoxes += $textBox
    }

    $stackPanel.Children.Add($grid)

    $button = New-Object Windows.Controls.Button
    $button.Content = "OK"
    $button.Margin = "0,10,0,0"
    $button.Width = 100
    $button.HorizontalAlignment = "Center"
    $button.IsDefault = $true
    $button.Add_Click({
        $window.DialogResult = $true
        $window.Close()
    })
    $stackPanel.Children.Add($button)

    $window.Content = $stackPanel
    $window.ShowDialog() | Out-Null

    return @{
        Year = $textBoxes[0].Text
        Month = $textBoxes[1].Text
        Day = $textBoxes[2].Text
        Hour = $textBoxes[3].Text
        Minute = $textBoxes[4].Text
        Second = $textBoxes[5].Text
    }
}

# Check if the computer list file exists
if (-Not (Test-Path -Path $computerListPath)) {
    Write-Host "Computer list file not found: $computerListPath" -ForegroundColor Red
    exit 1  # Exit the script with a non-zero status
}

# Read the computer names from the file
$computers = Get-Content -Path $computerListPath

# Prompt user for the date and time
$dateTimeInput = Show-DateTimeDialog
try {
    $currentDateTime = Get-Date -Year $dateTimeInput.Year -Month $dateTimeInput.Month -Day $dateTimeInput.Day -Hour $dateTimeInput.Hour -Minute $dateTimeInput.Minute -Second $dateTimeInput.Second
} catch {
    Write-Host "Invalid date format. Please use the format: yyyy-MM-dd HH:mm:ss" -ForegroundColor Red
    exit 1
}

# Prompt user for credentials to connect to remote computers
$credential = Get-Credential

# Array to hold session objects
$sessions = @()

# Create sessions for each computer
foreach ($computer in $computers) {
    try {
        $session = New-PSSession -ComputerName $computer -Credential $credential
        $sessions += $session
        Write-Host "Session created for computer: $computer" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to create session for computer: $computer. Exception: $_" -ForegroundColor Red
    }
}

# Set the time on each remote computer
Invoke-Command -Session $sessions -ScriptBlock {
    param ($currentDateTime)
    Set-Date -Date $currentDateTime -ErrorAction Stop
} -ArgumentList $currentDateTime -ErrorAction Continue -ErrorVariable failedComputers

# Check for failures
foreach ($session in $sessions) {
    if ($failedComputers -contains $session.ComputerName) {
        Write-Host "ERROR: Failed to set time on computer: $($session.ComputerName)" -ForegroundColor Red
    } else {
        Write-Host "SUCCESS: Time set on computer: $($session.ComputerName)" -ForegroundColor Green
    }
}

# Close all sessions
foreach ($session in $sessions) {
    try {
        Remove-PSSession -Session $session
        Write-Host "Session closed for computer: $($session.ComputerName)" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to close session for computer: $($session.ComputerName). Exception: $_" -ForegroundColor Red
    }
}

Write-Host "Time synchronization process completed." -ForegroundColor Green