# SQLVersionTools Installation Guide

This guide provides step-by-step instructions for installing SQLVersionTools on your system.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installing the SSMS Extension](#installing-the-ssms-extension)
3. [Installing the Background Service](#installing-the-background-service)
4. [Verification](#verification)
5. [Configuration](#configuration)
6. [Troubleshooting](#troubleshooting)
7. [Uninstallation](#uninstallation)

## Prerequisites

Before installing SQLVersionTools, ensure your system meets the following requirements:

### Required Software

1. **Windows 10/11 or Windows Server 2016+**

2. **SQL Server Management Studio 21**
   - Download from: https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms
   - Close all SSMS instances before installation

3. **.NET 8.0 Runtime**
   - Download from: https://dotnet.microsoft.com/download/dotnet/8.0
   - Install both Desktop Runtime and ASP.NET Core Runtime

4. **Git for Windows**
   - Download from: https://git-scm.com/download/win
   - Ensure Git is added to system PATH during installation
   - Verify installation: Open Command Prompt and run `git --version`

5. **SQL Server 2016 or later**
   - Any edition (Express, Standard, Enterprise)
   - SQL Server authentication or Windows authentication configured

### Permissions

- **Administrator rights** on the local machine (required for service installation)
- **db_owner** or **sysadmin** role on SQL Server databases you want to version control

## Installing the SSMS Extension

The SSMS extension provides the user interface within SQL Server Management Studio.

### Step 1: Close SSMS

Ensure all instances of SQL Server Management Studio are closed before proceeding.

### Step 2: Run the VSIX Installer

1. Navigate to the installation folder
2. Double-click **SQLVersionTools.Main.vsix**
3. The Visual Studio Extension Installer will launch

### Step 3: Complete the Installation

1. Click **Install** when the installer window appears
2. Select **SQL Server Management Studio** if prompted to choose target applications
3. Wait for the installation to complete (usually 10-30 seconds)
4. Click **Close** when finished

### Step 4: Verify Extension Installation

1. Launch SQL Server Management Studio
2. Connect to any SQL Server instance
3. In Object Explorer, expand a server and right-click on a database
4. You should see **SQLVersionTools** in the context menu

> **Note**: If the menu item doesn't appear, restart SSMS completely (ensure it's not running in the background).

## Installing the Background Service

The background service handles synchronization and monitoring tasks.

### Step 1: Extract Service Files (if needed)

If you received a compressed package:
1. Extract all files to a permanent location (e.g., `C:\Program Files\SQLVersionTools\Service\`)
2. Do NOT run the service from temporary or user profile directories

### Step 2: Run Installation Script as Administrator

1. Navigate to the Service folder in the installation package
2. Right-click **InstallService.bat**
3. Select **Run as administrator**
4. A Command Prompt window will appear showing installation progress

The script will:
- Copy service files to the system
- Create the Windows service
- Configure service to start automatically
- Start the service

### Step 3: Verify Service Installation

**Using Services Manager:**
1. Press `Win + R`, type `services.msc`, press Enter
2. Look for **SQLVersionTools Service** in the list
3. Status should be **Running**
4. Startup Type should be **Automatic**

**Using Command Prompt:**
```cmd
sc query SQLVersionToolsService
```

Expected output should show `STATE: 4 RUNNING`

## Verification

### Test the Complete Installation

1. **Open SSMS** and connect to a SQL Server instance

2. **Verify Extension Menu**
   - In Object Explorer, right-click on any database
   - Confirm **SQLVersionTools** menu appears with options:
     - Link to Git
     - Commit Changes
     - View History
     - Settings

3. **Test Service Connection**
   - Right-click a database → **SQLVersionTools** → **Link to Git**
   - The dialog should open without errors
   - If you see connection errors, check the service is running

4. **Check Service Logs** (optional)
   - Navigate to: `C:\%AppData\SQLVersionTools\Logs\`
   - Open the most recent log file
   - Verify no critical errors are present

## Configuration

### Git Configuration

Ensure Git is configured with your identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Service Configuration

The service configuration file is located at:
```
C:\%AppData\SQLVersionTools\config.json
```

Default settings are usually sufficient. Advanced users can modify:
- Log level (Information, Warning, Error, Debug)
- Sync intervals
- File permissions

### Firewall Considerations

If using remote Git repositories over HTTPS:
- No additional firewall configuration needed

If using SSH for Git:
- Ensure outbound connections on port 22 are allowed
- Configure SSH keys as per your Git hosting provider's documentation

## Troubleshooting

### Extension Not Appearing in SSMS

**Problem**: SQLVersionTools menu doesn't appear after installation

**Solutions**:
1. Verify SSMS version is 21 or later: Help → About
2. Completely close SSMS (check Task Manager for ssms.exe processes)
3. Restart SSMS as Administrator
4. Reinstall the VSIX file
5. Check SSMS Extension Manager: Extensions → Manage Extensions → look for SQLVersionTools

### Service Won't Start

**Problem**: SQLVersionTools Service fails to start

**Solutions**:
1. Verify .NET 8.0 Runtime is installed:
   ```cmd
   dotnet --list-runtimes
   ```
   Should show `Microsoft.NETCore.App 8.0.x`

2. Check Windows Event Viewer:
   - Windows Logs → Application
   - Look for SQLVersionTools errors

3. Run service in console mode for diagnostics:
   ```cmd
   cd "C:\Program Files\SQLVersionTools\Service"
   SQLVersionTools.Service.exe
   ```

4. Verify permissions on service directory and `C:\ProgramData\SQLVersionTools\`

### Git Operations Fail

**Problem**: Cannot clone, commit, or push to repositories

**Solutions**:
1. Verify Git installation:
   ```cmd
   git --version
   ```

2. Test Git credentials:
   ```cmd
   git ls-remote https://github.com/yourrepo/test.git
   ```

3. Check Git configuration:
   ```cmd
   git config --list
   ```

4. For HTTPS repos: Ensure Git Credential Manager is configured
5. For SSH repos: Verify SSH keys are set up correctly

### Permission Denied Errors

**Problem**: "Access denied" when linking database or committing

**Solutions**:
1. Verify you have `db_owner` rights on the database
2. Check file system permissions on the target repository folder
3. Run SSMS as Administrator (for testing only, not recommended for regular use)
4. Ensure the service account has read/write access to repository paths

### Performance Issues

**Problem**: Slow synchronization or high CPU usage

**Solutions**:
1. Check database size and number of objects
2. Use .gitignore patterns to exclude unnecessary objects
3. Adjust service sync interval in config file
4. Ensure antivirus excludes repository and service folders

## Uninstallation

### Removing the Service

1. Right-click **UninstallService.bat**
2. Select **Run as administrator**
3. Wait for confirmation message

Or manually:
```cmd
sc stop SQLVersionToolsService
sc delete SQLVersionToolsService
```

### Removing the SSMS Extension

1. Close all SSMS instances
2. Open Command Prompt as Administrator
3. Run:
   ```cmd
   "C:\Program Files (x86)\Microsoft Visual Studio\2022\SQL\Common7\IDE\VSIXInstaller.exe" /uninstall:SQLVersionTools.Main
   ```

Or through SSMS:
1. Extensions → Manage Extensions
2. Find SQLVersionTools
3. Click **Uninstall**
4. Restart SSMS

### Cleaning Up Files

After uninstallation, you may delete:
- `C:\Program Files\SQLVersionTools\`
- `C:\ProgramData\SQLVersionTools\`
- Repository `.sqlversiontools` configuration files

## Next Steps

After successful installation:

1. **Link Your First Database** - See main README.md for quick start guide
2. **Configure .gitignore** - Set up object filtering for your needs
3. **Test Commit Workflow** - Make a test change and commit it
4. **Review Documentation** - Familiarize yourself with all features

## Getting Help

If you encounter issues not covered in this guide:
- Check the GitHub issues page
- Review service logs in `C:\ProgramData\SQLVersionTools\Logs\`
- Contact your system administrator or DBA

## Version History

- **1.0.0** - Initial release with Git linking and commit functionality
- **1.1.0** - Added background service and auto-sync
- **1.2.0** - Enhanced SSMS integration and UI improvements
