# PowerShell Scripts Repository

Welcome to my PowerShell Scripts repository! This is a curated collection of scripts aimed at simplifying and speeding up system administration tasks. The repository is organized into two main folders, each tailored for specific scenarios: `local` for scripts running directly on a local machine, and `remote` for scripts that execute tasks on other computers across a network.

As an IT professional, I leverage PowerShell to automate and streamline repetitive processes, reducing manual effort and enhancing system management efficiency.

## Repository Structure

### 1. `local`
The `local` folder contains scripts designed to run locally on your machine. These scripts cover various tasks aimed at automating system configuration, maintenance, and routine administrative duties directly on the machine in use.

### 2. `remote`
The `remote` folder includes scripts that are intended for executing tasks remotely from one computer to others within the network. These scripts utilize PowerShell’s remoting capabilities, allowing for efficient system management across multiple devices, ideal for tasks like deploying updates, collecting system information, and enforcing policies across networked computers.

## Purpose

The scripts in this repository serve to automate and simplify daily system management tasks, helping to eliminate repetitive manual steps, improve accuracy, and save time. By using PowerShell's robust capabilities, these scripts can manage both local and remote tasks effectively, making them valuable tools in any IT admin's toolkit.

## Prerequisites

- **PowerShell**: Ensure that PowerShell is installed on your system (PowerShell 5.1 or later is recommended for enhanced remoting support).
- **Administrator Rights**: Some scripts, especially in the `remote` folder, may require administrator permissions.
- **PowerShell Remoting**: For scripts in the `remote` folder, PowerShell Remoting must be enabled on both the initiating machine and the target machines.

## Usage

Each script includes comments to guide you through its specific functionality, required parameters, and any prerequisites. Be sure to read these details and make any necessary modifications before running a script in a production environment. Testing in a controlled environment is recommended.

---

These scripts are continually updated to stay in line with best practices in system administration. Contributions, issues, and forks are welcome to help expand the repository’s functionality.

Happy scripting! 
