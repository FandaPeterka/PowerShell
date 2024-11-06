# This PowerShell script prepares user data in a .csv file format for Active Directory (AD) account creation.
# It processes an input CSV file containing names with Czech diacritical marks and formats them by:
# - Removing Czech diacritical marks (accents) from characters.
# - Capitalizing the first letter of each name to ensure consistency.
# - Saving the cleaned data in an output CSV file, ready for AD user creation.

# Script Overview:
# - Reads data from an input CSV file specified by $inputCsv.
# - Encodes the file in Windows-1250 encoding for compatibility with Czech characters.
# - Cleans each row by:
#   - Removing Czech diacritical marks from first and last names.
#   - Capitalizing the first letter of each name for a standardized format.
# - Saves the processed data in an output CSV file defined by $outputCsv, formatted without quotes and headers.

# Usage Notes:
# - Set the $inputCsv and $outputCsv paths to your desired input and output file locations.
# - Ensure the input file has columns for first and last names, separated by semicolons (;).
# - The output CSV file can then be used directly for AD user creation, ensuring names are in the proper format.

# Function to remove Czech diacritics from text
function Remove-Diacritics {
    param (
        [string]$text
    )

    # Replace accented Czech characters with their non-accented equivalents
    $text = $text -replace '[áàâä]', 'a'
    $text = $text -replace '[č]', 'c'
    $text = $text -replace '[ď]', 'd'
    $text = $text -replace '[éěë]', 'e'
    $text = $text -replace '[íìîï]', 'i'
    $text = $text -replace '[ň]', 'n'
    $text = $text -replace '[óòôö]', 'o'
    $text = $text -replace '[ř]', 'r'
    $text = $text -replace '[š]', 's'
    $text = $text -replace '[ť]', 't'
    $text = $text -replace '[úùûüů]', 'u'
    $text = $text -replace '[ý]', 'y'
    $text = $text -replace '[ž]', 'z'
    $text = $text -replace '[ÁÀÂÄ]', 'A'
    $text = $text -replace '[Č]', 'C'
    $text = $text -replace '[Ď]', 'D'
    $text = $text -replace '[ÉĚË]', 'E'
    $text = $text -replace '[ÍÌÎÏ]', 'I'
    $text = $text -replace '[Ň]', 'N'
    $text = $text -replace '[ÓÒÔÖ]', 'O'
    $text = $text -replace '[Ř]', 'R'
    $text = $text -replace '[Š]', 'S'
    $text = $text -replace '[Ť]', 'T'
    $text = $text -replace '[ÚÙÛÜ]', 'U'
    $text = $text -replace '[Ý]', 'Y'
    $text = $text -replace '[Ž]', 'Z'
    
    return $text
}

# Function to capitalize the first letter
function Capitalize-FirstLetter {
    param (
        [string]$text
    )

    if ($text.Length -gt 0) {
        return ($text.Substring(0,1).ToUpper() + $text.Substring(1).ToLower())
    }
    return $text
}

# Path to the input and output CSV files
$inputCsv = "C:\input\file.csv"
$outputCsv = "C:\output\file.csv"

# .NET StreamReader for reading the file with Windows-1250 encoding
$encoding = [System.Text.Encoding]::GetEncoding("windows-1250")
$reader = [System.IO.StreamReader]::new($inputCsv, $encoding)

# Read the entire file content
$content = $reader.ReadToEnd()
$reader.Close()

# Split file into lines
$lines = $content -split "`r?`n"

# Create an empty list for cleaned data
$cleanedData = @()

# Iterate over each line and remove diacritics
foreach ($line in $lines) {
    # Split the line by semicolons
    $columns = $line -split ";"
    
    if ($columns.Length -ge 2) {
        # Clean the first and last names by removing diacritics and capitalizing the first letter
        $firstName = Capitalize-FirstLetter (Remove-Diacritics $columns[0].Trim())
        $lastName = Capitalize-FirstLetter (Remove-Diacritics $columns[1].Trim())
        
        # Add the cleaned line to the list
        $cleanedData += "$firstName;$lastName"
    }
}

# Save to file without quotes and without headers
$cleanedData -join "`n" | Out-File -FilePath $outputCsv -Encoding utf8

Write-Host "The file has been processed and saved as $outputCsv in the correct format."