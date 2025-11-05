@echo off
setlocal enabledelayedexpansion

echo ========================================
echo SQLVersionTools Service Installer
echo ========================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Administrator privileges required
    echo Please run this script as Administrator
    echo.
    pause
    exit /b 1
)

set SERVICE_NAME=SQLVersionToolsService
set SERVICE_DISPLAY_NAME=SQLVersionTools Background Service
set SERVICE_DESCRIPTION=Background service for SQLVersionTools - handles synchronization and monitoring of SQL Server database objects with Git repositories
set INSTALL_DIR=C:\Program Files\SQLVersionTools\Service
set DATA_DIR=%APPDATA%\SQLVersionTools
set LOGS_DIR=%DATA_DIR%\Logs
set SOURCE_DIR=d:\Service

echo Checking .NET 8.0 Runtime...
dotnet --list-runtimes | findstr "Microsoft.NETCore.App 8.0" >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: .NET 8.0 Runtime not found
    echo Please install .NET 8.0 Runtime from:
    echo https://dotnet.microsoft.com/download/dotnet/8.0
    echo.
    pause
    exit /b 1
)
echo .NET 8.0 Runtime found

echo.
echo Checking if service is already installed...
sc query %SERVICE_NAME% >nul 2>&1
if %errorLevel% equ 0 (
    echo Service already exists, stopping...
    sc stop %SERVICE_NAME%
    timeout /t 3 /nobreak >nul
    echo Deleting existing service...
    sc delete %SERVICE_NAME%
    timeout /t 2 /nobreak >nul
)

echo.


if not exist "%SOURCE_DIR%\SQLVersionTools.Service.exe" (
    echo ERROR: Service executable not found
    echo Expected: %SOURCE_DIR%\SQLVersionTools.Service.exe
    echo.
    pause
    exit /b 1
)
echo Source files verified

echo.
echo Creating installation directory...
if exist "%INSTALL_DIR%" (
    echo Removing old installation...
    rmdir /s /q "%INSTALL_DIR%"
)
mkdir "%INSTALL_DIR%"

echo.
echo Creating data directories...
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
if not exist "%LOGS_DIR%" mkdir "%LOGS_DIR%"

echo.
echo Copying service files...
xcopy /E /I /Y "%SOURCE_DIR%\*" "%INSTALL_DIR%\" >nul
if %errorLevel% neq 0 (
    echo ERROR: Failed to copy service files
    pause
    exit /b 1
)
echo Service files copied successfully

echo.
echo Installing Windows service...
sc create %SERVICE_NAME% binPath= "\"%INSTALL_DIR%\SQLVersionTools.Service.exe\"" start= auto DisplayName= "%SERVICE_DISPLAY_NAME%"
if %errorLevel% neq 0 (
    echo ERROR: Failed to create service
    pause
    exit /b 1
)

echo.
echo Configuring service...
sc description %SERVICE_NAME% "%SERVICE_DESCRIPTION%"
sc failure %SERVICE_NAME% reset= 86400 actions= restart/60000/restart/60000/restart/60000

echo.
echo Starting service...
sc start %SERVICE_NAME%
if %errorLevel% neq 0 (
    echo WARNING: Service created but failed to start
    echo Check logs at: %LOGS_DIR%
    echo You can start it manually from Services (services.msc)
) else (
    echo Service started successfully
)

echo.
echo Verifying service status...
timeout /t 2 /nobreak >nul
sc query %SERVICE_NAME% | findstr "RUNNING" >nul
if %errorLevel% equ 0 (
    echo Service is RUNNING
) else (
    sc query %SERVICE_NAME% | findstr "STATE"
)

echo.
echo ========================================
echo Installation Summary
echo ========================================
echo Service Name: %SERVICE_NAME%
echo Install Location: %INSTALL_DIR%
echo Data Location: %DATA_DIR%
echo Logs Location: %LOGS_DIR%
echo.
echo Service installed successfully!
echo.
echo You can manage the service using:
echo   - Services Manager (services.msc)
echo   - sc query %SERVICE_NAME%
echo   - sc stop %SERVICE_NAME%
echo   - sc start %SERVICE_NAME%
echo.
pause
