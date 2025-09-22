@echo off
setlocal

REM IPTV Harmonization Launcher (Windows Batch)
REM Launches the PowerShell GUI interface

echo.
echo 📺 Launching IPTV Harmonization System...
echo ------------------------------------------
powershell -ExecutionPolicy Bypass -File "%~dp0run_gui.ps1"

endlocal
