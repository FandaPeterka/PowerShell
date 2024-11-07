# This PowerShell script provides a graphical interface for waking up Virtual Machines (VMs) using the Wake-On-LAN (WOL) protocol.
# It reads VM names and MAC addresses from an input file in a standard CSV format, displays the list of VMs for selection, and 
# sends a "magic packet" to the specified MAC addresses to power on the VMs. The script also checks if each VM responds 
# after the wake-up attempt.

# Script Overview:
# - Reads VM names and their MAC addresses from a CSV file defined by `$filePath`.
# - Displays a GUI with checkboxes for each VM, allowing selective wake-up operations.
# - Sends Wake-On-LAN "magic packets" to initiate power-on for selected VMs.
# - Pings each VM to confirm if it successfully woke up and is responsive.

# Key Components:
# - **Wake-On-LAN**: Sends a "magic packet" using the VM's MAC address.
# - **Machine Status Check**: Pings each VM after sending the packet to verify responsiveness.
# - **Select All Feature**: Provides a button to select all VMs at once.
# - **Credential Prompt**: Requests user credentials to authenticate ping requests and confirm VM status.

# Prerequisites:
# - Ensure each VM supports Wake-On-LAN and has the feature enabled in its network settings.
# - The script must run with appropriate permissions to send network packets and check VM status.

# CSV File Format:
# - The input file should be a CSV file with the following format:
#     VMName,MACAddress
# - Example:
#     VM1,00-14-22-01-23-45
#     VM2,00-14-22-67-89-AB

# Usage Instructions:
# 1. Update `$filePath` with the path to your CSV file containing VM names and MAC addresses in the above format.
# 2. Run the script in PowerShell with necessary permissions.
# 3. Select VMs from the GUI and click "Wake Up Selected VMs" to initiate the wake-up process.
# 4. The console will display feedback on each wake-up attempt and indicate whether each VM is responsive.

Add-Type -AssemblyName PresentationFramework

# Path to the text file containing VM names and MAC addresses
$filePath = "C:\PS\computers_MAC.txt"

# Read the content of the file (expecting "VMName MACAddress" format)
$vms = @{}
Get-Content -Path $filePath | ForEach-Object {
    $splitLine = $_ -split " "
    if ($splitLine.Count -eq 2) {
        $vms[$splitLine[0]] = $splitLine[1]  # VMName as key, MACAddress as value
    }
}

# Function to send Wake-On-LAN magic packet
function Send-WakeOnLan {
    param (
        [string]$macAddress
    )

    # Convert MAC address string to byte array
    $macBytes = ($macAddress -split "[:-]") | ForEach-Object { [byte]('0x' + $_) }

    # Build the magic packet
    $magicPacket = (0..5 | ForEach-Object { 0xFF }) + (0..15 | ForEach-Object { $macBytes })
    
    # Convert magic packet to byte array
    $packetBytes = $magicPacket | ForEach-Object { [byte]$_ }

    # Send the packet via UDP
    $udpClient = New-Object System.Net.Sockets.UdpClient
    $udpClient.Connect([System.Net.IPAddress]::Broadcast, 9)
    $udpClient.Send($packetBytes, $packetBytes.Length)
    $udpClient.Close()
}

# Function to check if the machine is awake by pinging it
function Check-MachineStatus {
    param (
        [string]$vmName,
        [System.Management.Automation.PSCredential]$credential
    )

    try {
        # Perform a simple ping to check if the VM is responsive
        $pingResult = Test-Connection -ComputerName $vmName -Count 1 -Credential $credential -Quiet
        return $pingResult
    } catch {
        return $false
    }
}

# Create the main window
$window = New-Object System.Windows.Window
$window.Title = "Wake Up VMs"
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
$titleLabel.Content = "Select VMs to Wake Up"
$titleLabel.FontSize = 16
$titleLabel.FontWeight = "Bold"
$titleLabel.HorizontalAlignment = "Center"
$titleLabel.Margin = "0,0,0,10"
[System.Windows.Controls.Grid]::SetRow($titleLabel, 0)
[System.Windows.Controls.Grid]::SetColumn($titleLabel, 0)
$grid.Children.Add($titleLabel)

# Create a scrollviewer for VM checkboxes
$vmsScrollViewer = New-Object System.Windows.Controls.ScrollViewer
$vmsScrollViewer.VerticalScrollBarVisibility = "Auto"
[System.Windows.Controls.Grid]::SetRow($vmsScrollViewer, 1)
[System.Windows.Controls.Grid]::SetRowSpan($vmsScrollViewer, 2)
[System.Windows.Controls.Grid]::SetColumn($vmsScrollViewer, 0)
$grid.Children.Add($vmsScrollViewer)

$vmsStackPanel = New-Object System.Windows.Controls.StackPanel
$vmsStackPanel.Orientation = "Vertical"
$vmsScrollViewer.Content = $vmsStackPanel

# Add checkboxes for each VM
$vmCheckboxes = @{}
foreach ($vm in $vms.Keys) {
    $checkbox = New-Object System.Windows.Controls.CheckBox
    $checkbox.Content = $vm
    $checkbox.Margin = "0,5,0,5"
    $vmsStackPanel.Children.Add($checkbox)
    $vmCheckboxes[$vm] = $checkbox
}

# Add a button to select all VMs
$selectAllButton = New-Object System.Windows.Controls.Button
$selectAllButton.Content = "Select All"
$selectAllButton.Width = 100
$selectAllButton.Height = 30
$selectAllButton.Margin = "0,10,0,0"
$selectAllButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($selectAllButton, 3)
[System.Windows.Controls.Grid]::SetColumn($selectAllButton, 0)
$grid.Children.Add($selectAllButton)

# Add a button to wake up selected VMs
$wakeUpButton = New-Object System.Windows.Controls.Button
$wakeUpButton.Content = "Wake Up Selected VMs"
$wakeUpButton.Width = 200
$wakeUpButton.Height = 40
$wakeUpButton.Margin = "10,20,0,0"
$wakeUpButton.Background = [System.Windows.Media.Brushes]::LightGreen
$wakeUpButton.HorizontalAlignment = "Center"
[System.Windows.Controls.Grid]::SetRow($wakeUpButton, 4)
[System.Windows.Controls.Grid]::SetColumn($wakeUpButton, 0)
$grid.Children.Add($wakeUpButton)

# Event handler to select all VMs
$selectAllButton.Add_Click({
    foreach ($checkbox in $vmCheckboxes.Values) {
        $checkbox.IsChecked = $true
    }
})

# Event handler to wake up selected VMs
$wakeUpButton.Add_Click({
    $selectedVMs = @()
    foreach ($vm in $vmCheckboxes.Keys) {
        if ($vmCheckboxes[$vm].IsChecked -eq $true) {
            $selectedVMs += $vm
        }
    }

    if ($selectedVMs.Count -eq 0) {
        Write-Host "No VMs selected." -ForegroundColor Yellow
        return
    }

    # Request credentials for connecting to the VMs
    $credential = Get-Credential

    foreach ($vm in $selectedVMs) {
        try {
            $macAddress = $vms[$vm]
            Send-WakeOnLan -macAddress $macAddress
            Write-Host "Sent magic packet to $vm." -ForegroundColor Green

            # Check if the VM is awake
            Start-Sleep -Seconds 5  # Give it a few seconds to wake up
            $isAwake = Check-MachineStatus -vmName $vm -credential $credential
            if ($isAwake) {
                Write-Host "$vm is awake and responsive." -ForegroundColor Green
            } else {
                Write-Host "$vm did not respond after wake-up attempt." -ForegroundColor Red
            }
        } catch {
            Write-Host "Failed to send magic packet to $vm $_" -ForegroundColor Red
        }
    }
})

# Load the files into the ListBox
LoadFiles

# Show the window
$window.ShowDialog()
