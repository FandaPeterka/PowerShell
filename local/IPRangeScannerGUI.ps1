# PowerShell Script: IP Range Scanner GUI
# ---------------------------------------
# This PowerShell script provides a graphical interface (GUI) for scanning an IP range to identify active devices.
# Administrators can input a start and end IP address, and the script will ping each address within the range,
# resolve any hostnames, and log the results. This tool is intended for network management and discovery.

# Key Functionalities:
# - Prompts the user to input a start and end IP address.
# - Attempts to ping each IP within the specified range and identifies any active devices.
# - Resolves the DNS hostname for each detected IP address.
# - Displays real-time scan results in the PowerShell console and logs all detected devices to a file.
# - Creates a log file in the "C:\PS\Logs" directory, with entries for each active IP found.

# Notes:
# - Update the `$logDir` variable if you prefer to store logs in a different directory.
# - Ensure the `C:\PS\Logs` directory exists or has the appropriate permissions for the script to write log files.
# - Large IP ranges may take significant time to scan; use a smaller range for faster results.
# - This script requires PowerShell with Windows Presentation Foundation (WPF) libraries enabled for the GUI.

# Example Usage:
# - Input the desired IP range in the GUI.
# - Click "Start Scanning" to initiate the process.
# - Review results displayed in the PowerShell console and check the log file in `C:\PS\Logs` upon completion.

# ----------------------------------------------------------------------

Add-Type -AssemblyName PresentationFramework

# Create the main window
$window = New-Object System.Windows.Window
$window.Title = "IP Range Scanner"
$window.Width = 500
$window.Height = 450
$window.WindowStartupLocation = "CenterScreen"

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

# Create labels and textboxes for start and end IP addresses
$startIPLabel = New-Object System.Windows.Controls.Label
$startIPLabel.Content = "Start IP Address:"
$startIPLabel.VerticalAlignment = "Center"
$startIPLabel.HorizontalAlignment = "Left"
$startIPLabel.Margin = "0,0,0,10"
[System.Windows.Controls.Grid]::SetRow($startIPLabel, 0)
$grid.Children.Add($startIPLabel)

$startIPTextBox = New-Object System.Windows.Controls.TextBox
$startIPTextBox.Margin = "0,0,0,10"
$startIPTextBox.Width = 460
[System.Windows.Controls.Grid]::SetRow($startIPTextBox, 1)
$grid.Children.Add($startIPTextBox)

$endIPLabel = New-Object System.Windows.Controls.Label
$endIPLabel.Content = "End IP Address:"
$endIPLabel.VerticalAlignment = "Center"
$endIPLabel.HorizontalAlignment = "Left"
$endIPLabel.Margin = "0,0,0,10"
[System.Windows.Controls.Grid]::SetRow($endIPLabel, 2)
$grid.Children.Add($endIPLabel)

$endIPTextBox = New-Object System.Windows.Controls.TextBox
$endIPTextBox.Margin = "0,0,0,10"
$endIPTextBox.Width = 460
[System.Windows.Controls.Grid]::SetRow($endIPTextBox, 3)
$grid.Children.Add($endIPTextBox)

# Create a button to start scanning
$scanButton = New-Object System.Windows.Controls.Button
$scanButton.Content = "Start Scanning"
$scanButton.Width = 460
$scanButton.Height = 30
$scanButton.Margin = "5,0,5,0"
[System.Windows.Controls.Grid]::SetRow($scanButton, 4)
$grid.Children.Add($scanButton)

# Function to increment the IP address
function Get-NextIPAddress {
    param (
        [string]$ipAddress
    )

    $bytes = $ipAddress.Split('.') | ForEach-Object { [int]$_ }
    for ($i = 3; $i -ge 0; $i--) {
        if ($bytes[$i] -lt 255) {
            $bytes[$i]++
            break
        } else {
            $bytes[$i] = 0
        }
    }
    return ($bytes -join '.')
}

# Function to resolve the DNS name of an IP address
function Resolve-DeviceName {
    param (
        [string]$ipAddress
    )

    try {
        $hostname = (Resolve-DnsName -Name $ipAddress -ErrorAction Stop).NameHost
        return $hostname
    } catch {
        return "Unknown"
    }
}

# Initialize found devices list
$foundDevices = @()

# Function to log found devices
function Log-FoundDevices {
    param (
        [string]$logFile,
        [array]$devices
    )

    Add-Content -Path $logFile -Value "Scanning complete. Found devices:`n"
    $devices | ForEach-Object {
        Write-Host $_ -ForegroundColor Yellow
        Add-Content -Path $logFile -Value "$_`n"
    }
}

# Function to start scanning
$scanButton.Add_Click({
    $scanButton.IsEnabled = $false
    $startIP = $startIPTextBox.Text
    $endIP = $endIPTextBox.Text

    # Create log directory if it doesn't exist
    $logDir = "C:\PS\Logs"
    if (-not (Test-Path -Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir | Out-Null
    }

    # Create log file
    $logFile = "$logDir\ScanLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    New-Item -ItemType File -Path $logFile | Out-Null

    try {
        # Iterate through the IP range
        $ip = $startIP
        while ($ip -ne $endIP) {
            if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
                $hostname = Resolve-DeviceName -ipAddress $ip
                $message = "IP Address: $ip - Hostname: $hostname "
                Write-Host $message -ForegroundColor Green
                $foundDevices += $message
            } else {
                $message = "No response from IP Address: $ip"
                Write-Host $message -ForegroundColor Red
            }
            $ip = Get-NextIPAddress -ipAddress $ip

            # Allow UI updates
            Start-Sleep -Milliseconds 100
        }

        # Also check the end IP
        if (Test-Connection -ComputerName $endIP -Count 1 -Quiet) {
            $hostname = Resolve-DeviceName -ipAddress $endIP
            $message = "IP Address: $endIP - Hostname: $hostname"
            Write-Host $message -ForegroundColor Green
            $foundDevices += $message
        } else {
            $message = "No response from IP Address: $endIP"
            Write-Host $message -ForegroundColor Red
        }
    } finally {
        # Log found devices even if script is terminated early
        Log-FoundDevices -logFile $logFile -devices $foundDevices
        $scanButton.IsEnabled = $true
    }
})

# Add event handler for application exit
$window.add_Closed({
    # Create log directory if it doesn't exist
    $logDir = "C:\PS\Logs"
    if (-not (Test-Path -Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir | Out-Null
    }

    # Create log file
    $logFile = "$logDir\ScanLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    New-Item -ItemType File -Path $logFile | Out-Null

    # Log found devices on application exit
    Log-FoundDevices -logFile $logFile -devices $foundDevices
})

# Show the window
$window.ShowDialog()