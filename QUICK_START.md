# Quick Start Guide

Get up and running with SQLVersionTools in just a few minutes.

## Prerequisites Checklist

Before you begin, ensure you have:

- [ ] SQL Server Management Studio 21 installed
- [ ] .NET 8.0 Runtime installed
- [ ] Git for Windows installed
- [ ] Administrator rights on your machine
- [ ] Access to a SQL Server database with db_owner permissions

## Installation (5 minutes)

### 1. Install SSMS Extension

1. Close all SSMS instances
2. Double-click `SQLVersionTools.Main.vsix`
3. Click **Install**
4. Wait for completion

### 2. Install Background Service

1. Right-click `InstallService.bat`
2. Select **Run as administrator**
3. Wait for "Service installed successfully" message

### 3. Verify Installation

1. Open SSMS
2. Connect to any SQL Server
3. Right-click a database
4. Look for **SQLVersionTools** menu

## First Database Link (5 minutes)

### Step 1: Prepare Git Repository

Choose one of these options:

**Option A: Use Existing Repository**
```bash
cd C:\MyRepos
git clone https://github.com/youraccount/yourrepo.git
cd yourrepo
```

**Option B: Create New Repository**
```bash
mkdir C:\MyRepos\MyDatabase
cd C:\MyRepos\MyDatabase
git init
git remote add origin https://github.com/youraccount/myrepo.git
```

### Step 2: Link Database

1. In SSMS Object Explorer, right-click your database
2. Select **SQLVersionTools** → **Link to Git**
3. Fill in the wizard:
   - **Repository Path**: `C:\MyRepos\MyDatabase`
   - **Branch**: `main` (or your preferred branch)
   - **Object Types**: Check Stored Procedures, Views, Functions, Triggers
   - **Options**: Leave defaults for now
4. Click **Link**

### Step 3: Initial Sync

The tool will:
- Script all selected objects from your database
- Create organized folder structure
- Create `.sqlversiontools` configuration file
- Prepare files for Git commit

### Step 4: Review and Commit

1. Open your repository folder in File Explorer
2. Review the generated folder structure:
   ```
   MyDatabase/
   ├── StoredProcedures/
   ├── Views/
   ├── Functions/
   └── Triggers/
   ```
3. In SSMS, right-click the database again
4. Select **SQLVersionTools** → **Commit Changes**
5. Enter commit message: "Initial database snapshot"
6. Click **Commit**

## Making Your First Change (3 minutes)

### Scenario: Modify a Stored Procedure

1. In SSMS, locate a stored procedure
2. Make a change (e.g., add a comment or modify logic)
3. Execute the ALTER PROCEDURE script
4. Right-click the database → **SQLVersionTools** → **Commit Changes**
5. Review the changes shown in the dialog
6. Enter commit message: "Updated uspGetUsers logic"
7. Click **Commit**

### View History

1. Right-click database → **SQLVersionTools** → **View History**
2. See your commits and changes

## Common Operations

### Commit Multiple Changes

After making several changes to different objects:

1. **SQLVersionTools** → **Commit Changes**
2. Review all modified objects
3. Optionally uncheck objects you don't want to commit
4. Enter descriptive commit message
5. Click **Commit**

### Push to Remote

After committing:

1. **SQLVersionTools** → **Push to Remote**
2. Enter credentials if prompted
3. Wait for push completion

### Ignore Specific Objects

Create or edit `.gitignore` in your repository:

```
# Ignore all temp objects
*_temp.*
*_backup.*

# Ignore specific procedure
StoredProcedures/dbo.uspDebugHelper.sql

# Ignore all objects in dbo schema starting with test
**/dbo.test*.sql
```

### Unlink Database

To stop version control on a database:

1. Right-click database → **SQLVersionTools** → **Unlink from Git**
2. Confirm the action
3. Repository files remain unchanged

## Configuration Options

### Customize Folder Structure

Edit `.sqlversiontools` in your repository:

```json
{
  "links": [{
    "folderStructure": {
      "storedProcedures": "StoredProcs",
      "views": "Database/Views",
      "functions": "Database/Functions",
      "triggers": "Database/Triggers"
    }
  }]
}
```

### Exclude System Objects

In the Link wizard or `.sqlversiontools`:

```json
{
  "filters": {
    "excludeSystemObjects": true,
    "excludeTempTables": true,
    "customIgnorePatterns": [
      "*_backup",
      "temp_*",
      "test_*"
    ]
  }
}
```

## Troubleshooting Quick Fixes

### Extension Not Showing
- Restart SSMS completely (check Task Manager)
- Run SSMS as Administrator (once, for testing)

### Service Not Running
```cmd
sc query SQLVersionToolsService
sc start SQLVersionToolsService
```

### Git Authentication Issues
```bash
git config --global credential.helper manager-core
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Permission Errors
- Verify db_owner role on database
- Check write permissions on repository folder
- Ensure service is running

## Best Practices

### 1. Commit Messages
Use clear, descriptive messages:
- ✅ "Add uspGetActiveUsers procedure for dashboard"
- ✅ "Fix performance issue in vwOrderSummary"
- ❌ "Update"
- ❌ "Changes"

### 2. Branching Strategy
- Use `main` branch for production database
- Create feature branches for development:
  ```bash
  git checkout -b feature/new-reporting-procs
  ```

### 3. Regular Commits
- Commit after completing logical changes
- Don't wait until end of day
- Smaller commits are easier to review and rollback

### 4. Object Filtering
- Exclude test/temporary objects
- Don't version control auto-generated objects
- Keep .gitignore updated

### 5. Team Workflow
- Pull before making changes
- Communicate with team about schema changes
- Use descriptive branch names
- Review changes before committing

## Next Steps

Now that you're set up:

1. **Link Additional Databases** - Repeat the linking process for other databases
2. **Set Up Remote Repository** - Push to GitHub, Azure DevOps, or GitLab
3. **Configure Team Access** - Add team members to the repository
4. **Explore Advanced Features** - Branch management, conflict resolution
5. **Read Full Documentation** - See README.md and INSTALLATION.md

## Getting Help

- **Installation Issues**: See INSTALLATION.md
- **Feature Questions**: See README.md
- **Error Messages**: Check service logs at `C:\ProgramData\SQLVersionTools\Logs\`
- **Git Problems**: Run `git status` in repository folder
- **Report Issues**: Use GitHub issue tracker

## Useful Commands

### Check Service Status
```cmd
sc query SQLVersionToolsService
```

### View Service Logs
```cmd
notepad C:\ProgramData\SQLVersionTools\Logs\service-latest.log
```

### Verify Git Config
```bash
git config --list
```

### Test Git Connection
```bash
git ls-remote origin
```

### Check .NET Runtime
```cmd
dotnet --list-runtimes
```

Happy version controlling! 🚀
