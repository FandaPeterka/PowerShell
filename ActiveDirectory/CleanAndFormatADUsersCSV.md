# PrepareADUserCSV.ps1

## Overview

This PowerShell script, `CleanAndFormatADUsersCSV.ps1`, prepares a CSV file with cleaned user data for Active Directory (AD) account creation. It processes an input CSV file with Czech diacritical marks in names, removes the accents, capitalizes the first letter of each name, and outputs a formatted CSV file ready for AD import.

## Key Features

- **Diacritic Removal**: Removes Czech-specific diacritical marks (e.g., `Š` becomes `S`).
- **Capitalization**: Capitalizes the first letter of each name.
- **Output Formatting**: Saves the processed data in a CSV file, formatted without headers or quotes.

## Usage

1. **Set Input and Output Paths**:
   - Edit the `$inputCsv` and `$outputCsv` variables in the script to specify the input and output file paths.
   - The default paths are:
     - Input: `C:\input\file.csv`
     - Output: `C:\output\file.csv`

2. **Format the Input CSV**:
   - Ensure the input file contains first and last names separated by a semicolon (`;`), encoded in Windows-1250.

3. **Run the Script**:
   - Open PowerShell and execute the script:
     ```powershell
     .\CleanAndFormatADUsersCSV.ps1
     ```

4. **Check the Output**:
   - The processed data will be saved in the specified output path in UTF-8 encoding.

## Example

### Input CSV (`file.csv`):
```plaintext
Jana;Nováková
Petr;Šťastný
```

### Output CSV (`file.csv`):
```plaintext
Jana;Novakova
Petr;Stastny
```

## Notes

- **Input Encoding**: The input CSV file must be in Windows-1250 encoding.
- **Data Structure**: Adjustments may be necessary for other character sets or naming conventions.

---
