@echo off
sc start "SQLVersionTools Sync Service"
timeout /t 3 /nobreak >nul
sc query "SQLVersionTools Sync Service"
pause
