# ─────────────────────────────────────────────
# IPTV Harmonization System — GUI Launcher
# Version: 1.0.0
# Author: Andrew Pearen
# Date: (Get-Date)
# ─────────────────────────────────────────────

Write-Host ""
Write-Host "============================================"
Write-Host "  IPTV Harmonization System — GUI Launcher"
Write-Host "  Version 1.0.0"
Write-Host "  Launching GUI from: gui\iptv_gui.py"
Write-Host "============================================"
Write-Host ""

# Define log path (relative)
$logFolder = "logs"
$logFile = "logs\gui_launch.log"
if (!(Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Log launch attempt
Add-Content -Path $logFile -Value "[{0}] Launching GUI..." -f (Get-Date)

# Launch GUI using relative path
$guiPath = "gui\iptv_gui.py"

try {
    python $guiPath
    if ($LASTEXITCODE -ne 0) {
        Add-Content -Path $logFile -Value "[{0}] ❌ GUI failed with exit code $LASTEXITCODE" -f (Get-Date)
        Write-Host "❌ GUI failed to launch. See logs\gui_launch.log for details."
    } else {
        Add-Content -Path $logFile -Value "[{0}] ✅ GUI launched successfully" -f (Get-Date)
    }
} catch {
    Add-Content -Path $logFile -Value "[{0}] ❌ Exception: $_" -f (Get-Date)
    Write-Host "❌ Exception occurred. See logs\gui_launch.log for details."
}

Write-Host ""
Read-Host "Press Enter to close"
