@echo off
setlocal EnableDelayedExpansion

:: ─────────────────────────────────────────────
:: IPTV Harmonization System — GUI Launcher
:: Version: 1.0.0
:: Author: Andrew Pearen
:: Date: %DATE% %TIME%
:: ─────────────────────────────────────────────

echo.
echo ============================================
echo   IPTV Harmonization System — GUI Launcher
echo   Version 1.0.0
echo   Launching GUI from: gui\iptv_gui.py
echo ============================================
echo.

:: Set relative paths
set LOGDIR=logs
set LOGFILE=%LOGDIR%\gui_launch.log

:: Create log folder if missing
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

:: Save relative path info
echo LOGDIR=%LOGDIR% >> "%LOGFILE%"
echo LOGFILE=%LOGFILE% >> "%LOGFILE%"
echo Launcher path: run_gui.bat → %LOGFILE% >> "%LOGFILE%"

:: Launch GUI using relative path
python "gui\iptv_gui.py"

if %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ❌ GUI failed to launch with error code %ERRORLEVEL% >> "%LOGFILE%"
    echo ❌ GUI failed to launch. See logs\gui_launch.log for details.
) else (
    echo [%DATE% %TIME%] ✅ GUI launched successfully >> "%LOGFILE%"
)

echo.
pause
