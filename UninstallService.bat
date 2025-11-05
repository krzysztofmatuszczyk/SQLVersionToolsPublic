@echo off
setlocal enabledelayedexpansion

echo ========================================
echo SQLVersionTools Service Uninstaller
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
set INSTALL_DIR=C:\Program Files\SQLVersionTools\Service
set DATA_DIR=%APPDATA%\SQLVersionTools

echo Checking if service exists...
sc query %SERVICE_NAME% >nul 2>&1
if %errorLevel% neq 0 (
    echo Service is not installed
    echo.
    goto :CLEANUP_FILES
)

echo.
echo Stopping service...
sc stop %SERVICE_NAME%
if %errorLevel% equ 0 (
    echo Waiting for service to stop...
    timeout /t 5 /nobreak >nul
) else (
    echo Service was not running
)

echo.
echo Deleting service...
sc delete %SERVICE_NAME%
if %errorLevel% neq 0 (
    echo ERROR: Failed to delete service
    echo The service may still be stopping. Please wait a moment and try again.
    pause
    exit /b 1
)
echo Service deleted successfully

timeout /t 2 /nobreak >nul

:CLEANUP_FILES
echo.
set /p REMOVE_FILES="Remove service files from %INSTALL_DIR%? (Y/N): "
if /i "%REMOVE_FILES%"=="Y" (
    if exist "%INSTALL_DIR%" (
        echo Removing service files...
        rmdir /s /q "%INSTALL_DIR%"
        echo Service files removed
    ) else (
        echo Service directory not found, skipping
    )
)

echo.
set /p REMOVE_DATA="Remove configuration and logs from %DATA_DIR%? (Y/N): "
if /i "%REMOVE_DATA%"=="Y" (
    if exist "%DATA_DIR%" (
        echo Removing data and logs...
        rmdir /s /q "%DATA_DIR%"
        echo Data and logs removed
    ) else (
        echo Data directory not found, skipping
    )
)

echo.
echo ========================================
echo Uninstallation Complete
echo ========================================
echo.
echo SQLVersionTools Service has been uninstalled
echo.
pause
